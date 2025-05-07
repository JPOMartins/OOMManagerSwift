//
//  EquipmentModel.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//

import SwiftData

@Model
class EquipmentModel {
    @Attribute(.unique) var idEquipment: Int
    var name: String
    var brand: String
    var model: String
    var serialNumber: String
    var observations: String

    init(
        idEquipment: Int,
        name: String,
        brand: String,
        model: String,
        serialNumber: String,
        observations: String
    ) {
        self.idEquipment = idEquipment
        self.name = name
        self.brand = brand
        self.model = model
        self.serialNumber = serialNumber
        self.observations = observations
    }
}


