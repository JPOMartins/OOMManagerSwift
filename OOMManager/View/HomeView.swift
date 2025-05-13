//
//  HomeView.swift
//  OOMManager
//
//  Created by João Martins on 08/05/2025.
//

import SwiftUI
import SwiftData


struct HomeView: View {
    @Query private var completedMaintenanceActivityModel : [CompletedMaintenanceActivityModel]
    @Query private var logActivityModel : [LogActivityModel]
    let logRepository : LogRepository

    var body: some View {
        NavigationStack {
            HomeScreen(
                completedMaintenacesActivityModel: completedMaintenanceActivityModel,
                logActivityModel: logActivityModel,
                logRepository : logRepository
            )
            .navigationTitle("Atividades em Andamento")
        }
    }
}

struct HomeScreen: View {
    let completedMaintenacesActivityModel: [CompletedMaintenanceActivityModel]
    let logActivityModel: [LogActivityModel]
    let logRepository: LogRepository

    var body: some View {
        VStack {
            ScrollView {
                
                Section(header: HStack{
                    Text("Logs - \(logActivityModel.count)")
                    Spacer()
                }) {
                    ForEach(logActivityModel) { log in
                        LogCard(log: log, logRepository: logRepository)
                    }
                }
                    
                Spacer()
                    
                Section(header: HStack {
                    Text("Maintenances - \(completedMaintenacesActivityModel.count)")
                    Spacer()
                }
                ) {
                    ForEach(completedMaintenacesActivityModel) { maintenance in
                        MaintenanceCard(maintenance: maintenance)
                    }
                }
                
                Spacer()
                
                NavigationLink(destination: InitLog()) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Criar novo Log")
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.oomLogoBlue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.top)
                }
                
                NavigationLink(destination: InitMaintenance()) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Criar nova manutenção")
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.oomLogoBlue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.top)
                }


            }
        }
        .padding(.horizontal)
    }
}


struct LogCard: View {
    let log: LogActivityModel
    @Query private var equipments: [EquipmentModel]
    let logRepository: LogRepository
    
    var equipment: EquipmentModel? {
        equipments.first {$0.idEquipment == log.equipmentID}
    }

    var body: some View {
        NavigationLink(destination: LogActivityView(logRepository: logRepository, logActivity: log)) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Equipamento:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(equipment?.name ?? "N/A")")
                        .font(.body)
                }
                
                HStack {
                    Text("Log:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(log.title ?? "")
                        .font(.body)
                }
                
                HStack {
                    Text("Início:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(log.startedDate)
                        .font(.body)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.separator), lineWidth: 0.5)
            )
            .padding(.vertical, 4)
        }
    }
}



struct MaintenanceCard : View {
    let maintenance: CompletedMaintenanceActivityModel
    @Query private var equipments: [EquipmentModel]
    @Query private var maintenances: [MaintenancesModel]
    
    
    var maintenanceModel: MaintenancesModel? {
        maintenances.first {$0.idMaintenance == maintenance.maintenanceID}
    }
    
    
    var equipment: EquipmentModel? {
        equipments.first {$0.idEquipment == maintenanceModel?.idEquipment}
    }
    
    var body: some View {
        NavigationLink(destination: MaintenanceActivityView(maintenanceActivity: maintenance)) {
            VStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Equipamento:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(equipment?.name ?? "N/A" )
                            .font(.body)
                    }
                    
                    HStack {
                        Text("Maintenances:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(maintenanceModel?.title ?? "N/A")
                            .font(.body)
                    }
                    
                    HStack {
                        Text("Início:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(maintenance.startedDate)
                            .font(.body)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.separator), lineWidth: 0.5)
                )
                .padding(.vertical, 4)
                
            }
        }
    }
}



