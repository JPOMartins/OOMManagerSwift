//
//  AppVersionModel.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//

import SwiftData

@Model
class AppVersionModel {
    @Attribute(.unique) var id: Int
    var version: String

    init(id: Int = 0, version: String) {
        self.id = id
        self.version = version
    }
}


