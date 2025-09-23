//
//  CustoBVutton.swift
//  PhotoEditor
//
//  Created by Begench on 23.09.2025.
//
import SwiftUI

struct CustomButton: View {
    var title: String
    var action: () -> Void
    var maxWidthIsInfinity: Bool = true
    var font: Font = .headline
    var foregroundColor: Color = .white
    var backgroundColor: Color = .blue
    var cornerRadius: CGFloat = 12
    var horizontalPadding: CGFloat = 16
    var verticalPadding: CGFloat = 14

    @State private var isPressed = false

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.15)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.easeInOut(duration: 0.15)) {
                    isPressed = false
                }
            }
            action()
        }) {
            Text(title)
                .font(font)
                .foregroundColor(foregroundColor)
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                .frame(maxWidth: maxWidthIsInfinity ? .infinity : .none)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
                .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(.plain)
    }
}


#Preview {
    CustomButton(title: "send data", action: {})
}
