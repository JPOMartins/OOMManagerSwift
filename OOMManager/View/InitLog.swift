//
//  InitLog.swift
//  OOMManager
//
//  Created by João Martins on 13/05/2025.
//

import SwiftUI
import SwiftData

struct InitLog: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @Query private var equipments: [EquipmentModel]
    @State private var selectedEquipment: EquipmentModel?

    var body: some View {
        VStack {
            ComboBoxEquipments(allItems: equipments, selectedItem: $selectedEquipment)
                .padding(.bottom)
            
            TextField("Título", text: $title)
                .autocapitalization(.none)
                .padding(.horizontal)
                .padding(.vertical, 16)
                .background(Color(UIColor.systemGray6))
                .overlay(Rectangle().frame(height: 1).foregroundColor(.gray), alignment: .bottom)
            
            HStack {
                Spacer()
                Button("Iniciar log") {
                    guard let selectedEquipment = selectedEquipment else { return }

                    let dateFormatter = ISO8601DateFormatter()
                    let nowString = dateFormatter.string(from: Date())

                    if let user = authManager.currentUser {
                        let newActivityLog = LogActivityModel(
                            title: title,
                            startedDate: nowString,
                            equipmentID: selectedEquipment.idEquipment,
                            userID: user.idUser
                        )
                        modelContext.insert(newActivityLog)
                        dismiss()
                    } else {
                        print("No user")
                    }

                    
                    title = ""
                    self.selectedEquipment = nil
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}



#Preview {
    InitLog()
}

