//
//  CompletedLogDetailView.swift
//  OOMManager
//
//  Created by João Martins on 09/05/2025.
//
import SwiftUI

import SwiftUI

struct CompletedLogDetailView: View {
    let log: LogModel
    let equipment: EquipmentModel?
    let user: UserModel
    let equipmentRepository: EquipmentRepository

    var body: some View {
        VStack {
            ScrollView {
                CompletedLogBodyView(log: log, equipment: equipment, user: user, fetchImage: fetchImage)
                    .padding()
            }
        }
    }
    private func fetchImage(id: Int, completion: @escaping (UIImage?) -> Void) {
        equipmentRepository.fetchEquipmentImage(for: id, completion: completion)
    }
}

struct CompletedLogBodyView: View {
    let log: LogModel
    let equipment: EquipmentModel?
    let user: UserModel
    let fetchImage: (Int, @escaping (UIImage?) -> Void) -> Void
    
    @State private var image: UIImage?

    var durationText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        guard
            let startDate = formatter.date(from: log.startedDate),
            let endDate = formatter.date(from: log.completedDate)
        else {
            return "N/A"
        }

        let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: startDate, to: endDate)

        var parts: [String] = []
        if let days = components.day, days > 0 {
            parts.append("\(days) day(s)")
        }
        if let hours = components.hour, hours > 0 {
            parts.append("\(hours) hour(s)")
        }
        if let minutes = components.minute, minutes > 0 {
            parts.append("\(minutes) min(s)")
        }
        
        if let seconds = components.second, seconds > 0 {
            parts.append("\(seconds) sec(s)")
        }

        return parts.joined(separator: ", ")
    }

    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Log")
                        .font(.title)
                        .foregroundColor(.oomLogoBlue)
                    Spacer()
                }
                
                Divider()
                    .padding(.bottom)
                
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(8)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .overlay(
                            ProgressView()
                        )
                }
                
                HStack {
                    Text("Utilizador: ")
                        .bold(true)
                        .font(.title3)
                    Text(user.name)
                    Spacer()
                }
                .padding(.vertical, 5)
                
                HStack {
                    Text("Equipamento: ")
                        .bold(true)
                        .font(.title3)
                    Text(equipment?.name ?? "N/A")
                    Spacer()
                }
                .padding(.vertical, 5)
                
                
                VStack {
                    HStack {
                        Text("Título")
                            .foregroundColor(.oomLogoBlue)
                            .bold(true)
                            .font(.title3)
                        Spacer()
                    }
                    .padding(.vertical, 5)
                    
                    HStack {
                        Text(log.title)
                        Spacer()
                    }
                }
                
                VStack {
                    HStack {
                        Text("Duração:")
                            .foregroundColor(.oomLogoBlue)
                            .bold(true)
                            .font(.title3)
                        Spacer()
                    }
                    .padding(.vertical, 5)
                    
                    HStack {
                        Text(durationText)
                        Spacer()
                    }
                }
                
                VStack {
                    HStack {
                        Text("Detalhes:")
                            .foregroundColor(.oomLogoBlue)
                            .bold(true)
                            .font(.title3)
                        Spacer()
                    }
                    .padding(.vertical, 5)
                    
                    HStack {
                        Text("Início: ")
                        Text(log.startedDate)
                        Spacer()
                    }
                    HStack {
                        Text("Fim: ")
                        Text(log.completedDate)
                        Spacer()
                    }
                }
                
                VStack {
                    HStack {
                        Text("Observação:")
                            .foregroundColor(.oomLogoBlue)
                            .bold(true)
                            .font(.title3)
                        Spacer()
                    }
                    .padding(.top, 5)
                    
                    HStack {
                        Text(log.observations)
                        Spacer()
                    }
                }
            }.padding()
        }.onAppear {
            if let equipment = equipment {
                fetchImage(equipment.idEquipment) { fetchedImage in
                    self.image = fetchedImage
                }
            }
        }
        .navigationTitle(log.title)
    }
}

#Preview {
    CompletedLogBodyView(
        log: LogModel(
            idLog: 1,
            title: "Routine Inspection",
            idEquipment: 101,
            userID: 501,
            observations: "All systems functional, no issues found.",
            startedDate: "2025-05-01T08:30:23",
            completedDate: "2025-05-02T14:15:00"
        ),
        equipment: EquipmentModel(
            idEquipment: 101,
            name: "Air Compressor X200",
            brand: "CompAir",
            model: "X200",
            serialNumber: "ACX200-54321",
            observations: "Used daily, serviced last month."
        ),
        user: UserModel(
            idUser: 501,
            name: "Maria Silva",
            email: "maria.silva@example.com",
            type: "Technician"
        ),
        fetchImage: {
            id, completion in

            let image = UIImage(systemName: "photo")
            completion(image)
        }
    )
}




