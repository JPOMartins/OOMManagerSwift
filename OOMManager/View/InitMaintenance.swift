//
//  InitMaintenance.swift
//  OOMManager
//
//  Created by João Martins on 13/05/2025.
//

import SwiftUI
import SwiftData


struct InitMaintenance : View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject var authManager: AuthManager

    @Query private var tasks: [TaskModel]
    
    @Query private var equipments: [EquipmentModel]
    @State private var selectedEquipment: EquipmentModel?
    
    @Query private var maintenances: [MaintenancesModel]
    @State private var selectedMaintenance: MaintenancesModel?
        
    @State private var filteredMaintenances : [MaintenancesModel] = []
    @State private var filteredTasks : [TaskModel] = []

    
    
    var body: some View {
        VStack {
            
            ComboBoxEquipments(allItems: equipments, selectedItem: $selectedEquipment).padding(.bottom)
            ComboBoxMaintenances(allItems: filteredMaintenances, selectedItem: $selectedMaintenance).padding(.bottom)
            HStack {
                Text("Tarefas")
                    .font(.title2)
            }
            TaskList(taskList: filteredTasks)
            
            HStack {
                Spacer()
                Button("Init maintenance") {
                    guard let selectedMaintenance = selectedMaintenance else { return }

                    let dateFormatter = ISO8601DateFormatter()
                    let nowString = dateFormatter.string(from: Date())

                    if let user = authManager.currentUser {
                        let newMaintenanceActivity = CompletedMaintenanceActivityModel(
                            startedDate: nowString,
                            maintenanceID: selectedMaintenance.idMaintenance,
                            userID: user.idUser
                        )
                        context.insert(newMaintenanceActivity)
                    }else {
                        print("No maintenances")
                    }


                }
                .buttonStyle(.borderedProminent)
            }
    
        }
        .onChange(of: selectedEquipment) { oldValue , newValue in
            filteredMaintenances = maintenances.filter { $0.idEquipment == newValue?.idEquipment}
        }
        .onChange(of: selectedMaintenance) { oldValue, newValue in
            filteredTasks = tasks.filter { $0.idMaintenances == newValue?.idMaintenance}
        }
        .padding()
    }
}

#Preview {
    InitMaintenance()
}
