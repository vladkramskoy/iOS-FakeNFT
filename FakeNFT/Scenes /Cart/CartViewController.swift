//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Vladislav Kramskoy on 08.09.2024.
//

import UIKit

protocol CartViewControllerProtocol: AnyObject {
    func updateView()
}

final class CartViewController: UIViewController, CartViewControllerProtocol {
    var presenter: CartPresenterProtocol?
    
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
    
    private lazy var payButton: UIButton = {
        let payButton = UIButton(type: .system)
        payButton.setTitle("К оплате", for: .normal)
        payButton.tintColor = UIColor(named: "whiteObjectColor")
        payButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        payButton.layer.cornerRadius = 16
        payButton.backgroundColor = UIColor(named: "darkObjectColor")
        payButton.translatesAutoresizingMaskIntoConstraints = false
        return payButton
    }()
    
    private lazy var nftCountLabel: UILabel = {
        let nftCountLabel = UILabel()
        if let presenter = presenter {
            nftCountLabel.text = "\(presenter.data.count) NFT"
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
        sumLabel.text = "5,34 ETH"
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
    
    func updateView() {
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(named: "whiteObjectColor")
        view.addSubview(tableView)
        view.addSubview(paymentAreaView)
        paymentAreaView.addSubview(payButton)
        paymentAreaView.addSubview(nftCountLabel)
        paymentAreaView.addSubview(sumLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: payButton.topAnchor, constant: -16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            paymentAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            paymentAreaView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            paymentAreaView.heightAnchor.constraint(equalToConstant: 76),
            
            payButton.trailingAnchor.constraint(equalTo: paymentAreaView.trailingAnchor, constant: -16),
            payButton.bottomAnchor.constraint(equalTo: paymentAreaView.bottomAnchor, constant: -16),
            payButton.heightAnchor.constraint(equalToConstant: 44),
            
            nftCountLabel.leadingAnchor.constraint(equalTo: paymentAreaView.leadingAnchor, constant: 16),
            nftCountLabel.bottomAnchor.constraint(equalTo: sumLabel.topAnchor, constant: -2),
            
            sumLabel.leadingAnchor.constraint(equalTo: paymentAreaView.leadingAnchor, constant: 16),
            sumLabel.trailingAnchor.constraint(equalTo: payButton.leadingAnchor, constant: -24),
            sumLabel.bottomAnchor.constraint(equalTo: paymentAreaView.bottomAnchor, constant: -16)
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
    
    @objc private func payButtonTapped() {
        //TODO: - process code
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier, for: indexPath) as? CartTableViewCell else {
            return UITableViewCell()
        }
        if let presenter = presenter {
            let nft = presenter.nftForIndexPath(at: indexPath)
            cell.configure(with: "\(nft)")
        } else {
            cell.configure(with: "Unknown NFT")
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



