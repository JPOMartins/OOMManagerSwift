//
//  TaskModelRemoteItem.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//
import Foundation

struct TaskModelRemote: Codable {
    var idTask: Int?
    var maintenancesIdMaintenance: Int?
    var description: String?
    var logsIdLog: Int?
    var title: String?
    var type: String?

    // Decodificador para mapear o JSON para o modelo Swift com nomes personalizados
    enum CodingKeys: String, CodingKey {
        case idTask = "idTask"
        case maintenancesIdMaintenance = "Maintenances_idMaintenance"
        case description
        case logsIdLog = "Logs_idLog"
        case title
        case type
    }
}
