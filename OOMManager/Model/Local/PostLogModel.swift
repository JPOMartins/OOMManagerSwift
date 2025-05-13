//
//  PostLogModel.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//

import SwiftData

@Model
class PostLogModel {
    @Attribute(.unique) var idLog: Int
    var title: String?
    var observations: String?
    var startedDate: String
    var completedDate: String?
    var equipmentID: Int
    var userID: Int?

    init(
        idLog: Int = 0,
        title: String? = nil,
        observations: String? = nil,
        startedDate: String,
        completedDate: String? = nil,
        equipmentID: Int,
        userID: Int? = nil
    ) {
        self.idLog = idLog
        self.title = title
        self.observations = observations
        self.startedDate = startedDate
        self.completedDate = completedDate
        self.equipmentID = equipmentID
        self.userID = userID
    }
}
