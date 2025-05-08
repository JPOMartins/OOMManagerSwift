//
//  CompletedMaintenancesView.swift
//  OOMManager
//
//  Created by João Martins on 08/05/2025.
//

import SwiftUI
import SwiftData

struct CompletedMaintenancesView: View {
    @Query private var completedMaintenaces : [CompletedMaintenanceModel]
    @State private var errorMessage : String?
    
    let repository : CompletedMaintenanceRepository
    
    var body: some View {
        VStack {
            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            }
            CompletedMaintenancesListView(completedMaintenances: completedMaintenaces)
        }
        .navigationTitle("Maintenances")
        .onAppear {
            repository.fetchAndStoreCompletedMaintenance { error in
                if let error = error {
                    errorMessage = error.localizedDescription
                }
                
            }
        }
    }
}

struct CompletedMaintenancesListView : View {
    let completedMaintenances : [CompletedMaintenanceModel]
    
    var body: some View {
        List(completedMaintenances) { completedMaintenance in
            CompletedMaintenanceRow(completedMaintenace: completedMaintenance)
        }
    }
}

struct CompletedMaintenanceRow : View {
    let completedMaintenace : CompletedMaintenanceModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "doc.text")
                    .foregroundColor(.blue)
                Text(String(completedMaintenace.idMaintenance))
                    .font(.headline)
                    .foregroundColor(.primary)
            }

            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.gray)
                Text("Started: \(completedMaintenace.startedDate)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            if !completedMaintenace.completedDate.isEmpty {
                HStack {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.green)
                    Text("Completed: \(completedMaintenace.completedDate)")
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
    CompletedMaintenancesListView(completedMaintenances: [
        CompletedMaintenanceModel(
            idCompletedMaintenance: 1,
            completedDate: "2025-05-01 16:30",
            startedDate: "2025-05-01 14:00",
            observation: "Replaced worn hydraulic seals",
            idMaintenance: 101,
            idUser: 10
        ),
        CompletedMaintenanceModel(
            idCompletedMaintenance: 2,
            completedDate: "2025-05-03 11:00",
            startedDate: "2025-05-03 08:30",
            observation: "Routine inspection completed",
            idMaintenance: 102,
            idUser: 11
        ),
        CompletedMaintenanceModel(
            idCompletedMaintenance: 3,
            completedDate: "2025-05-05 17:45",
            startedDate: "2025-05-05 15:00",
            observation: "Oil and filter change",
            idMaintenance: 103,
            idUser: 12
        )
    ])
}


