//
//  IntPickerView.swift
//  PhotoEditor
//
//  Created by Begench on 26.09.2025.
//

import SwiftUI

struct CustomFontPickerView: View {
    let fontSizes: [CGFloat] = Array(16...72).filter { $0 % 2 == 0 }.map { CGFloat($0) }

    @State private var selectedIndex: Int = 0
    @Binding var fontSize: CGFloat

    var body: some View {
        VStack(spacing: 16) {
            Text("Font Size: \(Int(fontSizes[selectedIndex]))")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)

            HStack(spacing: 32) {
                Button(action: {
                    if selectedIndex > 0 {
                        selectedIndex -= 1
                        fontSize = fontSizes[selectedIndex]
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                }
                .disabled(selectedIndex == 0)

                Button(action: {
                    if selectedIndex < fontSizes.count - 1 {
                        selectedIndex += 1
                        fontSize = fontSizes[selectedIndex]
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                }
                .disabled(selectedIndex == fontSizes.count - 1)
            }
        }
        .padding()
        .cornerRadius(16)
        .onAppear {
            if let index = fontSizes.firstIndex(of: fontSize) {
                selectedIndex = index
            } else {
                fontSize = fontSizes[selectedIndex]
            }
        }
    }
}
