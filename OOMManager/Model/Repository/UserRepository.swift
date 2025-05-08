//
//  UserRepository.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//

import SwiftData

class UserRepository {
    private let apiService: APIService
    private let modelContext: ModelContext

    init(apiService: APIService, context: ModelContext) {
        self.apiService = apiService
        self.modelContext = context
    }

    func fetchAndStoreUsers(completion: @escaping (Error?) -> Void) {
        apiService.fetchData(from: "https://oomdata.arditi.pt/oom/user") { (remoteUsers: [UserModelRemote]?, error) in
            if let error = error {
                completion(error)
                return
            }

            guard let remoteUsers = remoteUsers else {
                completion(nil)
                return
            }

            Task { @MainActor in
                for remoteUser in remoteUsers {
                    let user = UserModel(
                        idUser: remoteUser.idUser,
                        name: remoteUser.name,
                        email: remoteUser.email,
                        type: remoteUser.type
                    )
                    self.modelContext.insert(user)
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
