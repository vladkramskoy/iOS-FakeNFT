//
//  CartPresenter.swift
//  FakeNFT
//
//  Created by Vladislav Kramskoy on 08.09.2024.
//

import UIKit

protocol CartPresenterProtocol: AnyObject {
    var cartNfts: [CartNft] { get }
    
    func loadData()
    func didTapDeleteButton(image: UIImage, id: String)
    func calculateTotalPrice() -> Float
    func removePositionFromCart(id: String)
}

final class CartPresenter: CartPresenterProtocol {
    var cartNfts: [CartNft] = []
    
    private weak var view: CartViewControllerProtocol?
    private let servicesAssembly: ServicesAssembly
    private let orderService: OrderService
    
    init(view: CartViewControllerProtocol, servicesAssembly: ServicesAssembly) {
        self.view = view
        self.servicesAssembly = servicesAssembly
        self.orderService = servicesAssembly.orderService
    }
    
    private func getCartNfts() {
        orderService.fetchOrderNfts { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let nftIds):
                guard !nftIds.isEmpty else {
                    self.view?.hideLoading()
                    return
                }
                
                self.processNftIds(nftIds)
                
            case .failure(let error):
                print("Error in receiving NFT details:", error)
                
                self.view?.hideLoading()
                self.view?.showErrorAlert()
            }
        }
    }
    
    private func processNftIds(_ nftIds: [String]) {
        var remainingRequests = nftIds.count
        
        for nftId in nftIds {
            self.orderService.fetchNftDetails(for: nftId) { [weak self] detailResult in
                guard let self else { return }
                
                switch detailResult {
                case .success(let nftDetail):
                    self.orderService.convertToCartNft(from: nftDetail) { [weak self] cartNft in
                        guard let self else { return }
                        
                        if let cartNft = cartNft {
                            self.cartNfts.append(cartNft)
                        } else {
                            print("Error when converting NFT")
                        }
                        
                        remainingRequests -= 1
                        if remainingRequests == 0 {
                            self.view?.hideLoading()
                            self.view?.updateView()
                        }
                        
                    }
                case .failure(let error):
                    print("Error in receiving NFT details:", error)
                    
                    remainingRequests -= 1
                    if remainingRequests == 0 {
                        self.view?.hideLoading()
                        self.view?.showErrorAlert()
                    }
                }
            }
        }
    }
    
    func loadData() {
        getCartNfts()
    }
    
    func didTapDeleteButton(image: UIImage, id: String) {
        let deleteViewController = DeleteViewController()
        let deletePresenter = DeletePresenter(view: deleteViewController, servicesAssembly: servicesAssembly, image: image, id: id)
        deletePresenter.removePositionClosure = self.getRemovePositionClosure()
        deleteViewController.presenter = deletePresenter
        deleteViewController.modalPresentationStyle = .overFullScreen
        view?.navigateToDeleteViewController(viewController: deleteViewController)
    }
    
    func calculateTotalPrice() -> Float {
        let price: Float = cartNfts.reduce(0) { $0 + $1.price }
        let roundedPrice = round(price * 10000) / 10000
        return roundedPrice
    }
    
    func removePositionFromCart(id: String) {
        view?.showLoading()
        servicesAssembly.orderService.deleteNftRequest(withId: id, from: cartNfts) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let updateData):
                self.cartNfts = updateData
                view?.updateView()
                view?.hideLoading()
                
                print("Позиция \(id) удалена")
            case .failure(_):
                view?.hideLoading()
                view?.showDeletionErrorAlert()
            }
        }
    }
    
    func getRemovePositionClosure() -> (String) -> Void {
        return { [weak self] id in
            self?.removePositionFromCart(id: id)
        }
    }
}
