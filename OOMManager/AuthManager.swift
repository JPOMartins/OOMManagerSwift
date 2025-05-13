//
//  AuthManager.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//

import Foundation
import SwiftUI

class AuthManager: ObservableObject {
    static let shared = AuthManager()
    @AppStorage("authToken") var authToken: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: UserModel?
    
    func getToken() -> String? {
        return authToken.isEmpty ? nil : authToken
    }

    struct LoginResponse: Decodable {
        let access_token: String
        let token_type: String
    }
    
    func setCurrentUser(_ user: UserModel) {
        self.currentUser = user
    }

    func loginUser(username: String, password: String, completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: "https://oomdata.arditi.pt/oom/user/login") else {
            completion(NSError(domain: "Invalid URL", code: 400))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        // URL-encoded body
        let bodyString = "username=\(username.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&password=\(password.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        request.httpBody = bodyString.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(error)
                    return
                }

                guard let data = data else {
                    completion(NSError(domain: "No data", code: 404))
                    return
                }

                do {
                    print(String(data: data, encoding: .utf8) ?? "Invalid UTF-8")
                    let decoded = try JSONDecoder().decode(LoginResponse.self, from: data)
                    self.authToken = decoded.access_token
                    self.isAuthenticated = true
                    completion(nil)
                } catch {
                    completion(error)
                }
            }
        }.resume()
    }

}


