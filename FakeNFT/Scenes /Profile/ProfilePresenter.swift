//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by gimon on 07.09.2024.
//

import Foundation

protocol ProfilePresenterProtocol {
    var profileService: ProfileService { get }
    var viewController: ProfileViewControllerProtocol? {set get}
    func getCountCell() -> Int
    func getTextCell(number: Int) -> String
    func loadProfile()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var viewController: ProfileViewControllerProtocol?
    
    var profileService: ProfileService
    
    private let arrayTextCell = [
        NSLocalizedString(
            "Profile.myNFT",
            tableName: "Profile",
            comment: "Text cell in table"
        ),
        NSLocalizedString(
            "Profile.favoriteNFT",
            tableName: "Profile",
            comment: "Text cell in table"
        ),
        NSLocalizedString(
            "Profile.about.developer",
            tableName: "Profile",
            comment: "Text cell in table"
        )
    ]
    
    init(servicesAssembler: ServicesAssembly) {
        self.profileService = servicesAssembler.profileService
    }
    
    func getCountCell() -> Int {
        arrayTextCell.count
    }
    
    func getTextCell(number: Int) -> String {
        var result = ""
        let profile = profileService.getProfileStorage().getProfileData()
        switch number {
        case 0 :
            result = arrayTextCell[number] + " (\(profile?.nfts.count ?? 0))"
        case 1 :
            result = arrayTextCell[number] + " (\(profile?.likes.count ?? 0))"
        default:
            result = arrayTextCell[number]
        }
        return result
    }
    
    func loadProfile() {
        profileService.loadProfile(){ result in
            switch result {
            case .success :
                DispatchQueue.main.async {[weak self] in
                    self?.viewController?.updateProfile()
                }
            case .failure (let error):
                assertionFailure("\(error)")
            }
        }
    }
}
