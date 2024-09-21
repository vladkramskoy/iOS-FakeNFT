//
//  EditProfileRequest.swift
//  FakeNFT
//
//  Created by gimon on 16.09.2024.
//

import Foundation

struct EditProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    var httpMethod: HttpMethod = .put
    var dto: Dto?
}

struct EditProfileDtoObject: Dto {
    let name: String
    let description: String
    let website: String
    let avatar: String
    let likes: [String]
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case description = "description"
        case website = "website"
        case avatar = "avatar"
        case likes = "likes"
    }
    
    func asDictionary() -> [String : String] {
        [
            CodingKeys.name.rawValue: name,
            CodingKeys.description.rawValue: description,
            CodingKeys.website.rawValue: website,
            CodingKeys.avatar.rawValue: avatar,
            //TODO: - add CodingKeys.likes.rawValue: likes
        ]
    }
}
