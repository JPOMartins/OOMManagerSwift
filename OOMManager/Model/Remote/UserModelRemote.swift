//
//  UserModelRemote.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//

import Foundation

struct UserModelRemoteItem: Codable {
    var email: String
    var idUser: Int
    var name: String
    var type: String

    enum CodingKeys: String, CodingKey {
        case email
        case idUser = "idUser"
        case name
        case type
    }
}

