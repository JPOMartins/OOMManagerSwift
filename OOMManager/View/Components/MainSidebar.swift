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
}

struct MainSidebarView: View {
    @EnvironmentObject var authManager: AuthManager

    let equipmentRepository: EquipmentRepository
    let logRepository: LogRepository
    let completedMaintenaceRepository: CompletedMaintenanceRepository
    @State private var columnVisibility: NavigationSplitViewVisibility = .automatic


    @State private var selectedItem: SidebarItem? = .Home

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $selectedItem) {
                NavigationLink(value: SidebarItem.Home) {
                    Label("Home", systemImage: "house")
                }
                NavigationLink(value: SidebarItem.equipment) {
                    Label("Equipment", systemImage: "desktopcomputer")
                }
                NavigationLink(value: SidebarItem.logs) {
                    Label("Logs", systemImage: "doc.plaintext")
                }
                NavigationLink(value: SidebarItem.completedMaintenace) {
                    Label("Maintenance", systemImage: "wrench")
                    
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
                CompletedMaintenancesView(repository: completedMaintenaceRepository)
                
            case .none:
                Text("Select a section")
            }
        }
    }
}


