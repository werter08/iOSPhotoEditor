//
//  ExportView.swift
//  PhotoEditor
//
//  Created by Begench on 25.09.2025.
//

import SwiftUI
import PhotosUI
import PencilKit

struct FullExportView: View {
    var uiImage: UIImage
    var canvasView: PKCanvasView
    var textBoxes: [TextBoxModel]
    var canDraw: Bool
    var toolPicker: PKToolPicker
    
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            ZStack {
                Color(.clear) // Background

                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                
                CanvasView(
                    canvas: .constant(canvasView),
                    canDraw: .constant(canDraw),
                    toolPicker: .constant(toolPicker),
                    rect: size
                )

                ForEach(textBoxes) { box in
                    Text(box.text)
                        .font(.system(size: box.fontSize, weight: box.isBold ? .bold : .regular))
                        .foregroundStyle(box.textColor)
                        .offset(box.offset)
                        .fixedSize()
                }
            }
        }
    }
}
