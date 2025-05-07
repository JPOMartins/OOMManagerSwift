//
//  CompletedTaskRemote.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//

import Foundation

struct CompletedTaskRemote: Codable {
    var idCompletedMaintenance: Int
    var idCompletedTask: Int
    var idTask: Int
    var observations: String
    var sucess: Int

    enum CodingKeys: String, CodingKey {
        case idCompletedMaintenance = "idCompletedMaintenance"
        case idCompletedTask = "idCompletedTask"
        case idTask = "idTask"
        case observations = "observations"
        case sucess = "sucess"
    }
}


