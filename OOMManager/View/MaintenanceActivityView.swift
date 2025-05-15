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
    @Environment(\.dismiss) private var dismiss

    @Bindable var maintenanceActivity: CompletedMaintenanceActivityModel
    @Query private var maintenances: [MaintenancesModel]
    @Query private var equipments: [EquipmentModel]

    let completedMaintenanceRepository: CompletedMaintenanceRepository

    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var isError = false

    private var maintenance: MaintenancesModel? {
        maintenances.first { $0.idMaintenance == maintenanceActivity.maintenanceID }
    }

    private var equipment: EquipmentModel? {
        equipments.first { $0.idEquipment == maintenance?.idEquipment }
    }

    private func sendMaintenance(
        completion: @escaping (Bool, String) -> Void
    ) {
        let dto = CompletedMaintenanceActivityDTO(
            startedDate: maintenanceActivity.startedDate,
            CompletedDate: ISO8601DateFormatter().string(from: Date()),
            observation: maintenanceActivity.observation ?? "",
            maintenance_id: maintenanceActivity.maintenanceID,
            user_id: maintenanceActivity.userID ?? 0
        )

        let taskDTOs = maintenanceActivity.tasks.map {
            CompletedTaskActivityDTO(
                sucess: $0.isChecked ? 1 : 0,
                observations: $0.observation,
                idTask: $0.idTask,

            )
        }

        completedMaintenanceRepository.postCompletedMaintenance(dto: dto, taskInputs: taskDTOs) { success, error in
            if let error = error {
                toastMessage = "Erro: \(error.localizedDescription)"
                isError = true
                completion(false, toastMessage)
            } else {
                toastMessage = "Manutenção enviada com sucesso!"
                isError = false
                context.delete(maintenanceActivity)
                completion(true, toastMessage)
            }
            showToast = true
        }
    }

    var body: some View {
        ZStack {
            ScrollView {
                MaintenanceActivityBodyScreen(
                    onSubmit: sendMaintenance,
                    maintenance: maintenance,
                    equipment: equipment,
                    completedMaintenanceActivity: maintenanceActivity
                )
                .padding()
                .navigationTitle("Active maintenance")
            }

            if showToast {
                Toast(toastMessage: $toastMessage, showToast: $showToast, isError: $isError)
            }
        }
    }
}


struct MaintenanceActivityBodyScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var onSubmit: (@escaping (Bool, String) -> Void) -> Void

    let maintenance: MaintenancesModel?
    let equipment: EquipmentModel?
    let completedMaintenanceActivity: CompletedMaintenanceActivityModel

    var body: some View {
        VStack {
            HStack {
                Text("Equipamento:")
                    .foregroundColor(.oomLogoBlue)
                    .bold()
                    .font(.title3)
                Text(equipment?.name ?? "N/A")
                Spacer()
            }
            .padding(.bottom)

            HStack {
                Text("Manutenção:")
                    .foregroundColor(.oomLogoBlue)
                    .bold()
                    .font(.title3)
                Text(maintenance?.title ?? "N/A")
                Spacer()
            }
            .padding(.bottom)

            HStack {
                Text("Observação:")
                    .foregroundColor(.oomLogoBlue)
                    .bold()
                    .font(.title3)
                Spacer()
            }
            .padding(.bottom)

            TextEditor(text: Binding(
                get: { completedMaintenanceActivity.observation ?? "" },
                set: { completedMaintenanceActivity.observation = $0 }
            ))
            .frame(height: 200)
            .padding(8)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))
            .padding(.bottom)

            HStack {
                Text("Tarefas:")
                    .foregroundColor(.oomLogoBlue)
                    .bold()
                    .font(.title3)
                Spacer()
            }

            TaskListToComplete(tasks: completedMaintenanceActivity.tasks)

            HStack {
                Spacer()
                Button("Cancelar") {
                    modelContext.delete(completedMaintenanceActivity)
                    dismiss()
                }
                .buttonStyle(.bordered)
                .foregroundColor(.oomLogoBlue)

                Spacer()
                Button("Enviar manutenção") {
                    onSubmit { success, _ in
                        if success {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                dismiss()
                            }
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .foregroundColor(.white)
                Spacer()
            }
            .padding()
        }
    }
}


struct TaskListToComplete: View {
    var tasks: [CompletedTaskActivityModel]

    @Query private var taskModel: [TaskModel]

    var filteredTasks: [TaskModel] {
        let taskIDs = Set(tasks.map { $0.idTask })
        return taskModel.filter { taskIDs.contains($0.idTask) }
    }

    var body: some View {
        VStack(spacing: 10) {
            ForEach(filteredTasks) { task in
                VStack(alignment: .leading, spacing: 8) {
                    Text(task.title)
                        .font(.headline)

                    // Find corresponding CompletedTaskActivityModel to bind the observation and isChecked
                    if let completedTask = tasks.first(where: { $0.idTask == task.idTask }) {
                        TextEditor(text: Binding(
                            get: { completedTask.observation },
                            set: { completedTask.observation = $0 }
                        ))
                        .frame(minHeight: 80)
                        .padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )

                        Toggle(isOn: Binding(
                            get: { completedTask.isChecked },
                            set: { completedTask.isChecked = $0 }
                        )) {
                            Text("Tarefa realizada")
                                .font(.subheadline)
                        }
                        .toggleStyle(CheckboxStyle())
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemBackground)))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2), lineWidth: 1))
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



