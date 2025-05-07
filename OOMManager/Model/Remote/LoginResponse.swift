//
//  LoginResponse.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//

import Foundation

struct LoginResponse: Codable {
    var accessToken: String
    var tokenType: String

    // Decodificador para mapear o JSON para o modelo Swift com nomes personalizados
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
    }
}

