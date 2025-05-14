//
//  MaintenanceActivityView.swift
//  OOMManager
//
//  Created by João Martins on 13/05/2025.
//

import SwiftUI
import SwiftData

struct MaintenanceActivityView: View {
    @Environment(\.modelContext) private var context
    
    let maintenanceActivity : CompletedMaintenanceActivityModel
    @Query private var maintenaces: [MaintenancesModel]
    @Query private var equipments : [EquipmentModel]
    @Query private var tasks : [TaskModel]
    
    let completedMaintenanceRepository : CompletedMaintenanceRepository
    
    
    @State private var observation : String = ""
    
    private var maintenance : MaintenancesModel? {
        maintenaces.first {$0.idMaintenance == maintenanceActivity.maintenanceID}
    }
    
    private var equipment : EquipmentModel? {
        equipments.first {$0.idEquipment == maintenance?.idEquipment}
    }
    
    private var filteredTaks : [TaskModel]? {
        tasks.filter { $0.idMaintenances == maintenanceActivity.maintenanceID }
    }
    
    private func sendMaintenanceAndTasks(
        context: ModelContext,
        taskInputs: [TaskInput],
        observation: String,
        completion: @escaping (Bool, String) -> Void
    ) {
        let completedDTO = CompletedMaintenanceActivityDTO(
            startedDate: maintenanceActivity.startedDate,
            CompletedDate: ISO8601DateFormatter().string(from: Date()),
            observation: observation,
            maintenance_id: maintenanceActivity.maintenanceID,
            user_id: maintenanceActivity.userID!
        )

    
        completedMaintenanceRepository.postCompletedMaintenance(
            dto: completedDTO,
            taskInputs: taskInputs
        ) { success, error in
            if let error = error {
                completion(false, "Erro ao enviar: \(error.localizedDescription)")
            } else {
                context.delete(maintenanceActivity)
                completion(true, "Manutenção e tarefas enviadas com sucesso!")
            }
        }
    }


    
    
    var body: some View {
        ScrollView {
            VStack {
                MaintenanceActivityBodyScreen(
                    onSubmit: sendMaintenanceAndTasks,
                    maintenance: maintenance,
                    equipment: equipment,
                    completedMaintenanceActivity: maintenanceActivity,
                    tasks: tasks
                )
            }
            .navigationTitle(Text("Active maintenance"))
            .padding()
        }
    }
}

struct MaintenanceActivityBodyScreen : View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var onSubmit: (_ context: ModelContext, _ taskInputs: [TaskInput], _ observation: String, _ completion: @escaping (Bool, String) -> Void) -> Void
    
    let maintenance : MaintenancesModel?
    let equipment : EquipmentModel?
    let completedMaintenanceActivity : CompletedMaintenanceActivityModel
    let tasks : [TaskModel]
    
    @State private var taskInputs: [TaskInput] = []
    @State private var observation : String = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("Equipamento: ")
                    .foregroundColor(.oomLogoBlue)
                    .bold(true)
                    .font(.title3)
                Text(equipment?.name ?? "N/A")
                Spacer()
            }
            .padding(.bottom)
            
            HStack {
                Text("Manutenção: ")
                    .foregroundColor(.oomLogoBlue)
                    .bold(true)
                    .font(.title3)
                Text(maintenance?.title ?? "N/A")
                Spacer()
            }
            .padding(.bottom)
            
            HStack {
                Text("Observação*: ")
                    .foregroundColor(.oomLogoBlue)
                    .bold(true)
                    .font(.title3)
                Spacer()
            }
            .padding(.bottom)
            
            TextEditor(text: $observation)
                .frame(height: 200)
                .padding(8)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .padding(.bottom)
            
            HStack {
                Text("Tarefas a realizar: ")
                    .foregroundColor(.oomLogoBlue)
                    .bold(true)
                    .font(.title3)
                Spacer()
            }
            
            taskListToComplete(taskInputs: $taskInputs)
            
            HStack {
                Spacer()
                Button("Cancelar") {
                    modelContext.delete(completedMaintenanceActivity)
                    dismiss()
                }
                .fontWeight(.semibold)
                .foregroundColor(.oomLogoBlue)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)

                Spacer()
                Button("Enviar manutenção") {
                    onSubmit(modelContext, taskInputs, observation) { success, message in
                        alertMessage = message
                        showAlert = true
                        if success {
                            dismiss()
                        }
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Resultado"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .fontWeight(.semibold)
                .foregroundColor(.oomLogoBlue)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                Spacer()
            }
            .padding()
            
        }.onAppear {
            taskInputs = tasks.map {
                TaskInput(id: $0.idTask, isChecked: false, observation: "", task: $0)
            }
        }
    }
}

struct taskListToComplete: View {
    @Binding var taskInputs: [TaskInput]

    var body: some View {
            VStack(spacing: 6) {
                ForEach($taskInputs) { $taskInput in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(taskInput.task.title)
                                .font(.headline)
                          
                        }
                        
                        
                        Text(taskInput.task.tDescription)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("Observação:")
                            .font(.subheadline)
                        TextEditor(text: $taskInput.observation)
                            .frame(minHeight: 80)
                            .padding(4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                        
                        HStack {
                            Toggle(isOn: $taskInput.isChecked) {
                                Text("Tarefa realizada")
                                    .font(.headline)
                            }
                            .toggleStyle(CheckboxStyle())
                            Spacer()
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
    }
}

struct CheckboxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: { configuration.isOn.toggle() }) {
            HStack {
                configuration.label
                Spacer()
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .foregroundColor(configuration.isOn ? .accentColor : .secondary)
            }
        }
        .buttonStyle(.plain)
    }
}

struct TaskInput: Identifiable {
    let id: Int
    var isChecked: Bool
    var observation: String
    let task: TaskModel
}

#Preview {
    MaintenanceActivityBodyScreen(
        onSubmit: {_,_,_,_ in}, maintenance: MaintenancesModel(
            idMaintenance: 101,
            title: "Verificação dos Filtros de Ar",
            idEquipment: 12,
            periodicity: 90
        ),
        equipment: EquipmentModel(
            idEquipment: 12,
            name: "Compressor de Ar",
            brand: "Atlas Copco",
            model: "GA 90 VSD",
            serialNumber: "AC123456789",
            observations: "Filtro precisa de limpeza a cada 90 dias."
        ),
        completedMaintenanceActivity: CompletedMaintenanceActivityModel(
            startedDate: "2025-05-13T14:00:00Z",
            maintenanceID: 101
        ),
        tasks: [
            TaskModel(
                idTask: 1,
                title: "Inspecionar filtro de entrada",
                description: "Verificar se há acúmulo de sujeira ou obstruções.",
                idMaintenances: 101
            ),
            TaskModel(
                idTask: 2,
                title: "Limpar filtro secundário",
                description: "Utilizar ar comprimido para remover resíduos.",
                idMaintenances: 101
            ),
            TaskModel(
                idTask: 3,
                title: "Verificar pressão do sistema",
                description: "Registrar a pressão e comparar com os padrões operacionais.",
                idMaintenances: 101
            )
        ]
    )
}


