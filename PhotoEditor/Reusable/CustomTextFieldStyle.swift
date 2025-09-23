//
//  CustomTextFieldStyle.swift
//  PhotoEditor
//
//  Created by Begench on 23.09.2025.
//

import SwiftUI

struct AuthInputField: View {
    var placeholder: String
    @Binding var text: String
    var fieldType: AuthFieldType
    var isSecure: Bool = false
    var isRed: Bool = false
    var errorMessage: String? = nil
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil
    @FocusState.Binding var focusedField: AuthFieldType?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .textContentType(textContentType)
                        .keyboardType(keyboardType)
                        .textFieldStyle(CustomTextFieldStyle(
                            isFocused: focusedField == fieldType,
                            isRed: isRed
                        ))
                        .focused($focusedField, equals: fieldType)
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                        .textContentType(textContentType)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .textFieldStyle(CustomTextFieldStyle(
                            isFocused: focusedField == fieldType,
                            isRed: isRed
                        ))
                        .focused($focusedField, equals: fieldType)
                }
            }
            
            if let error = errorMessage, isRed {
                Text("• \(error)")
                    .foregroundColor(.red)
                    .font(.caption)
                    .transition(.opacity)
            }
        }
    }
}


struct CustomTextFieldStyle: TextFieldStyle {
    var isFocused: Bool
    var isRed: Bool
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding(12)
            .background(Color.white)
            .cornerRadius(8)
            .overlay( RoundedRectangle(cornerRadius: 8)
                .stroke(isRed ? Color.red : isFocused ? Color.blue : Color.black, lineWidth: isFocused ? 2 : 1)
                .animation(.easeInOut(duration: 0.2), value: isFocused) )
    }
}
