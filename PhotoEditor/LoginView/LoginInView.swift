//
//  LoginInview.swift
//  PhotoEditor
//
//  Created by Begench on 23.09.2025.
//

import SwiftUI
import SwiftUI

struct LoginInView: View {
    @StateObject private var loginViewModel = LogInViewModel()
    
   
    
    @FocusState private var focusedField: String?

    var body: some View {
        VStack(spacing: 16) {
            TextField("Login", text: $loginViewModel.email)
                .textFieldStyle(CustomTextFieldStyle(isFocused: focusedField == "login"))
                .focused($focusedField, equals: "login")

            SecureField("Password", text: $loginViewModel.password)
                .textFieldStyle(CustomTextFieldStyle(isFocused: focusedField == "password"))
                .focused($focusedField, equals: "password")
        }
        .padding()
    }
}


#Preview {
    LoginInView()
}
