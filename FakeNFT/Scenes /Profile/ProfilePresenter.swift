//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by gimon on 07.09.2024.
//

import Foundation

protocol ProfilePresenterProtocol {
    var profileData: ProfileData? { get }
    var viewController: ProfileViewControllerProtocol? { set get }
    var cellsCount: Int { get }
    func getTextCell(number: Int) -> String
    func loadProfile()
    func editProfile(profile: ProfileData)
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var viewController: ProfileViewControllerProtocol?
    
    lazy var cellsCount: Int = arrayTextCell.count
    var profileData: ProfileData? {
        profileService.getProfileStorage().getProfileData()
    }
    
    private var profileService: ProfileService
    private var editProfileServices: EditProfileServices
    private let arrayTextCell = [
        LocalizedText.myNFT,
        LocalizedText.favoriteNFT,
        LocalizedText.aboutDeveloper
    ]
    
    init(servicesAssembler: ServicesAssembly) {
        self.profileService = servicesAssembler.profileService
        self.editProfileServices = servicesAssembler.editProfileServices
    }
    
    func getTextCell(number: Int) -> String {
        var result: String
        switch number {
        case 0 :
            result = arrayTextCell[number] + " (\(profileData?.nfts.count ?? 0))"
        case 1 :
            result = arrayTextCell[number] + " (\(profileData?.likes.count ?? 0))"
        default:
            result = arrayTextCell[number]
        }
        return result
    }
    
    func loadProfile() {
        profileService.loadProfile() { result in
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
    
    func editProfile(profile: ProfileData) {
        viewController?.hideViewElements()
        editProfileServices.sendEditProfileRequest(
            name: profile.name,
            description: profile.description,
            website: profile.website,
            avatar: profile.avatar,
            likes: profile.likes){ result in
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
