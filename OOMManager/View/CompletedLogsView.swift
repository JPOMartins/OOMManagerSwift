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
    @Query private var equipmentList: [EquipmentModel]
    @State private var errorMessage : String?
    @Query private var users: [UserModel]
        
    @State private var selectedLog: LogModel? = nil
    
    let equipmentRepository: EquipmentRepository
    let repository: LogRepository
    let user: UserModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                }
                LogsListView(logs: logs, equipmentList: equipmentList) { log in
                    selectedLog = log
                }
            }
            .navigationTitle("Logs")
            .onAppear {
                repository.fetchAndStoreLogs { error in
                    if let error = error {
                        errorMessage = error.localizedDescription
                    }
                }
            }
            .navigationDestination(item: $selectedLog) { log in
                let equipment = equipmentList.first {$0.idEquipment == log.idEquipment }
                let user = users.first {$0.idUser == log.userID}
                
                CompletedLogDetailView(log: log, equipment: equipment, user: user!, equipmentRepository: equipmentRepository)
            }
        }
    
    }
        
}

struct LogsListView : View {
    let logs: [LogModel]
    let equipmentList: [EquipmentModel]
    let onLogTap: (LogModel) -> Void
    
    var body: some View {
        List(logs) { log in
            let equipment = equipmentList.first { $0.idEquipment == log.idEquipment }
            LogRow(log: log, equipment: equipment)
                .onTapGesture {
                    onLogTap(log)
            }
        }
    }
}

struct LogRow: View {
    let log: LogModel
    let equipment: EquipmentModel?
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
                Image(systemName: "wrench.fill")
                    .foregroundColor(.gray)
                Text(equipment?.name ?? "Unknown Equipment")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
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
    LogsListView(
        logs: [
            LogModel(
                idLog: 1,
                title: "Maintenance Check",
                idEquipment: 101,
                userID: 202,
                observations: "Routine maintenance completed",
                startedDate: "2025-05-01 08:00",
                completedDate: "2025-05-01 10:00"
            ),
            LogModel(
                idLog: 2,
                title: "Engine Repair",
                idEquipment: 102,
                userID: 203,
                observations: "Engine issue fixed",
                startedDate: "2025-05-02 09:00",
                completedDate: "2025-05-02 12:00"
            ),
            LogModel(
                idLog: 3,
                title: "Hydraulic System Maintenance",
                idEquipment: 103,
                userID: 204,
                observations: "Hydraulic system maintenance performed",
                startedDate: "2025-05-03 07:30",
                completedDate: "2025-05-03 11:00"
            )
        ],
        equipmentList: [
            EquipmentModel(
                idEquipment: 101,
                name: "Excavator ZX200",
                brand: "Hitachi",
                model: "ZX200",
                serialNumber: "HXZ200-12345",
                observations: "Used for excavation"
            ),
            EquipmentModel(
                idEquipment: 102,
                name: "Bulldozer D6T",
                brand: "Caterpillar",
                model: "D6T",
                serialNumber: "CATD6T-98765",
                observations: "Main bulldozer"
            ),
            EquipmentModel(
                idEquipment: 103,
                name: "Hydraulic Lift HL500",
                brand: "Genie",
                model: "HL500",
                serialNumber: "GHL500-56789",
                observations: "Used for height access"
            )
        ],
        onLogTap: { _ in
            // You can put preview tap actions here
        }
    )
}

