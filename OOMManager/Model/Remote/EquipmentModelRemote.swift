//
//  EquipmentModelRemote.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//


import Foundation

struct EquipmentModel: Codable {
    var idEquipment: Int?
    var name: String?
    var serieNumber: String?
    var model: String?
    var brand: String?
    var observations: String?

    enum CodingKeys: String, CodingKey {
        case idEquipment = "idEquipment"
        case name
        case serieNumber = "serieNumber"
        case model
        case brand
        case observations
    }
}

