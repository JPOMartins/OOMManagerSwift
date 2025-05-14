//
//  AddEquipmentView.swift
//  OOMManager
//
//  Created by João Martins on 14/05/2025.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddEquipmentView: View {
    let equipmentRespository : EquipmentRepository
    var body: some View {
        VStack {
            AddEquipmentBody(repository: equipmentRespository)
        }
        .padding()
        .navigationTitle("Adicionar equipamento")
    }
}

struct AddEquipmentBody: View {
    @State var name: String = ""
    @State var brand: String = ""
    @State var model: String = ""
    @State var nrSerie: String = ""
    @State var nrLibrary: String = ""
    @State var observations: String = ""
    
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var useCamera = false

    let repository: EquipmentRepository

    var body: some View {
        ScrollView {
            Group {
                TextField("Nome*", text: $name)
                TextField("Marca*", text: $brand)
                TextField("Modelo*", text: $model)
                TextField("Número de serie*", text: $nrSerie)
                TextField("Número no library.arditi.pt*", text: $nrLibrary)
                TextField("Observações", text: $observations)
            }
            .autocapitalization(.none)
            .padding(.horizontal)
            .padding(.vertical, 16)
            .background(Color(UIColor.systemGray6))
            .overlay(Rectangle().frame(height: 1).foregroundColor(.gray), alignment: .bottom)
            .padding(.bottom)

            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .cornerRadius(10)
                    .padding(.bottom)
            }

            HStack {
                Button("📷 Tirar Foto") {
                    useCamera = true
                    showImagePicker = true
                }
                Spacer()

                Button("🖼️ Escolher da Galeria") {
                    useCamera = false
                    showImagePicker = true
                }
            }

            Button("Adicionar equipamento") {
                postEquipment()
            }
            .fontWeight(.semibold)
            .foregroundColor(.oomLogoBlue)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: useCamera ? .camera : .photoLibrary)
        }
    }

    func postEquipment() {
        repository.postEquipment(
            name: name,
            brand: brand,
            model: model,
            serialNumber: nrSerie,
            libraryNumber: nrLibrary,
            observations: observations,
            photo: selectedImage
        ) { success, error in
            if success {
                print("Equipamento enviado com sucesso")
            } else {
                print("Erro: \(error?.localizedDescription ?? "Desconhecido")")
            }
        }
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType = .photoLibrary

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
