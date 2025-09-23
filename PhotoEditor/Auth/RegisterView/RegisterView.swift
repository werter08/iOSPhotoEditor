//
//  RegisterView.swift
//  PhotoEditor
//
//  Created by Begench on 23.09.2025.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var registerViewModel = RegisterViewModel()
    @FocusState private var focusedField: AuthFieldType?
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Register")
                .font(.system(size: 36, weight: .bold))
                .padding(.top, 40)

            Spacer()

            VStack(spacing: 20) {
                AuthInputField(
                    placeholder: "example@gmail.com",
                    text: $registerViewModel.email,
                    fieldType: .email,
                    isSecure: false,
                    isRed: registerViewModel.emailIsRed && registerViewModel.showErrors,
                    errorMessage: "Email isn't valid",
                    keyboardType: .emailAddress,
                    textContentType: .emailAddress,
                    focusedField: $focusedField
                )

                AuthInputField(
                    placeholder: "Password",
                    text: $registerViewModel.password,
                    fieldType: .password,
                    isSecure: true,
                    isRed: registerViewModel.passwordIsRed && registerViewModel.showErrors,
                    errorMessage: "Password must contain 8 digits",
                    textContentType: .password,
                    focusedField: $focusedField
                )
                
                AuthInputField(
                    placeholder: "Confirm Password",
                    text: $registerViewModel.confPassword,
                    fieldType: .confirmPassword,
                    isSecure: true,
                    isRed: registerViewModel.confPasswordIsRed && registerViewModel.showErrors,
                    errorMessage: "Passwords must be same",
                    textContentType: .password,
                    focusedField: $focusedField
                )
            }

            Spacer()

            CustomButton(title: "Register") {
                if !registerViewModel.canRequest {
                    withAnimation {
                        registerViewModel.showErrors = true
                    }
                } else {
                    registerViewModel.requestRegister()
                }
            }

            // MARK: - Navigation Links
            VStack(spacing: 12) {
                HStack {
                    Text("Have an account?")
                        .font(.footnote)
                        .foregroundColor(.secondary)

                    NavigationLink("Log in") {
                        LoginInView()
                    }
                    .font(.footnote)
                    .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}
#Preview {
    RegisterView()
}
