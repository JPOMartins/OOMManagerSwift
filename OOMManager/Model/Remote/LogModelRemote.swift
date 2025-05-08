//
//  LogModelRemote.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//

import Foundation

struct LogModelRemote: Codable {
    var equipmentsIdEquipment: Int?
    var userId: Int?
    var completedDate: String?
    var startedDate: String?
    var observations: String?
    var title: String?
    var idLog: Int?

    enum CodingKeys: String, CodingKey {
        case equipmentsIdEquipment = "Equipments_idEquipment"
        case userId = "users_idUser"
        case completedDate = "CompletedDate"
        case startedDate = "startedDate"
        case observations = "observations"
        case title = "title"
        case idLog = "idLog"
    }
}
