//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Vladislav Kramskoy on 08.09.2024.
//

import UIKit

protocol CartViewControllerProtocol: AnyObject {
    func updateView()
    func navigateToDeleteViewController(viewController: UIViewController)
    func navigateToPaymentViewController(viewController: UIViewController)
    func showLoading()
    func hideLoading()
    func showErrorAlert()
    func showDeletionErrorAlert()
}

final class CartViewController: UIViewController, CartViewControllerProtocol {
    var presenter: CartPresenterProtocol?
    
    private let currencySymbol = "ETH"
    private let nftLabel = "NFT"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(named: "whiteObjectColor")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var paymentButton: UIButton = {
        let paymentButton = UIButton(type: .system)
        paymentButton.setTitle("К оплате", for: .normal)
        paymentButton.tintColor = UIColor(named: "whiteObjectColor")
        paymentButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        paymentButton.addTarget(self, action: #selector(paymentButtonTapped), for: .touchUpInside)
        paymentButton.layer.cornerRadius = 16
        paymentButton.backgroundColor = UIColor(named: "darkObjectColor")
        paymentButton.translatesAutoresizingMaskIntoConstraints = false
        return paymentButton
    }()
    
    private lazy var nftCountLabel: UILabel = {
        let nftCountLabel = UILabel()
        if let presenter = presenter {
            nftCountLabel.text = "\(presenter.cartNfts.count) \(nftLabel)"
        } else {
            nftCountLabel.text = "0 NFT"
        }
        nftCountLabel.textColor = UIColor(named: "darkObjectColor")
        nftCountLabel.font = UIFont.systemFont(ofSize: 15)
        nftCountLabel.translatesAutoresizingMaskIntoConstraints = false
        return nftCountLabel
    }()
    
    private lazy var sumLabel: UILabel = {
        let sumLabel = UILabel()
        let sum = presenter?.calculateTotalPrice() ?? Float()
        sumLabel.text = "\(sum) ETH"
        sumLabel.textColor = UIColor(named: "sumTextColor")
        sumLabel.font = UIFont.boldSystemFont(ofSize: 17)
        sumLabel.translatesAutoresizingMaskIntoConstraints = false
        return sumLabel
    }()
    
    private lazy var paymentAreaView: UIView = {
        let paymentAreaView = UIView()
        paymentAreaView.layer.cornerRadius = 16
        paymentAreaView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        paymentAreaView.layer.masksToBounds = true
        paymentAreaView.backgroundColor = UIColor(named: "paymentAreaColor")
        paymentAreaView.translatesAutoresizingMaskIntoConstraints = false
        return paymentAreaView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    func updateView() {
        let updateSum = presenter?.calculateTotalPrice() ?? Float()
        let updateCountNft = presenter?.cartNfts.count ?? Int()
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.nftCountLabel.text = "\(updateCountNft) NFT"
            self.sumLabel.text = "\(updateSum) ETH"
            self.tableView.reloadData()
        }
    }
    
    func navigateToDeleteViewController(viewController: UIViewController) {
        present(viewController, animated: true)
    }
    
    func navigateToPaymentViewController(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showErrorAlert() {
        let alertController = UIAlertController(title: "Не удалось загрузить корзину", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in }
        let retryAction = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            guard let self else { return }
            self.loadData()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(retryAction)
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.present(alertController, animated: true)
        }
    }
    
    func showDeletionErrorAlert() {
        let alertController = UIAlertController(title: "Не удалось удалить позицию. Попробуйте еще раз", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ок", style: .default) { _ in }
        
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.present(alertController, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupUI()
        setupNavigationBar()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(named: "whiteObjectColor")
        view.addSubview(tableView)
        view.addSubview(paymentAreaView)
        view.addSubview(activityIndicator)
        paymentAreaView.addSubview(paymentButton)
        paymentAreaView.addSubview(nftCountLabel)
        paymentAreaView.addSubview(sumLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: paymentButton.topAnchor, constant: -16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            paymentAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            paymentAreaView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            paymentAreaView.heightAnchor.constraint(equalToConstant: 76),
            
            paymentButton.trailingAnchor.constraint(equalTo: paymentAreaView.trailingAnchor, constant: -16),
            paymentButton.bottomAnchor.constraint(equalTo: paymentAreaView.bottomAnchor, constant: -16),
            paymentButton.heightAnchor.constraint(equalToConstant: 44),
            
            nftCountLabel.leadingAnchor.constraint(equalTo: paymentAreaView.leadingAnchor, constant: 16),
            nftCountLabel.bottomAnchor.constraint(equalTo: sumLabel.topAnchor, constant: -2),
            
            sumLabel.leadingAnchor.constraint(equalTo: paymentAreaView.leadingAnchor, constant: 16),
            sumLabel.trailingAnchor.constraint(equalTo: paymentButton.leadingAnchor, constant: -24),
            sumLabel.bottomAnchor.constraint(equalTo: paymentAreaView.bottomAnchor, constant: -16),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupNavigationBar() {
        let iconImage = UIImage(named: "lineHorizontal")
        let barButtonItem = UIBarButtonItem(image: iconImage, style: .plain, target: self, action: #selector(hamburgerMenuTapped))
        barButtonItem.tintColor = UIColor(named: "darkObjectColor")
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc private func hamburgerMenuTapped() {
        //TODO: - process code
    }
    
    @objc private func paymentButtonTapped() {
        presenter?.handlePaymentButtonTapped()
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.cartNfts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier, for: indexPath) as? CartTableViewCell else {
            return UITableViewCell()
        }
        
        if let presenter = presenter {
            guard indexPath.row >= 0 && indexPath.row < presenter.cartNfts.count else {
                return UITableViewCell()
            }
            
            let nft = presenter.cartNfts[indexPath.row]
            
            cell.configure(image: nft.image, 
                           name: nft.name,
                           rating: nft.rating,
                           price: "\(nft.price) \(currencySymbol)")
            
            cell.onDeleteButtonTapped = { [weak self] in
                guard self != nil else { return }
                presenter.didTapDeleteButton(image: nft.image, id: nft.id)
            }
        }

        cell.backgroundColor = UIColor(named: "whiteObjectColor")
        cell.selectionStyle = .none
        return cell
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension CartViewController {
    private func loadData() {
        showLoading()
        presenter?.loadData()
    }
    
    func showLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.activityIndicator.startAnimating()
            self.view.isUserInteractionEnabled = false
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
}


