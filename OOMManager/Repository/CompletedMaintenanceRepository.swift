//
//  CompletedMaintenanceRepository.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//

import SwiftData

class CompletedMaintenanceRepository {
    private let apiService: APIService
    private let modelContext: ModelContext

    init(apiService: APIService, context: ModelContext) {
        self.apiService = apiService
        self.modelContext = context
    }
    
    func fetchAndStoreCompletedMaintenance (completion: @escaping (Error?) -> Void) {
        apiService.fetchData(from: "https://oomdata.arditi.pt/oom/completedMaintenances") { (remoteCompletedMaintenances:[CompletedMaintenancesRemote]?, error) in
            if let error = error {
                completion(error)
                return
            }

            guard let remoteCompletedMaintenances = remoteCompletedMaintenances else {
                completion(nil)
                return
            }

            Task { @MainActor in
                for remoteCompletedMaintenance in remoteCompletedMaintenances {
                   let completedMaintenance = CompletedMaintenanceModel(
                    idCompletedMaintenance: remoteCompletedMaintenance.idCompletedMaintenance ?? 0,
                    completedDate: remoteCompletedMaintenance.completedDate ?? "",
                    startedDate: remoteCompletedMaintenance.startedDate ?? "",
                    observation: remoteCompletedMaintenance.observations ?? "",
                    idMaintenance: remoteCompletedMaintenance.maintenancesIdMaintenance ?? 0,
                    idUser: remoteCompletedMaintenance.usersIdUser ?? 0
                   )
                    self.modelContext.insert(completedMaintenance)
                }

                do {
                    try self.modelContext.save()
                    completion(nil)
                } catch {
                    completion(error)
                }
            }
            
        }
    }
    
    
}
