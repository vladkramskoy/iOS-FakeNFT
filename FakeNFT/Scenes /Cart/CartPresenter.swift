//
//  CartPresenter.swift
//  FakeNFT
//
//  Created by Vladislav Kramskoy on 08.09.2024.
//

import UIKit

protocol CartPresenterProtocol: AnyObject {
    var data: [CartNft] { get }
    
    func loadData()
    func didTapDeleteButton(cell: CartTableViewCell)
    func calculateTotalPrice() -> Float
}

final class CartPresenter: CartPresenterProtocol {
    private weak var view: CartViewControllerProtocol?
    private let servicesAssembly: ServicesAssembly
    private let orderService: OrderService
    
    var data: [CartNft] = []
    
    init(view: CartViewControllerProtocol, servicesAssembly: ServicesAssembly) {
        self.view = view
        self.servicesAssembly = servicesAssembly
        self.orderService = servicesAssembly.orderService
    }
    
    private func fetchCartNfts() {
        orderService.fetchOrderNfts { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let nftIds):
                guard !nftIds.isEmpty else {
                    self.view?.hideLoading()
                    return
                }
                var remainingRequests = nftIds.count
                
                for nftId in nftIds {
                    self.orderService.fetchNftDetails(for: nftId) { [weak self] detailResult in
                        guard let self else { return }
                        
                        switch detailResult {
                        case .success(let nftDetail):
                            self.orderService.convertToCartNft(from: nftDetail) { [weak self] cartNft in
                                guard let self else { return }
                                
                                if let cartNft = cartNft {
                                    self.data.append(cartNft)
                                    print("\(cartNft)")
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
                                view?.showErrorAlert()
                            }
                        }
                    }
                }
            case .failure(let error):
                print("Error in receiving NFT details:", error)
                
                self.view?.hideLoading()
                view?.showErrorAlert()
            }
        }
    }
    
    func loadData() {
        fetchCartNfts()
    }
    
    func didTapDeleteButton(cell: CartTableViewCell) {
        let deleteViewController = DeleteViewController(image: cell.nftImageView.image ?? UIImage())
        deleteViewController.modalPresentationStyle = .overFullScreen
        view?.navigateToDeleteViewController(viewController: deleteViewController)
    }
    
    func calculateTotalPrice() -> Float {
        return data.reduce(0) { $0 + $1.price }
    }
}
