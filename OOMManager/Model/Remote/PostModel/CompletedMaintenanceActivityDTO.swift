//
//  CompletedMaintenanceActivityDTO.swift
//  OOMManager
//
//  Created by João Martins on 13/05/2025.
//

import Foundation

struct CompletedMaintenanceActivityDTO : Codable {
    var startedDate : String
    var CompletedDate : String
    var observation: String
    var maintenance_id : Int
    var user_id : Int
}

