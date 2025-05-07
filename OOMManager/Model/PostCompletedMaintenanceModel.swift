//
//  PostCompletedMaintenanceModel.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//

import SwiftData

@Model
class PostCompletedMaintenanceModel {
    @Attribute(.unique) var idPostCompletedMaintenances: Int
    var startedDate: String
    var completedDate: String?
    var observation: String?
    var maintenanceID: Int
    var userID: Int?

    init(
        idPostCompletedMaintenances: Int = 0,
        startedDate: String,
        completedDate: String? = nil,
        observation: String? = nil,
        maintenanceID: Int,
        userID: Int? = nil
    ) {
        self.idPostCompletedMaintenances = idPostCompletedMaintenances
        self.startedDate = startedDate
        self.completedDate = completedDate
        self.observation = observation
        self.maintenanceID = maintenanceID
        self.userID = userID
    }
}

