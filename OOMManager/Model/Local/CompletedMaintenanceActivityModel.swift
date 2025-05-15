//
//  CompletedMaintenanceActivityModel.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//
import SwiftData

@Model
class CompletedMaintenanceActivityModel {
    @Attribute(.unique) var idCompletedMaintenanceActivity: Int
    var startedDate: String
    var completedDate: String?
    var observation: String?
    var maintenanceID: Int
    var userID: Int?

    // Associação 1:N com tarefas concluídas
    @Relationship(deleteRule: .cascade, inverse: \CompletedTaskActivityModel.maintenanceActivity)
    var tasks: [CompletedTaskActivityModel] = []

    init(
        idCompletedMaintenanceActivity: Int = 0,
        startedDate: String,
        completedDate: String? = nil,
        observation: String? = nil,
        maintenanceID: Int,
        userID: Int? = nil
    ) {
        self.idCompletedMaintenanceActivity = idCompletedMaintenanceActivity
        self.startedDate = startedDate
        self.completedDate = completedDate
        self.observation = observation
        self.maintenanceID = maintenanceID
        self.userID = userID
    }
}

