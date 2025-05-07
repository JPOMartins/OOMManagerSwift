//
//  LogModel.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//

import SwiftData

@Model
class LogModel {
    @Attribute(.unique) var idLog: Int
    var title: String
    var idEquipment: Int
    var userID: Int
    var observations: String
    var startedDate: String
    var completedDate: String

    init(
        idLog: Int,
        title: String,
        idEquipment: Int,
        userID: Int,
        observations: String,
        startedDate: String,
        completedDate: String
    ) {
        self.idLog = idLog
        self.title = title
        self.idEquipment = idEquipment
        self.userID = userID
        self.observations = observations
        self.startedDate = startedDate
        self.completedDate = completedDate
    }
}
