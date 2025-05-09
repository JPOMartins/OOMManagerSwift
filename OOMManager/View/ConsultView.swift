//
//  ConsultView.swift
//  OOMManager
//
//  Created by João Martins on 09/05/2025.
//
import SwiftUI
import SwiftData

struct ConsultView : View {
    let taskRepository: TaskRepository
    @State private var errorMessage : String?
    
    @Query private var equipments: [EquipmentModel]
    @Query private var maintenances: [MaintenancesModel]
    @Query private var tasks: [TaskModel]
    
    @State private var selectedEquipment: EquipmentModel?
    @State private var selectedMaintenance: MaintenancesModel?
        
    @State private var filteredMaintenances : [MaintenancesModel] = []
    @State private var filteredTasks : [TaskModel] = []
    
    var body: some View {
        VStack {
            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            }
            ComboBoxEquipments(allItems: equipments, selectedItem: $selectedEquipment).padding(.bottom)
            ComboBoxMaintenances(allItems: filteredMaintenances, selectedItem: $selectedMaintenance).padding(.bottom)
            HStack {
                Text("Tarefas")
                    .font(.title2)
            }
            TaskList(taskList: filteredTasks)
            Spacer()
        }
        .onChange(of: selectedEquipment) { oldValue , newValue in
            filteredMaintenances = maintenances.filter { $0.idEquipment == newValue?.idEquipment}
        }
        .onChange(of: selectedMaintenance) { oldValue, newValue in
            filteredTasks = tasks.filter { $0.idMaintenances == newValue?.idMaintenance}
        }
        .onAppear {
            taskRepository.fetchAndStoreTasks { error in
                if let error = error {
                    errorMessage = error.localizedDescription
                }
            }
        }
        .navigationTitle("Consultar")
    }
    
    
}
