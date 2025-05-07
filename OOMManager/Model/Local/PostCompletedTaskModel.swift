//
//  PostCompletedTaskModel.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//

import SwiftData

@Model
class PostCompletedTaskModel {
    @Attribute(.unique) var postCompletedTaskId: Int
    var success: Int
    var observations: String?
    var idCompletedMaintenance: Int?
    var idCompletedTask: Int
    var idTask: Int

    init(
        postCompletedTaskId: Int = 0,
        success: Int,
        observations: String? = nil,
        idCompletedMaintenance: Int? = nil,
        idCompletedTask: Int,
        idTask: Int
    ) {
        self.postCompletedTaskId = postCompletedTaskId
        self.success = success
        self.observations = observations
        self.idCompletedMaintenance = idCompletedMaintenance
        self.idCompletedTask = idCompletedTask
        self.idTask = idTask
    }
}
