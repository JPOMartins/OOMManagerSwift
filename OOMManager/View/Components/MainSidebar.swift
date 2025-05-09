//
//  MainSidebar.swift
//  OOMManager
//
//  Created by João Martins on 08/05/2025.
//

import SwiftUI

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
    
    @State private var columnVisibility: NavigationSplitViewVisibility = .automatic


    @State private var selectedItem: SidebarItem? = .Home

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $selectedItem) {
                Section(header: Text("Menu")) {
                    NavigationLink(value: SidebarItem.Home) {
                        Label("Home", systemImage: "house")
                    }
                }
                Section(header: Text("Equipments")) {
                    NavigationLink(value: SidebarItem.equipment) {
                        Label("Equipment", systemImage: "desktopcomputer")
                    }
                }
                Section(header: Text("Histórico")) {
                    NavigationLink(value: SidebarItem.logs) {
                        Label("Logs", systemImage: "doc.plaintext")
                    }
                    NavigationLink(value: SidebarItem.completedMaintenace) {
                        Label("Maintenance", systemImage: "wrench")
                    }
                }
                
                Section(header: Text("Dados")) {
                    NavigationLink(value: SidebarItem.consult) {
                        Label("Consult", systemImage: "book.pages")
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
                CompletedLogsView(repository: logRepository)
            case .completedMaintenace:
                CompletedMaintenancesView(repository: completedMaintenaceRepository, repositoryMaintenance: maintenanceRepository)
            case .consult:
                ConsultView(taskRepository: taskRepository)
                
            case .none:
                Text("Select a section")
            }
        }
    }
}


