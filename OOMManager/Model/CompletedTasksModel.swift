//
//  CompletedTasksModel.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//
import SwiftData

@Model
class CompletedTaskModel {
    @Attribute(.unique) var idCompletedTask: Int
    var idTask: Int
    var idCompletedMaintenance: Int
    var success: Int
    var observations: String?

    init(
        idCompletedTask: Int,
        idTask: Int,
        idCompletedMaintenance: Int,
        success: Int,
        observations: String? = nil
    ) {
        self.idCompletedTask = idCompletedTask
        self.idTask = idTask
        self.idCompletedMaintenance = idCompletedMaintenance
        self.success = success
        self.observations = observations
    }
}
