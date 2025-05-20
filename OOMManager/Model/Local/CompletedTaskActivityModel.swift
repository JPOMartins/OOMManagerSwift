//
//  CompletedTaskActivityModel.swift
//  OOMManager
//
//  Created by João Martins on 15/05/2025.
//
import SwiftData

@Model
class CompletedTaskActivityModel {
    @Attribute(.unique) var idTask: Int
    var isChecked: Bool = false
    var observation: String = ""
    var maintenanceID: Int

    @Relationship
    var maintenanceActivity: CompletedMaintenanceActivityModel?

    init(idTask: Int, maintenanceID: Int) {
        self.idTask = idTask
        self.maintenanceID = maintenanceID
    }
}
