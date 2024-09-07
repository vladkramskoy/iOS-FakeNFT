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
            "profile.myNFT",
            comment: "Text cell in table"
        ),
        NSLocalizedString(
            "profile.favoriteNFT",
            comment: "Text cell in table"
        ),
        NSLocalizedString(
            "profile.about.developer",
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
