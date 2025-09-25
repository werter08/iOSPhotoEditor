//
//  TextBoxView.swift
//  PhotoEditor
//
//  Created by Begench on 25.09.2025.
//

import SwiftUI

struct TextBoxModel: Identifiable {
    
    var id = UUID().uuidString
    var isBold = false
    var text = ""
    var offset: CGRect = .zero
    var lastOffset: CGRect = .zero
    var textColor: Color = .black
}
