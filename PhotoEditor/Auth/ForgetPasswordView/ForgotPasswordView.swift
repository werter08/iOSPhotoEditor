//
//  RegisterView.swift
//  PhotoEditor
//
//  Created by Begench on 23.09.2025.
//

import SwiftUI
import FirebaseAuth

struct ForgotPasswordEmailView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var loginViewModel = LogInViewModel()
    @FocusState private var isFocused: AuthFieldType?
    @State private var email: String = ""
    @State private var inProccess = false
   

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Text("Recover Password")
                .font(.system(size: 36, weight: .bold))
                .padding(.bottom, 40)

            AuthInputField(
                placeholder: "example@gmail.com",
                text: $loginViewModel.email,
                fieldType: .email,
                isSecure: false,
                isRed: loginViewModel.emailIsRed && loginViewModel.showErrors,
                errorMessage: "Email isn't valid",
                keyboardType: .emailAddress,
                textContentType: .emailAddress,
                focusedField: $isFocused
            )
            
            CustomButton(title: "Send Reset Link", showProggresView: $inProccess) {
                inProccess = true
                Auth.auth().sendPasswordReset(withEmail: loginViewModel.email) { error in
                    if let error {
                        print(error)
                        inProccess = false
                        return
                    } else {
                        inProccess = false
                        dismiss()
                    }
                }

            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}



#Preview {
    ForgotPasswordEmailView()
}
