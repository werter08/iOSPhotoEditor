//
//  LoginInview.swift
//  PhotoEditor
//
//  Created by Begench on 23.09.2025.
//

import SwiftUI

struct LoginInView: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject private var loginViewModel = LogInViewModel()
    @FocusState private var focusedField: AuthFieldType?
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Log In")
                    .font(.system(size: 36, weight: .bold))
                    .padding(.top, 40)

                Spacer()

                VStack(spacing: 20) {
                    AuthInputField(
                        placeholder: "example@gmail.com",
                        text: $loginViewModel.email,
                        fieldType: .email,
                        isSecure: false,
                        isRed: loginViewModel.emailIsRed && loginViewModel.showErrors,
                        errorMessage: "Email isn't valid",
                        keyboardType: .emailAddress,
                        textContentType: .emailAddress,
                        focusedField: $focusedField
                    )

                    AuthInputField(
                        placeholder: "Enter password",
                        text: $loginViewModel.password,
                        fieldType: .password,
                        isSecure: true,
                        isRed: loginViewModel.passwordIsRed && loginViewModel.showErrors,
                        errorMessage: "Password must contain 8 digits",
                        textContentType: .password,
                        focusedField: $focusedField
                    )
                }

                Spacer()

                CustomButton(title: "Submit") {
                    if !loginViewModel.canRequest {
                        withAnimation {
                            loginViewModel.showErrors = true
                        }
                    } else {
                        loginViewModel.requestLogIn { isLoggedIn in
                            if isLoggedIn {
                                UserDefaultsManager.userAuthorized = true
                                coordinator.flow = .home
                            }
                        }
                    }
                }

                // MARK: - Navigation Links
                VStack(spacing: 12) {
                    NavigationLink("Forgot Password?") {
                        ForgotPasswordEmailView()
                    }
                    .font(.footnote)
                    .foregroundColor(.blue)

                    HStack {
                        Text("Don't have an account?")
                            .font(.footnote)
                            .foregroundColor(.secondary)

                        NavigationLink("Register") {
                            RegisterView()
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
}



#Preview {
    LoginInView()
}
