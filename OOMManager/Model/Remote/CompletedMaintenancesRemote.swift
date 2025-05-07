//
//  CompletedMaintenances.swift
//  OOMManager
//
//  Created by Carlos Lucas on 07/05/2025.
//

import Foundation

struct CompletedMaintenances: Codable {
    var usersIdUser: Int?
    var maintenancesIdMaintenance: Int?
    var observations: String?
    var idCompletedMaintenance: Int?
    var startedDate: String?
    var completedDate: String?

    
    enum CodingKeys: String, CodingKey {
        case usersIdUser = "users_idUser"
        case maintenancesIdMaintenance = "maintenances_idMaintenance"
        case observations
        case idCompletedMaintenance = "idCompletedMaintenance"
        case startedDate
        case completedDate
    }
}
