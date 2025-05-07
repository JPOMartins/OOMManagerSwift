//
//  LogActivityModel.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//

import SwiftData

@Model
class LogActivityModel {
    @Attribute(.unique) var idLogActivity: Int
    var title: String?
    var observations: String?
    var startedDate: String
    var completedDate: String?
    var equipmentID: Int
    var userID: Int?

    init(
        idLogActivity: Int = 0,
        title: String? = nil,
        observations: String? = nil,
        startedDate: String,
        completedDate: String? = nil,
        equipmentID: Int,
        userID: Int? = nil
    ) {
        self.idLogActivity = idLogActivity
        self.title = title
        self.observations = observations
        self.startedDate = startedDate
        self.completedDate = completedDate
        self.equipmentID = equipmentID
        self.userID = userID
    }
}
