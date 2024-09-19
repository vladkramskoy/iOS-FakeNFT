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
        servicesAssembly.paymentService.fetchCryptocurrcencies { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let cryptocurrencies):
                guard !cryptocurrencies.isEmpty else {
                    self.view?.hideLoading()
                    return
                }
                
                self.cryptocurrencies = cryptocurrencies
                view?.hideLoading()
                view?.updateData()
            case .failure(let error):
                print("Error in obtaining information about cryptocurrencies:", error)
                
                self.view?.hideLoading()
                self.view?.showErrorAlert()
            }
        }
    }
    
    func handleAgreementButtonTapped() {
        let agreementViewController = AgreementViewController()
        agreementViewController.hidesBottomBarWhenPushed = true
        self.view?.navigateToAgreementViewController(viewController: agreementViewController)
    }
}
