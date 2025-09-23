//
//  ResetPasswordView.swift
//  PhotoEditor
//
//  Created by Begench on 23.09.2025.
//

import SwiftUI

struct ResetPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showLogin = false
    @State private var showError = false
    @FocusState private var focusedField: AuthFieldType?

    var passwordsMatch: Bool {
        password == confirmPassword && password.count >= 8
    }

    var body: some View {
        VStack(spacing: 24) {
            Text("Set New Password")
                .font(.system(size: 36, weight: .bold))
                .padding(.top, 40)

            Spacer()
            
            VStack(spacing: 20) {
                AuthInputField(
                    placeholder: "Enter new password",
                    text: $password,
                    fieldType: .password,
                    isSecure: true,
                    isRed: !passwordsMatch && showError,
                    errorMessage: "Password must contain 8 digits",
                    textContentType: .password,
                    focusedField: $focusedField
                )

                AuthInputField(
                    placeholder: "Re-enter new password",
                    text: $confirmPassword,
                    fieldType: .confirmPassword,
                    isSecure: true,
                    isRed: !passwordsMatch && showError,
                    errorMessage: "Passwords do not match",
                    textContentType: .password,
                    focusedField: $focusedField
                )
            }
            

            Spacer()

            
            CustomButton(title: "Change Password") {
                if passwordsMatch {
                    // Simulate success
                    showLogin = true
                } else {
                    showError = true
                }
            }

        }
        .padding()
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationDestination(isPresented: $showLogin) {
            LoginInView()
        }
    }
}


#Preview {
    ResetPasswordView()
}
