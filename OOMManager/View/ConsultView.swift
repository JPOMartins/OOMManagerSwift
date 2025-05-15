//
//  ConsultView.swift
//  OOMManager
//
//  Created by João Martins on 09/05/2025.
//
import SwiftUI
import SwiftData

struct ConsultView : View {
    let taskRepository: TaskRepository
    let maintenanceRepository: MaintenanceRepository
    @State private var errorMessage : String?
    
    @Query private var equipments: [EquipmentModel]
    @Query private var maintenances: [MaintenancesModel]
    @Query private var tasks: [TaskModel]
    
    @State private var selectedEquipment: EquipmentModel?
    @State private var selectedMaintenance: MaintenancesModel?
        
    @State private var filteredMaintenances : [MaintenancesModel] = []
    @State private var filteredTasks : [TaskModel] = []
    
    @State private var showAddTaskSheet = false
    @State private var newTaskTitle = ""
    @State private var newTaskDescription = ""
    
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var isError = false
    
    var body: some View {
        ZStack {
            VStack {
                if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                }
                ComboBoxEquipments(allItems: equipments, selectedItem: $selectedEquipment).padding(.bottom)
                ComboBoxMaintenances(allItems: filteredMaintenances, selectedItem: $selectedMaintenance).padding(.bottom)
                HStack {
                    Text("Tarefas")
                        .font(.title2)
                }
                TaskList(taskList: filteredTasks)
                Spacer()
                
                Button("Adicionar tarefa") {
                    showAddTaskSheet = true
                }
                .sheet(isPresented: $showAddTaskSheet) {
                    VStack(alignment: .leading) {
                        Text("Nova Tarefa")
                            .font(.headline)
                        
                        TextField("Título", text: $newTaskTitle)
                            .textFieldStyle(.roundedBorder)
                            .padding(.vertical)
                        
                        TextField("Descrição", text: $newTaskDescription)
                            .textFieldStyle(.roundedBorder)
                            .padding(.bottom)
                        
                        Button("Guardar") {
                            guard let maintenance = selectedMaintenance else {
                                errorMessage = "Selecione uma manutenção primeiro."
                                return
                            }
                            
                            let dto = TaskDTO(
                                title: newTaskTitle,
                                description: newTaskDescription,
                                Maintenances_idMaintenance: maintenance.idMaintenance
                            )
                            
                            taskRepository.postTask(dto: dto) { success, error in
                                DispatchQueue.main.async {
                                    if let error = error {
                                        self.errorMessage = error.localizedDescription
                                        self.toastMessage = "Erro: \(error.localizedDescription)"
                                        self.isError = true
                                    } else {
                                        self.toastMessage = "Tarefa adicionada com sucesso!"
                                        self.isError = false
                                        self.newTaskTitle = ""
                                        self.newTaskDescription = ""
                                        self.showAddTaskSheet = false
                                    }
                                    
                                    self.showToast = true
                                    

                                }
                            }
                            
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.oomLogoBlue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                        Spacer()
                    }
                    .padding()
                }
                
                NavigationLink(destination: AddMaintenancesView(maintenaceRepository: maintenanceRepository)) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Criar novo manutenção")
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
            .padding()
            .onChange(of: selectedEquipment) { oldValue , newValue in
                filteredMaintenances = maintenances.filter { $0.idEquipment == newValue?.idEquipment}
            }
            .onChange(of: selectedMaintenance) { oldValue, newValue in
                filteredTasks = tasks.filter { $0.idMaintenances == newValue?.idMaintenance}
            }
            .onAppear {
                taskRepository.fetchAndStoreTasks { error in
                    if let error = error {
                        errorMessage = error.localizedDescription
                    }
                }
            }
            if(showToast) {
                Toast(toastMessage: $toastMessage, showToast: $showToast, isError: $isError)
            }
        }
    
        .navigationTitle("Consultar")
    }
    
    
}
