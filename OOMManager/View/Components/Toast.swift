//
//  Toast.swift
//  OOMManager
//
//  Created by João Martins on 15/05/2025.
//

import SwiftUI

struct Toast : View {
    @Binding var toastMessage : String
    @Binding var showToast : Bool
    @Binding var isError: Bool
    var body: some View {
        VStack {
            Spacer()
            Text(toastMessage)
                .foregroundColor(.white)
                .padding()
                .background(isError ? Color.red : Color.green)
                .cornerRadius(8)
                .shadow(radius: 4)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showToast = false
                        }
                    }
                }
            Spacer().frame(height: 30)
        }
        .animation(.easeInOut, value: showToast)
    }
}

