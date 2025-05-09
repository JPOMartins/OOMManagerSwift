//
//  HomeView.swift
//  OOMManager
//
//  Created by João Martins on 08/05/2025.
//

import SwiftUI
import SwiftData


struct HomeView: View {
    @Query private var completedMaintenanceActivityModel : [CompletedMaintenanceActivityModel]
    @Query private var logActivityModel : [LogActivityModel]

    var body: some View {
        HomeScreen(completedMaintenacesActivityModel: completedMaintenanceActivityModel, logActivityModel: logActivityModel)
            .navigationTitle("Atividades em Andamento")
    }
}

struct HomeScreen: View {
    let completedMaintenacesActivityModel: [CompletedMaintenanceActivityModel]
    let logActivityModel: [LogActivityModel]

    var body: some View {
        VStack {
            ScrollView {
                
                Section(header: HStack{
                    Text("Logs - \(logActivityModel.count)")
                    Spacer()
                }) {
                    ForEach(logActivityModel) { log in
                        LogCard(log: log)
                    }
                }
                    
                Spacer()
                    
                Section(header: HStack {
                    Text("Maintenances - \(completedMaintenacesActivityModel.count)")
                    Spacer()
                }
                ) {
                    ForEach(completedMaintenacesActivityModel) { maintenance in
                        MaintenanceCard(maintenance: maintenance)
                    }
                }
                
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}


struct LogCard: View {
    let log: LogActivityModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Equipamento:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("Equipamento Nome")
                    .font(.body)
            }

            HStack {
                Text("Log:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text(log.title ?? "")
                    .font(.body)
            }

            HStack {
                Text("Início:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text(log.startedDate)
                    .font(.body)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.separator), lineWidth: 0.5)
        )
        .padding(.vertical, 4)
    }
}



struct MaintenanceCard : View {
    let maintenance: CompletedMaintenanceActivityModel
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Equipamento:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("Equipamento Nome")
                        .font(.body)
                }

                HStack {
                    Text("Log:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(maintenance.maintenanceID)")
                        .font(.body)
                }

                HStack {
                    Text("Início:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(maintenance.startedDate)
                        .font(.body)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.separator), lineWidth: 0.5)
            )
            .padding(.vertical, 4)
            
        }
    }
}

#Preview {
    HomeScreen(
        completedMaintenacesActivityModel: [
            CompletedMaintenanceActivityModel(
                idCompletedMaintenanceActivity: 1,
                startedDate: "2025-05-01",
                completedDate: "2025-05-02",
                observation: "Replaced filter",
                maintenanceID: 1001,
                userID: 501
            ),
            CompletedMaintenanceActivityModel(
                idCompletedMaintenanceActivity: 2,
                startedDate: "2025-05-03",
                completedDate: nil,
                observation: "Oil level check pending",
                maintenanceID: 1002,
                userID: 502
            )
        ],
        logActivityModel: [
            LogActivityModel(
                idLogActivity: 1,
                title: "Engine Inspection",
                observations: "No issues found",
                startedDate: "2025-05-01",
                completedDate: "2025-05-01",
                equipmentID: 2001,
                userID: 501
            ),
            LogActivityModel(
                idLogActivity: 2,
                title: "Battery Check",
                observations: "Needs replacement",
                startedDate: "2025-05-02",
                completedDate: nil,
                equipmentID: 2002,
                userID: 502
            )
        ]
    )
}

#Preview {
    HomeScreen(
        completedMaintenacesActivityModel: [
            CompletedMaintenanceActivityModel(idCompletedMaintenanceActivity: 1, startedDate: "2025-05-01", completedDate: "2025-05-02", observation: "Replaced filter", maintenanceID: 1001, userID: 501),
            CompletedMaintenanceActivityModel(idCompletedMaintenanceActivity: 2, startedDate: "2025-05-03", completedDate: nil, observation: "Oil level check pending", maintenanceID: 1002, userID: 502),
            CompletedMaintenanceActivityModel(idCompletedMaintenanceActivity: 3, startedDate: "2025-05-04", completedDate: "2025-05-05", observation: "Cleaned vents", maintenanceID: 1003, userID: 503),
            CompletedMaintenanceActivityModel(idCompletedMaintenanceActivity: 4, startedDate: "2025-05-06", completedDate: nil, observation: "Pending safety test", maintenanceID: 1004, userID: 504),
            CompletedMaintenanceActivityModel(idCompletedMaintenanceActivity: 5, startedDate: "2025-05-07", completedDate: nil, observation: "Routine inspection started", maintenanceID: 1005, userID: 505)
        ],
        logActivityModel: [
            LogActivityModel(idLogActivity: 1, title: "Engine Inspection", observations: "No issues found", startedDate: "2025-05-01", completedDate: "2025-05-01", equipmentID: 2001, userID: 501),
            LogActivityModel(idLogActivity: 2, title: "Battery Check", observations: "Needs replacement", startedDate: "2025-05-02", completedDate: nil, equipmentID: 2002, userID: 502),
            LogActivityModel(idLogActivity: 3, title: "Tire Pressure Check", observations: "Low pressure", startedDate: "2025-05-03", completedDate: nil, equipmentID: 2003, userID: 503),
            LogActivityModel(idLogActivity: 4, title: "Cooling System Flush", observations: "Flushed and refilled", startedDate: "2025-05-04", completedDate: "2025-05-04", equipmentID: 2004, userID: 504),
            LogActivityModel(idLogActivity: 5, title: "Brake Pad Replacement", observations: "Rear pads changed", startedDate: "2025-05-05", completedDate: nil, equipmentID: 2005, userID: 505)
        ]
    )
}


