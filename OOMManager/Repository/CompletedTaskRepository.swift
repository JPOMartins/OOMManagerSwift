//
//  CompletedTaskRepository.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//

import SwiftData

class CompletedTaskRepository {
    private let apiService: APIService
    private let modelContext: ModelContext

    init(apiService: APIService, context: ModelContext) {
        self.apiService = apiService
        self.modelContext = context
    }

    func fetchAndStoreCompletedTasks(completion: @escaping (Error?) -> Void) {
        apiService.fetchData(from: "https://oomdata.arditi.pt/oom/completedTasks") { (remoteTasks: [CompletedTaskRemote]?, error) in
            if let error = error {
                completion(error)
                return
            }

            guard let remoteTasks = remoteTasks else {
                completion(nil)
                return
            }

            Task { @MainActor in
                for remote in remoteTasks {
                    let completedTask = CompletedTaskModel(
                        idCompletedTask: remote.idCompletedTask,
                        idTask: remote.idTask,
                        idCompletedMaintenance: remote.idCompletedMaintenance,
                        success: remote.sucess,
                        observations: remote.observations
                    )
                    self.modelContext.insert(completedTask)
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
    
    func postCompletedTask(dto: CompletedTaskActivityDTO, completion: @escaping (Bool, Error?) -> Void) {
        let url = "https://oomdata.arditi.pt/oom/completedTasks"
        
        apiService.postData(to: url, body: dto) {(response: CompletedTaskRemote?, error) in
            if let error = error {
                completion(false, error)
                return
            }
            completion(true, nil)
        }
    }
}


