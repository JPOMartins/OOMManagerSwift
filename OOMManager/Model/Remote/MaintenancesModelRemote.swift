//
//  MaintenancesModelRemote.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//

import Foundation

struct MaintenancesModelRemote: Codable {
    var idMaintenance: Int?
    var equipmentsIdEquipment: Int?
    var title: String?
    var periodicity: Int?

    enum CodingKeys: String, CodingKey {
        case idMaintenance = "idMaintenance"
        case equipmentsIdEquipment = "Equipments_idEquipment"
        case title
        case periodicity
    }
}
