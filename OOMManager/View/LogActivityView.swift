//
//  LogActivityView.swift
//  OOMManager
//
//  Created by João Martins on 13/05/2025.
//

import SwiftUI
import SwiftData

struct LogActivityView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var isError = false

    let logRepository : LogRepository
    
    @Bindable var logActivity: LogActivityModel
    
    @Query private var equipments : [EquipmentModel]
    
    @State private var observation : String = ""
    
    private var equipment : EquipmentModel? {
        equipments.first {$0.idEquipment == logActivity.equipmentID}
    }
    
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Equipamento: ")
                                .foregroundColor(.oomLogoBlue)
                                .bold(true)
                                .font(.title3)
                            Text(equipment?.name ?? "N/A")
                            Spacer()
                        }
                        .padding(.bottom)
                        
                        HStack {
                            Text("Log: ")
                                .foregroundColor(.oomLogoBlue)
                                .bold(true)
                                .font(.title3)
                            Text(logActivity.title ?? "N/A")
                            Spacer()
                        }
                        .padding(.bottom)
                        
                        HStack {
                            Text("Observação: ")
                                .foregroundColor(.oomLogoBlue)
                                .bold(true)
                                .font(.title3)
                            Spacer()
                        }
                        
                        TextEditor(text: Binding(
                            get: { logActivity.observations ?? "" },
                            set: { logActivity.observations = $0 }
                        ))
                            .frame(height: 260)
                            .padding(8)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                        
                        HStack {
                            Button("Adicionar hora ao texto") {
                                logActivity.observations! += "\n\(DateFormatter.logTimeFormatter.string(from: Date())) "
                            }
                            .fontWeight(.semibold)
                            .foregroundColor(.oomLogoBlue)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                            
                            Spacer()
                        }
                        .padding(.bottom)
                    }
                    .padding()
                }
                
                HStack {
                    Spacer()
                    Button("Cancelar") {
                        modelContext.delete(logActivity)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.oomLogoBlue)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    
                    Spacer()
                    Button("Enviar log") {
                        let dateFormatter = ISO8601DateFormatter()
                        let nowString = dateFormatter.string(from: Date())
                        
                        let dto = LogActivityDTO(title: logActivity.title!, observations: observation, startedDate: logActivity.startedDate, CompletedDate: nowString, Equipments_idEquipment: logActivity.equipmentID, users_idUser: logActivity.userID!)
                        
                        logRepository.postLogActivity(dto: dto) { success, error in
                            DispatchQueue.main.async {
                                if success {
                                    self.toastMessage = "Log enviada com sucesso"
                                    self.isError = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation {
                                            modelContext.delete(logActivity)
                                            dismiss()
                                        }
                                    }
                                } else {
                                    self.toastMessage = "Erro ao enviar log"
                                    self.isError = true
                                }
                            }
                            self.showToast = true
                        }
                        
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.oomLogoBlue)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    Spacer()
                }
                .padding()
                .navigationTitle("Log ativa")
            }
            if(showToast) {
                Toast(toastMessage: $toastMessage, showToast: $showToast, isError: $isError)
            }
        }
    }
}

extension DateFormatter {
    static let logTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss dd/MM/yyyy -"
        return formatter
    }()
}



