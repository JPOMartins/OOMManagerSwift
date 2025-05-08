//
//  OOMManagerApp.swift
//  OOMManager
//
//  Created by João Martins on 06/01/2025.
//

import SwiftUI
import SwiftData

@main
struct OOMManagerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            AppVersionModel.self,
            CompletedMaintenanceModel.self,
            UserModel.self,
            CompletedMaintenanceActivityModel.self,
            CompletedTaskModel.self,
            EquipmentModel.self,
            LogModel.self,
            LogActivityModel.self,
            TaskModel.self,
            PostCompletedTaskModel.self,
            PostCompletedMaintenanceModel.self,
            PostLogModel.self,
            TaskActivityModel.self,
            MaintenancesModel.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @StateObject private var authManager = AuthManager()

    private var apiService = APIService()
    
    private var equipmentRepository: EquipmentRepository
    private var logRepository: LogRepository
    private var completedMaintenanceRepository : CompletedMaintenanceRepository

    init() {
        let context = sharedModelContainer.mainContext
        self.equipmentRepository = EquipmentRepository(apiService: apiService, context: context)
        self.logRepository = LogRepository(apiService: apiService, context: context)
        self.completedMaintenanceRepository = CompletedMaintenanceRepository(apiService: apiService, context: context)
    }

    var body: some Scene {
        WindowGroup {
            if authManager.isAuthenticated {
                MainSidebarView(
                    equipmentRepository: equipmentRepository,
                    logRepository: logRepository,
                    completedMaintenaceRepository: completedMaintenanceRepository
                )
                .environmentObject(authManager)
            } else {
                LoginView()
                .environmentObject(authManager)
            }
        }
        .modelContainer(sharedModelContainer)
    }
}


