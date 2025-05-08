//
//  EquipmentView.swift
//  OOMManager
//
//  Created by João Martins on 08/05/2025.
//
import SwiftUI
import SwiftData

struct EquipmentView: View {
    @EnvironmentObject var authManager: AuthManager
    @Query private var equipmentList: [EquipmentModel]
    @State private var errorMessage: String?

    let repository: EquipmentRepository
    
    var body: some View {
            VStack {
                if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                }

                EquipmentListView(equipmentList: equipmentList, fetchImage: fetchImage)
            }
            .navigationTitle("Equipment")
            .onAppear {
                repository.fetchAndStoreEquipment { error in
                    if let error = error {
                        errorMessage = error.localizedDescription
                    }
                }
            }

    }

    private func fetchImage(id: Int, completion: @escaping (UIImage?) -> Void) {
        repository.fetchEquipmentImage(for: id, completion: completion)
    }
}


struct EquipmentListView: View {
    let equipmentList: [EquipmentModel]
    let fetchImage: (Int, @escaping (UIImage?) -> Void) -> Void

    var body: some View {
        List(equipmentList) { equipment in
            EquipmentRow(equipment: equipment, fetchImage: fetchImage)
        }
    }
}

struct EquipmentRow: View {
    let equipment: EquipmentModel
    let fetchImage: (Int, @escaping (UIImage?) -> Void) -> Void

    @State private var image: UIImage?

    var body: some View {
        HStack(alignment: .center, spacing: 6) {

            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
                    .overlay(
                        ProgressView()
                    )
            }

            // Text content on the right
            VStack(alignment: .leading, spacing: 4) {
                Text(equipment.name).font(.headline)
                Text("Brand: \(equipment.brand)")
                Text("Model: \(equipment.model)")
                Text("Serial: \(equipment.serialNumber)")
                    .font(.caption)
            }
        }
        .padding()
        .onAppear {
            fetchImage(equipment.idEquipment) { fetchedImage in
                self.image = fetchedImage
            }
        }
    }
}



#Preview {
    EquipmentListView(equipmentList: [
        EquipmentModel(idEquipment: 1, name: "Excavator", brand: "CAT", model: "320D", serialNumber: "SN12345", observations: ""),
        EquipmentModel(idEquipment: 2, name: "Bulldozer", brand: "Komatsu", model: "D65", serialNumber: "SN67890", observations: "")
    ], fetchImage: {
        id, completion in

        let image = UIImage(systemName: "photo")
        completion(image)
    })
}






