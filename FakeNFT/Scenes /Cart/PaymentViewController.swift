//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Vladislav Kramskoy on 13.09.2024.
//

import UIKit

protocol PaymentViewControllerProtocol: AnyObject {
    func updateData()
}

final class PaymentViewController: UIViewController, PaymentViewControllerProtocol {
    var presenter: PaymentPresenterProtocol!
    
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
    
    private lazy var agreementTextView: UITextView = {
        let agreementTextView = UITextView()
        let text = "Совершая покупку, вы соглашаетесь с условиями Пользовательского соглашения"
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        
        if let range = text.range(of: "Пользовательского соглашения") {
            let nsRange = NSRange(range, in: text)
            
            attributedString.addAttribute(.link, value: "https://yandex.ru/legal/practicum_termsofuse/", range: nsRange)
        }
        
        agreementTextView.backgroundColor = UIColor(named: "paymentAreaColor")
        agreementTextView.attributedText = attributedString
        agreementTextView.isEditable = false
        agreementTextView.isScrollEnabled = false
        agreementTextView.dataDetectorTypes = .link
        agreementTextView.textColor = UIColor(named: "darkObjectColor")
        agreementTextView.font = UIFont.systemFont(ofSize: 13)
        agreementTextView.translatesAutoresizingMaskIntoConstraints = false
        return agreementTextView
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
        paymentAreaView.addSubview(agreementTextView)
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
            
            agreementTextView.leadingAnchor.constraint(equalTo: paymentAreaView.leadingAnchor, constant: 16),
            agreementTextView.trailingAnchor.constraint(equalTo: paymentAreaView.trailingAnchor, constant: -16),
            agreementTextView.bottomAnchor.constraint(equalTo: payButton.topAnchor, constant: -16),
            
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
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func payButtonTapped() {
        print("pay button tapped")
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
        
        let cryptoName = presenter.cryptocurrencies[indexPath.item].name
        cell.configure(with: cryptoName)
        
        cell.backgroundColor = .gray
        return cell
    }
}

extension PaymentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.row) was tapped")
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

