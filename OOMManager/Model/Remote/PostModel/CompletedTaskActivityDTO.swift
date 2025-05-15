//
//  CompletedTaskActivityDTO.swift
//  OOMManager
//
//  Created by João Martins on 13/05/2025.
//

struct CompletedTaskActivityDTO : Codable {
    var sucess: Int
    var observations: String
    var idTask: Int
    var idCompletedMaintenance: Int?
}
