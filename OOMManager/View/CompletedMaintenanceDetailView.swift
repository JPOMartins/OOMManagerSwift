//
//  CompletedMaintenanceDetailView.swift
//  OOMManager
//
//  Created by João Martins on 09/05/2025.
//
import SwiftUI
import SwiftData

struct CompletedTaskWithInfo {
    let completedTask: CompletedTaskModel
    let task: TaskModel?
}

struct CompletedMaintenanceDetailView : View {
    let completedMaintenanance : CompletedMaintenanceModel
    let maintenance : MaintenancesModel
    let equipment : EquipmentModel?
    let userModel : UserModel
    let equipmentRepository: EquipmentRepository
    let completedTasksRepository: CompletedTaskRepository
    @Query private var allCompletedTasks : [CompletedTaskModel]
    @Query private var allTasks : [TaskModel]
    
    var filteredCompletedTasks: [CompletedTaskModel] {
        allCompletedTasks.filter { $0.idCompletedMaintenance == completedMaintenanance.idCompletedMaintenance }
    }
    
    
    var completedTasksWithInfo: [CompletedTaskWithInfo] {
        let filteredCompleted = allCompletedTasks.filter {
            $0.idCompletedMaintenance == completedMaintenanance.idCompletedMaintenance
        }

        return filteredCompleted.map { completed in
            let matchingTask = allTasks.first { $0.idTask == completed.idTask }
            return CompletedTaskWithInfo(completedTask: completed, task: matchingTask)
        }
    }
    
    
    
    
    var body : some View {
        VStack {
            ScrollView {
                CompletedMaintenanceBodyDetail(completedMaintenance: completedMaintenanance,
                                               maintenance: maintenance,
                                               equipment: equipment,
                                               userModel: userModel,
                                               fetchImage: fetchImage,
                                               completedTasks: completedTasksWithInfo)
                .padding()
            }
        }.onAppear {
            completedTasksRepository.fetchAndStoreCompletedTasks { error in
                if let error = error {
                    print("Error fetching completed tasks: \(error)")
                }
            }
        }
    }
    
    private func fetchImage(id: Int, completion: @escaping (UIImage?) -> Void) {
        equipmentRepository.fetchEquipmentImage(for: id, completion: completion)
    }
    
}

struct CompletedMaintenanceBodyDetail : View {
    let completedMaintenance : CompletedMaintenanceModel
    let maintenance : MaintenancesModel
    let equipment: EquipmentModel?
    let userModel : UserModel?
    let fetchImage: (Int, @escaping (UIImage?) -> Void) -> Void
    let completedTasks: [CompletedTaskWithInfo]
    
    @State private var image: UIImage?

    var durationText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        guard
            let startDate = formatter.date(from: completedMaintenance.startedDate),
            let endDate = formatter.date(from: completedMaintenance.completedDate)
        else {
            return "N/A"
        }

        let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: startDate, to: endDate)

        var parts: [String] = []
        if let days = components.day, days > 0 {
            parts.append("\(days) day(s)")
        }
        if let hours = components.hour, hours > 0 {
            parts.append("\(hours) hour(s)")
        }
        if let minutes = components.minute, minutes > 0 {
            parts.append("\(minutes) min(s)")
        }
        
        if let seconds = components.second, seconds > 0 {
            parts.append("\(seconds) sec(s)")
        }

        return parts.joined(separator: ", ")
    }

    
    var body: some View {
        VStack {
            HStack {
                Text(equipment?.name ?? "N/A")
                    .font(.title)
                    .foregroundColor(.oomLogoBlue)
                Spacer()
            }.padding(.vertical,5)
            
            HStack {
                Text(maintenance.title)
                Spacer()
            }.padding(.vertical,5)
            
            HStack {
                Text("Equipamento: ")
                    .foregroundColor(.oomLogoBlue)
                    .bold(true)
                    .font(.title3)
                Spacer()
            }
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(8)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .overlay(
                        ProgressView()
                    )
            }
            
            HStack{
                Text("Utilizador: ")
                    .foregroundColor(.oomLogoBlue)
                    .bold(true)
                    .font(.title3)
                    .bold()
                Text(userModel?.name ?? "N/A")
                Spacer()
            }.padding(.vertical,5)
            
            Divider()
            
            VStack {
                HStack {
                    Text("Duração:")
                        .foregroundColor(.oomLogoBlue)
                        .bold(true)
                        .font(.title3)
                    Spacer()
                }
                .padding(.vertical, 5)
                
                HStack {
                    Text(durationText)
                    Spacer()
                }
                .padding(.vertical,5)
            }
            
            HStack {
                Text("Detalhes ")
                    .foregroundColor(.oomLogoBlue)
                    .bold(true)
                    .font(.title3)
                Spacer()
            }.padding(.vertical,5)
            
            
            HStack {
                Text("Início: ")
                Text(completedMaintenance.startedDate)
                Spacer()
            }
            HStack {
                Text("Fim: ")
                Text(completedMaintenance.completedDate)
                Spacer()
            }
            
            Divider()
            
            HStack {
                Text("Tarefas")
                    .foregroundColor(.oomLogoBlue)
                    .bold(true)
                    .font(.title3)
                Spacer()
            }
            
            CompletedTaskListInfo(completedTaskWithInfo: completedTasks)
            
            
            
            
        }
        .onAppear {
            if let equipment = equipment {
                fetchImage(equipment.idEquipment) { fetchedImage in
                    self.image = fetchedImage
                }
            }
        }
        .navigationTitle(maintenance.title)
    }
}

#Preview {
    CompletedMaintenanceBodyDetail(
        completedMaintenance: CompletedMaintenanceModel(
            idCompletedMaintenance: 1,
            completedDate: "2025-05-05T15:00:00",
            startedDate: "2025-05-05T13:00:00",
            observation: "Replaced filter and performed functional test.",
            idMaintenance: 100,
            idUser: 1
        ),
        maintenance: MaintenancesModel(
            idMaintenance: 100,
            title: "Oil Filter Replacement",
            idEquipment: 200,
            periodicity: 30
        ),
        equipment: EquipmentModel(
            idEquipment: 200,
            name: "Excavator",
            brand: "CAT",
            model: "320D",
            serialNumber: "CAT0320D12345",
            observations: "Hydraulic leaks noted during inspection."
        ),
        userModel: UserModel(
            idUser: 1,
            name: "João Martins",
            email: "joao.martins@example.com",
            type: "admin"
        ),
        fetchImage: { id, completion in
            let image = UIImage(systemName: "photo")
            completion(image)
        },
        completedTasks: [
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
        ]
    )
}



