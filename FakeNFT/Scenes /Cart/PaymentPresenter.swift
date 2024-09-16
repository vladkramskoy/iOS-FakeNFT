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
            Cryptocurrency(title: "Bitcoin", name: "BTC", image: UIImage(named: "coinMock1") ?? UIImage(), id: "1"),
            Cryptocurrency(title: "Dogecoin", name: "DOGE", image: UIImage(named: "coinMock2") ?? UIImage(), id: "2"),
            Cryptocurrency(title: "Tether", name: "USDT", image: UIImage(named: "coinMock3") ?? UIImage(), id: "3"),
            Cryptocurrency(title: "Apecoin", name: "APE", image: UIImage(named: "coinMock4") ?? UIImage(), id: "4")
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
