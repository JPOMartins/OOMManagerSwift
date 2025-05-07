//
//  AuthManager.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//

class AuthManager {
    static let shared = AuthManager()
    private init() {}

    private var token: String?

    func setToken(_ newToken: String) {
        token = newToken
    }

    func getToken() -> String? {
        return token
    }
}

