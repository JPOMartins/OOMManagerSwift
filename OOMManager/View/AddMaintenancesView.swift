//
//  AddMaintenancesView.swift
//  OOMManager
//
//  Created by João Martins on 14/05/2025.
//

import SwiftUI
import SwiftData

struct AddMaintenancesView : View {
    @Environment(\.dismiss) private var dismiss
    let maintenaceRepository: MaintenanceRepository
    
    private func addMaintenance(dto: MaintenanceDTO) {
        maintenaceRepository.postMaintenance(dto: dto) { sucess, error in
            if let error = error {
                print("Erro ao adicionar manutenção: \(error)")
                return
            }
            dismiss()
        }
    }
    
    var body : some View {
        VStack {
            AddMaintenancesBody(addMaintenance: addMaintenance)
        }
        .padding()
        .navigationTitle("Adicionar manutenção")
        
    }
}

struct AddMaintenancesBody : View {
    @Query private var equipments : [EquipmentModel]

    @State private var selectedEquipment: EquipmentModel?
    @State private var title: String = ""
    @State private var periodicityText: String = "" 

    var addMaintenance : (MaintenanceDTO) -> Void

    var body: some View {
        ComboBoxEquipments(allItems: equipments, selectedItem: $selectedEquipment)
            .padding(.bottom)

        TextField("Título", text: $title)
            .autocapitalization(.none)
            .padding(.horizontal)
            .padding(.vertical, 16)
            .background(Color(UIColor.systemGray6))
            .overlay(Rectangle().frame(height: 1).foregroundColor(.gray), alignment: .bottom)
            .padding(.bottom)

        TextField("Periodicidade (opcional)", text: $periodicityText)
            .keyboardType(.numberPad)
            .autocapitalization(.none)
            .padding(.horizontal)
            .padding(.vertical, 16)
            .background(Color(UIColor.systemGray6))
            .overlay(Rectangle().frame(height: 1).foregroundColor(.gray), alignment: .bottom)
            .padding(.bottom)

        Button("Adicionar manutenção") {
            guard let equipment = selectedEquipment else {
                print("Selecione um equipamento.")
                return
            }
            
            let periodicity: Int? = Int(periodicityText)

            let maintenance = MaintenanceDTO(
                title: title,
                equipment_id: equipment.idEquipment,
                periodicity: periodicity
            )
            addMaintenance(maintenance)
        }
        .fontWeight(.semibold)
        .foregroundColor(.oomLogoBlue)
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)

        Spacer()
    }
}


#Preview {
    AddMaintenancesBody(addMaintenance: { _ in
        print("Preview: Manutenção adicionada")
    })
}
