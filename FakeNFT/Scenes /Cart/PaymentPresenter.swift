//
//  PaymentPresenter.swift
//  FakeNFT
//
//  Created by Vladislav Kramskoy on 13.09.2024.
//

import UIKit

protocol PaymentPresenterProtocol {
    var cryptocurrencies: [Cryptocurrency] { get }
    
    func getListCryptocurrencies()
    func handleAgreementButtonTapped()
}

final class PaymentPresenter: PaymentPresenterProtocol {
    var cryptocurrencies: [Cryptocurrency] = []
    weak var view: PaymentViewControllerProtocol?
    
    private let servicesAssembly: ServicesAssembly
    
    init(view: PaymentViewControllerProtocol, servicesAssembly: ServicesAssembly) {
        self.view = view
        self.servicesAssembly = servicesAssembly
    }
    
    func getListCryptocurrencies() {
        let cryptocurrencies = [
            Cryptocurrency(title: "Bitcoin", name: "BTC", image: UIImage(), id: "1"),
            Cryptocurrency(title: "Ethereum", name: "ETH", image: UIImage(), id: "2"),
            Cryptocurrency(title: "Ripple", name: "XRP", image: UIImage(), id: "3"),
            Cryptocurrency(title: "Litecoin", name: "LTC", image: UIImage(), id: "4")
        ]
        
        self.cryptocurrencies = cryptocurrencies
        
        view?.updateData()
    }
    
    func handleAgreementButtonTapped() {
        let agreementViewController = AgreementViewController()
        agreementViewController.hidesBottomBarWhenPushed = true
        self.view?.navigateToAgreementViewController(viewController: agreementViewController)
    }
}
