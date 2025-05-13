//
//  CompleteTaskListInfo.swift
//  OOMManager
//
//  Created by João Martins on 12/05/2025.
//

import SwiftUI

struct CompletedTaskListInfo : View {
    let completedTaskWithInfo : [CompletedTaskWithInfo]
    
    var body : some View {
    
                ScrollView {
                    VStack(spacing: 6) {
                        ForEach(completedTaskWithInfo, id: \.completedTask.idCompletedTask) { completedTask in
                            CompletedTaskRowView(completedTask: completedTask)
                        }
                    }
                    .padding()
                }
                .background(Color.clear)
        }
    
}

struct CompletedTaskRowView: View {
    let completedTask: CompletedTaskWithInfo

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(completedTask.task?.title ?? "N/A")
                    .font(.headline)
                Spacer()
                Image(systemName: completedTask.completedTask.success == 1 ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(completedTask.completedTask.success == 1 ? .green : .red)
            }


            if let notes = completedTask.completedTask.observations {
                Text("Observações: \(notes)")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
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


#Preview {
    CompletedTaskListInfo(completedTaskWithInfo: [
        CompletedTaskWithInfo(
            completedTask: CompletedTaskModel(
                idCompletedTask: 1,
                idTask: 10,
                idCompletedMaintenance: 1,
                success: 1,
                observations: "No issues"
            ),
            task: TaskModel(
                idTask: 10,
                title: "Replace Oil Filter",
                description: "Remove the old oil filter and install a new one.",
                idMaintenances: 100
            )
        ),
        CompletedTaskWithInfo(
            completedTask: CompletedTaskModel(
                idCompletedTask: 2,
                idTask: 11,
                idCompletedMaintenance: 1,
                success: 0,
                observations: "Couldn't verify pressure sensor"
            ),
            task: TaskModel(
                idTask: 11,
                title: "Verify Pressure Sensor",
                description: "Check the pressure sensor for accurate readings.",
                idMaintenances: 100
            )
        )
    ])
}

