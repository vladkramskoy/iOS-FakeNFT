//
//  LocalizedText.swift
//  FakeNFT
//
//  Created by gimon on 12.09.2024.
//

import Foundation

enum LocalizedText {
    static let myNFT = NSLocalizedString(
        "Profile.myNFT",
        tableName: "Profile",
        comment: "Text cell in table"
    )
    static let favoriteNFT = NSLocalizedString(
        "Profile.favoriteNFT",
        tableName: "Profile",
        comment: "Text cell in table"
    )
    static let aboutDeveloper = NSLocalizedString(
        "Profile.about.developer",
        tableName: "Profile",
        comment: "Text cell in table"
    )
}
