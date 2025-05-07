//
//  EquipmentRepository.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//

import SwiftData

class EquipmentRepository {
    private let apiService: APIService
    private let modelContext: ModelContext

    init(apiService: APIService, context: ModelContext) {
        self.apiService = apiService
        self.modelContext = context
    }

    func fetchAndStoreEquipment(completion: @escaping (Error?) -> Void) {
        apiService.fetchData(from: "https://oomdata.arditi.pt/oom/equipment") { (remoteEquipment: [EquipmentModelRemote]?, error) in
            if let error = error {
                completion(error)
                return
            }

            guard let remoteEquipment = remoteEquipment else {
                completion(nil)
                return
            }

            Task { @MainActor in
                for remote in remoteEquipment {
                    let equipment = EquipmentModel(
                        idEquipment: remote.idEquipment ?? 0,
                        name: remote.name ?? "",
                        brand: remote.brand ?? "",
                        model: remote.model ?? "",
                        serialNumber: remote.serieNumber ?? "",
                        observations: remote.observations ?? ""
                    )
                    self.modelContext.insert(equipment)
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

