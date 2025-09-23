//
//  RegisterView.swift
//  PhotoEditor
//
//  Created by Begench on 23.09.2025.
//

import SwiftUI

struct ForgotPasswordEmailView: View {
    
    @FocusState private var isFocused: AuthFieldType?
    @State private var email: String = ""
    @State private var showResetPasswordView = false
    
    var isRed: Bool {
        let emailRegex = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return predicate.evaluate(with: email)
    }

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Text("Recover Password")
                .font(.system(size: 36, weight: .bold))
                .padding(.bottom, 40)

            AuthInputField(
                placeholder: "example@gmail.com",
                text: $email,
                fieldType: .email,
                isSecure: false,
                isRed: isRed,
                errorMessage: "Email isn't valid",
                keyboardType: .emailAddress,
                textContentType: .emailAddress,
                focusedField: $isFocused
            )

            CustomButton(title: "Send Reset Link") {
                showResetPasswordView = true
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationDestination(isPresented: $showResetPasswordView) {
            ResetPasswordView()
        }
    }
}



#Preview {
    ForgotPasswordEmailView()
}
