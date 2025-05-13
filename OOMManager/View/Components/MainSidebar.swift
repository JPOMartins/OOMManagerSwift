//
//  MainSidebar.swift
//  OOMManager
//
//  Created by João Martins on 08/05/2025.
//

import SwiftUI
import SwiftData

enum SidebarItem: Hashable {
    case equipment
    case logs
    case completedMaintenace
    case Home
    case consult
}

struct MainSidebarView: View {
    @EnvironmentObject var authManager: AuthManager

    let equipmentRepository: EquipmentRepository
    let logRepository: LogRepository
    let completedMaintenaceRepository: CompletedMaintenanceRepository
    let maintenanceRepository: MaintenanceRepository
    let taskRepository: TaskRepository
    let userRepository: UserRepository
    let completedTaskRepository: CompletedTaskRepository
    
    @State private var columnVisibility: NavigationSplitViewVisibility = .automatic
    @State private var errorMessage: String?


    @State private var selectedItem: SidebarItem? = .Home
    @State private var currentUserLogged: UserModel?
    
    @Query private var users: [UserModel]

    var body: some View {
        
        if let errorMessage = errorMessage {
            Text("Error: \(errorMessage)")
                .foregroundColor(.red)
        }
        
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $selectedItem) {
                Section(header: Text("Menu")) {
                    NavigationLink(value: SidebarItem.Home) {
                        Label("Home", systemImage: "house")
                    }
                }
                Section(header: Text("Equipamentos")) {
                    NavigationLink(value: SidebarItem.equipment) {
                        Label("Equipamentos", systemImage: "desktopcomputer")
                    }
                }
                Section(header: Text("Histórico")) {
                    NavigationLink(value: SidebarItem.logs) {
                        Label("Logs", systemImage: "doc.plaintext")
                    }
                    NavigationLink(value: SidebarItem.completedMaintenace) {
                        Label("Manutenção", systemImage: "wrench")
                    }
                }
                
                Section(header: Text("Dados")) {
                    NavigationLink(value: SidebarItem.consult) {
                        Label("Consulta", systemImage: "book.pages")
                    }
                }
            }
            .navigationTitle("OOM Manager")
        } detail: {
            switch selectedItem {
            case .Home:
                HomeView()
            case .equipment:
                EquipmentView(repository: equipmentRepository)
            case .logs:
                CompletedLogsView(equipmentRepository: equipmentRepository, repository: logRepository, user: currentUserLogged!)
            case .completedMaintenace:
                CompletedMaintenancesView(repository: completedMaintenaceRepository, repositoryMaintenance: maintenanceRepository, equipmentRepository: equipmentRepository, completedTaskRepository: completedTaskRepository)
            case .consult:
                ConsultView(taskRepository: taskRepository)
                
            case .none:
                Text("Select a section")
            }
        }
        .onAppear {
            userRepository.fetchAndStoreUsers { error in
                if let error = error {
                    errorMessage = error.localizedDescription
                } else if let token = authManager.getToken(),
                          let userId = extractUserIdFromToken(token) {
                    
                    // Find the logged-in user from the fetched users
                    currentUserLogged = users.first(where: { $0.idUser == userId })
                }
            }
        }

    }
}


func extractUserIdFromToken(_ token: String) -> Int? {
    let parts = token.split(separator: ".")
    guard parts.count >= 2 else { return nil }

    let payloadPart = parts[1]

    var payload = payloadPart.replacingOccurrences(of: "-", with: "+")
                              .replacingOccurrences(of: "_", with: "/")

    // Pad the base64 string if needed
    while payload.count % 4 != 0 {
        payload += "="
    }

    guard let data = Data(base64Encoded: payload),
          let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
          let id = json["id"] as? Int else {
        return nil
    }

    return id
}
