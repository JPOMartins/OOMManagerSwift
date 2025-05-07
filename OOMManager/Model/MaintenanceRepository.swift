//
//  MaintenanceRepository.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//
import SwiftData

class MaintenanceRepository {
    private let apiService: APIService
    private let modelContext: ModelContext

    init(apiService: APIService, context: ModelContext) {
        self.apiService = apiService
        self.modelContext = context
    }

    func fetchAndStoreMaintenances(completion: @escaping (Error?) -> Void) {
        apiService.fetchData(from: "https://oomdata.arditi.pt/oom/maintenances") { (remoteMaintenances: [MaintenancesModelRemote]?, error) in
            if let error = error {
                completion(error)
                return
            }

            guard let remoteMaintenances = remoteMaintenances else {
                completion(nil)
                return
            }

            Task { @MainActor in
                for remote in remoteMaintenances {
                    let maintenance = MaintenancesModel(
                        idMaintenance: remote.idMaintenance ?? 0,
                        title: remote.title ?? "",
                        idEquipment: remote.equipmentsIdEquipment ?? 0,
                        periodicity: remote.periodicity ?? 0
                    )
                    self.modelContext.insert(maintenance)
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
