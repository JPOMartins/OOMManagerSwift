//
//  UserModel.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//

import SwiftData

@Model
class UserModel {
    @Attribute(.unique) var idUser: Int
    var name: String
    var email: String
    var type: String

    init(
        idUser: Int,
        name: String,
        email: String,
        type: String
    ) {
        self.idUser = idUser
        self.name = name
        self.email = email
        self.type = type
    }
}

