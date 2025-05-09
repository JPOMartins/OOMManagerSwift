//
//  ComboBoxMaintenances.swift
//  OOMManager
//
//  Created by João Martins on 09/05/2025.
//

import SwiftUI

struct ComboBoxMaintenances: View {
    let allItems: [MaintenancesModel]
    @Binding var selectedItem: MaintenancesModel?
    @State private var query: String = ""
    @State private var showSuggestions: Bool = false

    var filteredItems: [MaintenancesModel] {
        if query.isEmpty {
            return allItems
        } else {
            return allItems.filter {
                $0.title.lowercased().contains(query.lowercased())
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ZStack(alignment: .trailing) {
                TextField("Select maintenance...", text: $query, onEditingChanged: { isEditing in
                    showSuggestions = isEditing
                })
                .onChange(of: query) { oldValue, newValue in
                    showSuggestions = true
                }
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                
                Image(systemName: showSuggestions ? "chevron.up" : "chevron.down")
                    .foregroundColor(.gray)
                    .padding(.trailing, 12)
                    .onTapGesture {
                        showSuggestions.toggle()
                    }
            }

            if showSuggestions && !filteredItems.isEmpty {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(filteredItems, id: \.idEquipment) { item in
                            Button {
                                query = item.title
                                selectedItem = item
                                showSuggestions = false
                            } label: {
                                HStack {
                                    Text(item.title)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                                .background(Color(.systemBackground))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .frame(maxHeight: 180)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 2)
            }
        }
        .animation(.default, value: showSuggestions)
        .padding(.horizontal)
    }
}

