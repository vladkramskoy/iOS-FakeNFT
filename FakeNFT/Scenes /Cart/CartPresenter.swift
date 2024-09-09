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
}

final class CartPresenter: CartPresenterProtocol {
    private weak var view: CartViewControllerProtocol?
    private let servicesAssembly: ServicesAssembly
    var data: [CartNft] = []
    
    init(view: CartViewControllerProtocol, servicesAssembly: ServicesAssembly) {
        self.view = view
        self.servicesAssembly = servicesAssembly
    }
    
    func loadData() {
        //TODO: - process code
        
        let nft1 = CartNft(name: "April", image: UIImage(named: "nftMock1") ?? UIImage(), rating: 1, price: 1.78)
        let nft2 = CartNft(name: "Greena", image: UIImage(named: "nftMock2") ?? UIImage(), rating: 3, price: 1.78)
        let nft3 = CartNft(name: "Spring", image: UIImage(named: "nftMock3") ?? UIImage(), rating: 5, price: 1.78)
        
        data = [nft1, nft2, nft3]
        
        view?.updateView()
    }
    
    func didTapDeleteButton(cell: CartTableViewCell) {
        let deleteViewController = DeleteViewController(image: cell.nftImageView.image ?? UIImage())
        deleteViewController.modalPresentationStyle = .overFullScreen
        view?.navigateToDeleteViewController(viewController: deleteViewController)
    }
}
