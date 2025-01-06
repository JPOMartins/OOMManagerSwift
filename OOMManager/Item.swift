//
//  Item.swift
//  OOMManager
//
//  Created by Carlos Lucas on 06/01/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
