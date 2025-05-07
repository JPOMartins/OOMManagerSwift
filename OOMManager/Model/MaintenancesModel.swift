//
//  MaintenancesModel.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//
import SwiftData

@Model
class MaintenancesModel {
    @Attribute(.unique) var idMaintenance: Int
    var title: String
    var idEquipment: Int
    var periodicity: Int

    init(
        idMaintenance: Int,
        title: String,
        idEquipment: Int,
        periodicity: Int
    ) {
        self.idMaintenance = idMaintenance
        self.title = title
        self.idEquipment = idEquipment
        self.periodicity = periodicity
    }
}

