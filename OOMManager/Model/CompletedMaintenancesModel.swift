//
//  CompletedMaintenancesModel.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.

import SwiftData

@Model
class CompletedMaintenanceModel {
    @Attribute(.unique) var idCompletedMaintenance: Int
    var completedDate: String
    var startedDate: String
    var observation: String

    // Relacionamentos simulados por ID (simples)
    var idMaintenance: Int
    var idUser: Int

    init(
        idCompletedMaintenance: Int,
        completedDate: String,
        startedDate: String,
        observation: String,
        idMaintenance: Int,
        idUser: Int
    ) {
        self.idCompletedMaintenance = idCompletedMaintenance
        self.completedDate = completedDate
        self.startedDate = startedDate
        self.observation = observation
        self.idMaintenance = idMaintenance
        self.idUser = idUser
    }
}

