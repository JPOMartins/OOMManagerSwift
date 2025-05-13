//
//  LogsRepository.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//

import SwiftData

class LogRepository {
    private let apiService: APIService
    private let modelContext: ModelContext

    init(apiService: APIService, context: ModelContext) {
        self.apiService = apiService
        self.modelContext = context
    }

    func fetchAndStoreLogs(completion: @escaping (Error?) -> Void) {
        apiService.fetchData(from: "https://oomdata.arditi.pt/oom/log") { (remoteLogs: [LogModelRemote]?, error) in
            if let error = error {
                completion(error)
                return
            }

            guard let remoteLogs = remoteLogs else {
                completion(nil)
                return
            }

            Task { @MainActor in
                for remote in remoteLogs {
                    let log = LogModel(
                        idLog: remote.idLog ?? 0,
                        title: remote.title ?? "",
                        idEquipment: remote.equipmentsIdEquipment ?? 0,
                        userID: remote.userId ?? 0,
                        observations: remote.observations ?? "",
                        startedDate: remote.startedDate ?? "",
                        completedDate: remote.completedDate ?? ""
                    )
                    self.modelContext.insert(log)
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
    
    func postLogActivity(dto: LogActivityDTO, completion: @escaping (Bool, Error?) -> Void) {
            let url = "https://oomdata.arditi.pt/oom/completedTasks"
            
            apiService.postData(to: url, body: dto) { (response: LogModelRemote?, error) in
                if let error = error {
                    completion(false, error)
                    return
                }
                completion(true, nil)
            }
        }
}

