//
//  CompletedMaintenanceRepository.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//

import SwiftData
import Foundation

class CompletedMaintenanceRepository {
    private let apiService: APIService
    private let modelContext: ModelContext
    private let completedTaskRepository: CompletedTaskRepository

    init(apiService: APIService, context: ModelContext, completedTaskRepository: CompletedTaskRepository) {
        self.apiService = apiService
        self.modelContext = context
        self.completedTaskRepository = completedTaskRepository
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
    
    func postCompletedMaintenance(
        dto: CompletedMaintenanceActivityDTO,
        taskInputs: [CompletedTaskActivityDTO],
        completion: @escaping (Bool, Error?) -> Void
    ) {
        apiService.postData(to: "https://oomdata.arditi.pt/oom/completedMaintenances", body: dto) { (response: CompletedMaintenancesRemote?, error) in
            if let error = error {
                completion(false, error)
                return
            }

            guard let completedMaintenanceId = response?.idCompletedMaintenance else {
                completion(false, NSError(domain: "MissingID", code: 0, userInfo: [NSLocalizedDescriptionKey: "Missing maintenance ID"]))
                return
            }

            let taskDTOs = taskInputs
                .map {
                    CompletedTaskActivityDTO(
                        sucess: $0.sucess,
                        observations: $0.observations,
                        idTask: $0.idTask,
                        idCompletedMaintenance: completedMaintenanceId,
                    )
                }

            let group = DispatchGroup()
            var finalError: Error?

            for dto in taskDTOs {
                group.enter()
                self.completedTaskRepository.postCompletedTask(dto: dto) { success, error in
                    if let error = error {
                        finalError = error
                    }
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                if let error = finalError {
                    completion(false, error)
                } else {
                    completion(true, nil)
                }
            }
        }
    }
    
}
