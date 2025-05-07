//
//  TaskModel.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//

import SwiftData

@Model
class TaskModel {
    @Attribute(.unique) var idTask: Int
    var title: String
    var tDescription: String
    var idMaintenances: Int

    init(
        idTask: Int,
        title: String,
        description: String,
        idMaintenances: Int
    ) {
        self.idTask = idTask
        self.title = title
        self.tDescription = description
        self.idMaintenances = idMaintenances
    }
}
