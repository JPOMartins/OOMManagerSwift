//
//  TaskActivityModel.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//

import SwiftData

@Model
class TaskActivityModel {
    @Attribute(.unique) var idTaskActivity: Int
    var idTask: Int
    var idCompletedMaintenance: Int
    var success: Int
    var observations: String

    init(
        idTaskActivity: Int = 0,
        idTask: Int,
        idCompletedMaintenance: Int,
        success: Int,
        observations: String
    ) {
        self.idTaskActivity = idTaskActivity
        self.idTask = idTask
        self.idCompletedMaintenance = idCompletedMaintenance
        self.success = success
        self.observations = observations
    }
}
