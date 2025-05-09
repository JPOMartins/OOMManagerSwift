//
//  TaskList.swift
//  OOMManager
//
//  Created by João Martins on 09/05/2025.
//

import SwiftUI

struct TaskList: View {
    let taskList: [TaskModel]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 6) {
                ForEach(taskList) { task in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Tarefa:")
                                .font(.headline)
                            Text(task.title)
                                .font(.subheadline)
                            Spacer()
                        }

                        Text(task.tDescription)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemBackground))
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                }
            }
            .padding()
        }
        .background(Color.clear)
    }
}



#Preview {
    TaskList(taskList: [
        TaskModel(idTask: 1, title: "Check Oil Levels", description: "Ensure oil levels are within range", idMaintenances: 101),
        TaskModel(idTask: 2, title: "Inspect Air Filter", description: "Clean or replace air filter if necessary", idMaintenances: 101),
        TaskModel(idTask: 3, title: "Test Battery", description: "Measure voltage and replace if below threshold", idMaintenances: 102),
        TaskModel(idTask: 4, title: "Lubricate Bearings", description: "Apply grease to motor bearings", idMaintenances: 103),
        TaskModel(idTask: 5, title: "Check Temperature Sensor", description: "Verify sensor accuracy and recalibrate", idMaintenances: 103)
    ])
}


