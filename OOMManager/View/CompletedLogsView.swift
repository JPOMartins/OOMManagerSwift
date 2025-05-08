//
//  CompletedLogsView.swift
//  OOMManager
//
//  Created by João Martins on 08/05/2025.
//

import SwiftUI
import SwiftData

struct CompletedLogsView : View {
    @EnvironmentObject var authManager: AuthManager
    @Query private var logs: [LogModel]
    @State private var errorMessage : String?
    
    let repository: LogRepository
    
    var body: some View {
        VStack {
            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            }
            LogsListView(logs: logs)
        }
        .navigationTitle("Logs")
        .onAppear {
            repository.fetchAndStoreLogs { error in
                if let error = error {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
        
}

struct LogsListView : View {
    let logs: [LogModel]
    
    var body: some View {
        List(logs) { log in
           LogRow(log: log)
        }
    }
}

struct LogRow: View {
    let log: LogModel

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "doc.text")
                    .foregroundColor(.blue)
                Text(log.title)
                    .font(.headline)
                    .foregroundColor(.primary)
            }

            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.gray)
                Text("Started: \(log.startedDate)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            if !log.completedDate.isEmpty {
                HStack {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.green)
                    Text("Completed: \(log.completedDate)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    LogsListView(logs: [
        LogModel(idLog: 1, title: "Maintenance Check", idEquipment: 101, userID: 202, observations: "Routine maintenance completed", startedDate: "2025-05-01 08:00", completedDate: "2025-05-01 10:00"),
        LogModel(idLog: 2, title: "Engine Repair", idEquipment: 102, userID: 203, observations: "Engine issue fixed", startedDate: "2025-05-02 09:00", completedDate: "2025-05-02 12:00"),
        LogModel(idLog: 3, title: "Hydraulic System Maintenance", idEquipment: 103, userID: 204, observations: "Hydraulic system maintenance performed", startedDate: "2025-05-03 07:30", completedDate: "2025-05-03 11:00")
    ])
}
