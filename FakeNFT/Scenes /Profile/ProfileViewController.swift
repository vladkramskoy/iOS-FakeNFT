//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by gimon on 07.09.2024.
//

import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject, LoadingView {
    func updateProfile()
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    //MARK: - Visual Components
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    private lazy var editProfileButton: UIButton = {
        guard let image = UIImage(named: "edit") else {
            assertionFailure("error create image editProfileButton")
            return UIButton()
        }
        let view = UIButton.systemButton(
            with: image,
            target: self,
            action: #selector(clickEditProfileButton)
        )
        view.tintColor = .closeButton
        view.isHidden = true
        return view
    }()
    
    private let imageProfile: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 35
        view.isHidden = true
        return view
    }()
    
    private let userName: UILabel = {
        let view = UILabel()
        view.textColor = .closeButton
        view.font = .headline3
        view.textAlignment = .left
        view.isHidden = true
        return view
    }()
    
    private let userDescription: UILabel = {
        let view = UILabel()
        view.textColor = .closeButton
        view.font = .caption2
        view.textAlignment = .left
        view.numberOfLines = 0
        view.isHidden = true
        return view
    }()
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .backgroundColor
        view.separatorStyle = .none
        view.isHidden = true
        return view
    }()
    
    //MARK: - Private Property
    private let cellReuseIdentifier = "profileCellReuseIdentifier"
    private var presenter: ProfilePresenterProtocol
    
    //MARK: - Initialization
    init(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor
        
        presenter.viewController = self
        
        [
            editProfileButton,
            imageProfile,
            userName,
            userDescription,
            tableView,
            activityIndicator
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        tableView.register(
            ProfileTableCell.self,
            forCellReuseIdentifier: cellReuseIdentifier
        )
        
        tableView.delegate = self
        tableView.dataSource = self
        
        activityIndicator.constraintCenters(to: view)
        addConstraintEditProfileButton()
        addConstraintImageProfile()
        addConstraintUserName()
        addConstraintUserDescription()
        addConstraintTableView()
        
        self.showLoading()
        presenter.loadProfile()
        updateProfile()
    }
    
    func updateProfile() {
        if let profile: ProfileData = presenter.profileService.getProfileStorage().getProfileData() {
            let url = URL(string: profile.avatar)
            let processor = RoundCornerImageProcessor(cornerRadius: 70)
            imageProfile.kf.setImage(
                with: url,
                options: [.processor(processor)]
            )
            userName.text = profile.name
            userDescription.text = profile.description
            tableView.reloadData()
            [
                editProfileButton,
                imageProfile,
                userName,
                userDescription,
                tableView
            ].forEach{
                $0.isHidden = false
            }
            self.hideLoading()
        }
    }
    
    //MARK: - Private Methods
    @objc private func clickEditProfileButton(){
        //TODO: - add body
    }
    
    private func addConstraintEditProfileButton(){
        NSLayoutConstraint.activate([
            editProfileButton.widthAnchor.constraint(equalToConstant: 42),
            editProfileButton.heightAnchor.constraint(equalToConstant: 42),
            editProfileButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            editProfileButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -9)
        ])
    }
    
    private func addConstraintImageProfile(){
        NSLayoutConstraint.activate([
            imageProfile.widthAnchor.constraint(equalToConstant: 70),
            imageProfile.heightAnchor.constraint(equalToConstant: 70),
            imageProfile.topAnchor.constraint(equalTo: editProfileButton.bottomAnchor, constant: 20),
            imageProfile.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func addConstraintUserName(){
        NSLayoutConstraint.activate([
            userName.centerYAnchor.constraint(equalTo: imageProfile.centerYAnchor),
            userName.leadingAnchor.constraint(equalTo: imageProfile.trailingAnchor, constant: 16)
        ])
    }
    
    private func addConstraintUserDescription(){
        NSLayoutConstraint.activate([
            userDescription.topAnchor.constraint(equalTo: imageProfile.bottomAnchor, constant: 20),
            userDescription.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userDescription.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func addConstraintTableView(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: userDescription.bottomAnchor, constant: 40),
            tableView.heightAnchor.constraint(equalToConstant: 162),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

//MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getCountCell()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: cellReuseIdentifier,
            for: indexPath
        ) as? ProfileTableCell else {
            return UITableViewCell()
        }
        let text = presenter.getTextCell(number: indexPath.row)
        cell.setTextInCell(text: text)
        return cell
    }
}
