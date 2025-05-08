//
//  LoginView.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//
import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @EnvironmentObject var authManager : AuthManager

    var body: some View {
        VStack {
            Spacer()
            Image("OOM_Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 340, height: 340)

            VStack(spacing: 20) {
                TextField("Username", text: $username)
                    .autocapitalization(.none)
                    .padding(.horizontal)
                    .padding(.vertical, 16)
                    .background(Color(UIColor.systemGray6))
                    .overlay(Rectangle().frame(height: 1).foregroundColor(.gray), alignment: .bottom)

                SecureField("Password", text: $password)
                    .padding(.horizontal)
                    .padding(.vertical, 16)
                    .background(Color(UIColor.systemGray6))
                    .overlay(Rectangle().frame(height: 1).foregroundColor(.gray), alignment: .bottom)
            }
            .padding()

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.bottom, 5)
            }

            Button(action: {
                authManager.loginUser(username: username, password: password) { error in
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }) {
                Text("Login")
                    .fontWeight(.semibold)
                    .foregroundColor(.oomLogoBlue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            .padding(.horizontal)

            Spacer()
        }
    }
}


#Preview {
    LoginView()
}

