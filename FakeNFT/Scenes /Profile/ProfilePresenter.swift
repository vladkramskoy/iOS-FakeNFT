//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by gimon on 07.09.2024.
//

import Foundation

protocol ProfilePresenterProtocol {
    var viewController: ProfileViewControllerProtocol? {set get}
    func getCountCell() -> Int
    func getTextCell(number: Int) -> String
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var viewController: ProfileViewControllerProtocol?
    
    let arrayTextCell = [
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
    
    func getCountCell() -> Int {
        arrayTextCell.count
    }
    
    func getTextCell(number: Int) -> String {
        //TODO: - add count collections NFT
        arrayTextCell[number]
    }
}
