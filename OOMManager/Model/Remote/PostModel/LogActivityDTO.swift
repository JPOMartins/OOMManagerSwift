//
//  LogActivityDTO.swift
//  OOMManager
//
//  Created by João Martins on 13/05/2025.
//

import Foundation

struct LogActivityDTO: Codable {
    var title: String
    var observations: String
    var startedDate: String
    var CompletedDate: String
    var Equipments_idEquipment: Int
    var users_idUser: Int
}

