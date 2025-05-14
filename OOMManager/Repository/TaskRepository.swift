//
//  TaskRepository.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//

import SwiftData

class TaskRepository {
    private let apiService: APIService
    private let modelContext: ModelContext

    init(apiService: APIService, context: ModelContext) {
        self.apiService = apiService
        self.modelContext = context
    }

    func fetchAndStoreTasks(completion: @escaping (Error?) -> Void) {
        apiService.fetchData(from: "https://oomdata.arditi.pt/oom/task") { (remoteTasks: [TaskModelRemote]?, error) in
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
                    let task = TaskModel(
                        idTask: remote.idTask ?? 0,
                        title: remote.title ?? "",
                        description: remote.description ?? "",
                        idMaintenances: remote.maintenancesIdMaintenance ?? 0
                    )
                    self.modelContext.insert(task)
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
    
    func postTask(dto: TaskDTO,completion: @escaping (Bool, Error?) -> Void) {
        apiService.postData(to: "https://oomdata.arditi.pt/oom/task", body: dto) { (response: TaskModelRemote?, error) in
            if let error = error {
                completion(false, error)
                return
            }
            completion(true, nil)
        }
    }
}


