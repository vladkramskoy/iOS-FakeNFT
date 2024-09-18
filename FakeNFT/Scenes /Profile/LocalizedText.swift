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
    static let tittleName = NSLocalizedString(
        "Edit.profile.tittle.name",
        tableName: "Profile",
        comment: "Text tittle"
    )
    static let tittleDescription = NSLocalizedString(
        "Edit.profile.tittle.description",
        tableName: "Profile",
        comment: "Text tittle"
    )
    static let tittleSite = NSLocalizedString(
        "Edit.profile.tittle.site",
        tableName: "Profile",
        comment: "Text tittle"
    )
    static let tittleAlert = NSLocalizedString(
        "Edit.profile.tittle.alert",
        tableName: "Profile",
        comment: "Text tittle alert"
    )
    static let cancelButton = NSLocalizedString(
        "Edit.profile.alert.cancel.button",
        tableName: "Profile",
        comment: "Text button alert"
    )
    static let okButton = NSLocalizedString(
        "Edit.profile.alert.ok.button",
        tableName: "Profile",
        comment: "Text button alert"
    )
    static let alertPlaceholder = NSLocalizedString(
        "Edit.profile.alert.placeholder",
        tableName: "Profile",
        comment: "Text placeholder alert"
    )
    static let cellFrom = NSLocalizedString(
        "My.NFT.cell.from",
        tableName: "Profile",
        comment: "Text from"
    )
    static let cellPrice = NSLocalizedString(
        "My.NFT.cell.price",
        tableName: "Profile",
        comment: "Text price"
    )
}
