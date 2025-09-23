//
//  CustomTextFieldStyle.swift
//  PhotoEditor
//
//  Created by Begench on 23.09.2025.
//

import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
    var isFocused: Bool
    
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding(12)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isFocused ? Color.blue : Color.black, lineWidth: 2)
                    .animation(.easeInOut(duration: 0.2), value: isFocused)

            )
    }
}


