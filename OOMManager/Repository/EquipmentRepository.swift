//
//  EquipmentRepository.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//

import SwiftData
import UIKit

class EquipmentRepository {
    private let apiService: APIService
    private let modelContext: ModelContext
    
    init(apiService: APIService, context: ModelContext) {
        self.apiService = apiService
        self.modelContext = context
    }
    
    func fetchAndStoreEquipment(completion: @escaping (Error?) -> Void) {
        apiService.fetchData(from: "https://oomdata.arditi.pt/oom/equipment") { (remoteEquipment: [EquipmentModelRemote]?, error) in
            if let error = error {
                completion(error)
                return
            }
            
            guard let remoteEquipment = remoteEquipment else {
                completion(nil)
                return
            }
            
            Task { @MainActor in
                for remote in remoteEquipment {
                    let equipment = EquipmentModel(
                        idEquipment: remote.idEquipment ?? 0,
                        name: remote.name ?? "",
                        brand: remote.brand ?? "",
                        model: remote.model ?? "",
                        serialNumber: remote.serieNumber ?? "",
                        observations: remote.observations ?? ""
                    )
                    self.modelContext.insert(equipment)
                }
                
                do {
                    try self.modelContext.save()
                    completion(nil)
                } catch {
                    completion(error)
                }
            }
        }
    }
    
    func fetchEquipmentImage(for id: Int, completion: @escaping (UIImage?) -> Void) {
        let url = "https://oomdata.arditi.pt/oom/equipment/photo/\(id)"
        
        apiService.fetchImageData(from: url) { data, error in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    func postEquipment(
        name: String,
        brand: String,
        model: String,
        serialNumber: String,
        libraryNumber: String,
        observations: String,
        photo: UIImage?,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        guard let token = AuthManager.shared.getToken() else {
            completion(false, NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Não autenticado"]))
            return
        }

        let boundary = UUID().uuidString
        var request = URLRequest(url: URL(string: "https://oomdata.arditi.pt/oom/equipment")!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()

        func addField(name: String, value: String) {
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(value)\r\n".data(using: .utf8)!)
        }

        addField(name: "name", value: name)
        addField(name: "brand", value: brand)
        addField(name: "model", value: model)
        addField(name: "serie_number", value: serialNumber)
        addField(name: "id", value: libraryNumber)
        addField(name: "observations", value: observations)

        if let photo = photo, let imageData = photo.jpegData(compressionQuality: 0.8) {
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"photo\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            data.append(imageData)
            data.append("\r\n".data(using: .utf8)!)
        }

        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = data

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                completion(false, error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No response"]))
                return
            }

            if (200...299).contains(httpResponse.statusCode) {
                completion(true, nil)
            } else {
                var errorMessage = "API error \(httpResponse.statusCode)"

                    if let data = data,
                       let errorResponse = String(data: data, encoding: .utf8) {
                        print("🔴 Server response body:")
                        print(errorResponse)
                        errorMessage += "\n\(errorResponse)"
                    }
                
                completion(false, NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "API error \(httpResponse.statusCode)"]))
            }
        }.resume()
    }

}

