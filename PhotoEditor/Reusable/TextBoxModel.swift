//
//  TextBoxView.swift
//  PhotoEditor
//
//  Created by Begench on 25.09.2025.
//

import SwiftUI


struct TextBoxModel: Identifiable {
    var id = UUID().uuidString
    var text: String = ""
    var fontSize: CGFloat = 32
    var isBold: Bool = false
    var offset: CGSize = .zero
    var lastOffset: CGSize = .zero
    var textColor: Color = .white
}
