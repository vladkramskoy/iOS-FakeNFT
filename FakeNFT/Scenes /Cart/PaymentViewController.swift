//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Vladislav Kramskoy on 13.09.2024.
//

import UIKit

protocol PaymentViewControllerProtocol: AnyObject {
    func updateData()
    func navigateToAgreementViewController(viewController: UIViewController)
}

final class PaymentViewController: UIViewController, PaymentViewControllerProtocol {
    var presenter: PaymentPresenterProtocol!
    
    private var selectedIndexPath: IndexPath?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 7
        layout.minimumInteritemSpacing = 7
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "whiteObjectColor")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PaymentCollectionViewCell.self, forCellWithReuseIdentifier: PaymentCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var payButton: UIButton = {
        let payButton = UIButton(type: .system)
        payButton.setTitle("Оплатить", for: .normal)
        payButton.tintColor = UIColor(named: "whiteObjectColor")
        payButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        payButton.layer.cornerRadius = 16
        payButton.backgroundColor = UIColor(named: "darkObjectColor")
        payButton.translatesAutoresizingMaskIntoConstraints = false
        return payButton
    }()
    
    private lazy var agreementLabel: UILabel = {
        let agreementLabel = UILabel()
        agreementLabel.text = "Совершая покупку, вы соглашаетесь с условиями"
        agreementLabel.textColor = UIColor(named: "darkObjectColor")
        agreementLabel.font = UIFont.systemFont(ofSize: 13)
        agreementLabel.translatesAutoresizingMaskIntoConstraints = false
        return agreementLabel
    }()
    
    private lazy var agreementButton: UIButton = {
        let agreementButton = UIButton(type: .system)
        agreementButton.setTitle("Пользовательского соглашения", for: .normal)
        agreementButton.contentHorizontalAlignment = .left
        agreementButton.tintColor = .systemBlue
        agreementButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        agreementButton.addTarget(self, action: #selector(agreementButtonTapped), for: .touchUpInside)
        agreementButton.backgroundColor = .clear
        agreementButton.translatesAutoresizingMaskIntoConstraints = false
        return agreementButton
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupNavigationBar()
        presenter.getListCryptocurrencies()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "whiteObjectColor")
        view.addSubview(collectionView)
        view.addSubview(paymentAreaView)
        paymentAreaView.addSubview(agreementLabel)
        paymentAreaView.addSubview(agreementButton)
        paymentAreaView.addSubview(payButton)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: paymentAreaView.topAnchor, constant: -16),
            
            paymentAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            paymentAreaView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            paymentAreaView.heightAnchor.constraint(equalToConstant: 186),
            
            agreementLabel.topAnchor.constraint(equalTo: paymentAreaView.topAnchor, constant: 16),
            agreementLabel.leadingAnchor.constraint(equalTo: paymentAreaView.leadingAnchor, constant: 16),
            agreementLabel.trailingAnchor.constraint(equalTo: paymentAreaView.trailingAnchor, constant: -16),
            
            agreementButton.topAnchor.constraint(equalTo: agreementLabel.bottomAnchor),
            agreementButton.leadingAnchor.constraint(equalTo: paymentAreaView.leadingAnchor, constant: 16),
            agreementButton.trailingAnchor.constraint(equalTo: paymentAreaView.trailingAnchor, constant: -16),
            
            payButton.leadingAnchor.constraint(equalTo: paymentAreaView.leadingAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: paymentAreaView.trailingAnchor, constant: -16),
            payButton.bottomAnchor.constraint(equalTo: paymentAreaView.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            payButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupNavigationBar() {
        let iconImage = UIImage(named: "backButton")
        let barButtonItem = UIBarButtonItem(image: iconImage, style: .plain, target: self, action: #selector(backButtonTapped))
        barButtonItem.tintColor = UIColor(named: "darkObjectColor")
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    func updateData() {
        collectionView.reloadData()
    }
    
    func navigateToAgreementViewController(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func payButtonTapped() {
        print("pay button tapped")
    }
    
    @objc private func agreementButtonTapped() {
        presenter.handleAgreementButtonTapped()
    }
}

extension PaymentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.cryptocurrencies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PaymentCollectionViewCell.identifier, for: indexPath) as? PaymentCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let presenter = presenter {
            guard indexPath.row >= 0 && indexPath.row < presenter.cryptocurrencies.count else {
                return PaymentCollectionViewCell()
            }
            
            let cryptocurrency = presenter.cryptocurrencies[indexPath.row]
            cell.configure(currencyName: cryptocurrency.title, currencySymbol: cryptocurrency.name, image: cryptocurrency.image)
        }
        
        cell.backgroundColor = UIColor(named: "paymentAreaColor")
        return cell
    }
}

extension PaymentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let previousIndexPath = selectedIndexPath {
            let previousCell = collectionView.cellForItem(at: previousIndexPath)
            previousCell?.layer.borderWidth = 0
            previousCell?.layer.borderColor = UIColor.clear.cgColor
        }
        
        let currentCell = collectionView.cellForItem(at: indexPath)
        currentCell?.layer.borderWidth = 1
        currentCell?.layer.borderColor = UIColor(named: "darkObjectColor")?.cgColor
        
        selectedIndexPath = indexPath
    }
}

extension PaymentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat
        let maxWidth = collectionView.bounds.width / 2 - 3.5
        width = max(168, maxWidth)
        
        return CGSize(width: width, height: 46)
    }
}

