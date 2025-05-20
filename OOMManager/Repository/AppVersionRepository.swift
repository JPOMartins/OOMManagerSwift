//
//  AppVersionRepository.swift
//  OOMManager
//
//  Created by Carlos Lucas on 20/05/2025.
//

import SwiftData
import Foundation

class AppVersionRepository {
    private let apiService: APIService
    private let modelContext: ModelContext
    
    init(apiService: APIService, modelContext: ModelContext) {
        self.apiService = apiService
        self.modelContext = modelContext
    }
    
}
