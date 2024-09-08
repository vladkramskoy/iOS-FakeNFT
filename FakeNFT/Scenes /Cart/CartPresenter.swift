//
//  CartPresenter.swift
//  FakeNFT
//
//  Created by Vladislav Kramskoy on 08.09.2024.
//

import Foundation

protocol CartPresenterProtocol: AnyObject {
    var data: [String] { get }
    
    func nftForIndexPath(at indexPath: IndexPath) -> String
}

final class CartPresenter: CartPresenterProtocol {
    private weak var view: CartViewControllerProtocol?
    private let servicesAssembly: ServicesAssembly
    var data = ["NFT 1", "NFT 2", "NFT 3"]
    
    init(view: CartViewControllerProtocol, servicesAssembly: ServicesAssembly) {
        self.view = view
        self.servicesAssembly = servicesAssembly
    }
    
    func loadData() {
        //TODO: - process code
        view?.updateView()
    }
    
    func nftForIndexPath(at indexPath: IndexPath) -> String {
        return data[indexPath.row]
    }
}
