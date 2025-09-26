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
    var toolPicker: PKToolPicker
    let imageScale: CGFloat
    let imageRotation: Angle
    let imageOffset: CGSize
    let exportImageSize: CGSize
    
    var body: some View {
        ZStack {
            Color(.clear) // Background
                .frame(width: exportImageSize.width, height: exportImageSize.height)
                .overlay {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(imageScale)
                        .rotationEffect(imageRotation)
                        .offset(
                            x: imageOffset.width,
                            y: imageOffset.height
                        )
                    
                    CanvasView(
                        canvas: .constant(canvasView),
                        toolPicker: .constant(toolPicker)
                    )
                    
                    ForEach(textBoxes) { box in
                        Text(box.text)
                            .font(.system(size: box.fontSize, weight: box.isBold ? .bold : .regular))
                            .foregroundStyle(box.textColor)
                            .offset(box.offset)
                            .fixedSize()
                    }
                }
                .clipped()
        }
    }
}
