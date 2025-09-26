//
//  TexesLayerView.swift
//  PhotoEditor
//
//  Created by Begench on 25.09.2025.
//

import SwiftUI

struct TextesLayerView: View {
    @EnvironmentObject var drawingViewModel: DrawingViewModel
    
    var body: some View {
        if (drawingViewModel.textBoxes.count == 1 && drawingViewModel.addNewTextBox) || drawingViewModel.textBoxes.count == 0 {
            EmptyView()
        } else {
            ForEach(drawingViewModel.textBoxes) { box in
                Text(drawingViewModel.textBoxes[drawingViewModel.currentTextInd].id == box.id
                     && drawingViewModel.addNewTextBox ? "" : box.text)
                .foregroundStyle(box.textColor)
                .offset(box.offset)
                .font(.system(size: box.fontSize, weight: box.isBold ? .bold : .regular))
                .gesture(
                    // Combine tap + drag
                    TapGesture()
                        .onEnded {
                            // Handle tap here
                            drawingViewModel.startTextAdding(isNewText: false, textInd: drawingViewModel.getInd(textBox: box))
                        }
                        .simultaneously(with:
                                            DragGesture()
                            .onChanged { value in
                                let index = drawingViewModel.getInd(textBox: box) ?? 0
                                
                                drawingViewModel.textBoxes[index].offset = CGSize(
                                    width: value.translation.width + drawingViewModel.textBoxes[index].lastOffset.width,
                                    height: value.translation.height + drawingViewModel.textBoxes[index].lastOffset.height
                                )
                            }
                            .onEnded { value in
                                let index = drawingViewModel.getInd(textBox: box) ?? 0
                                
                                drawingViewModel.textBoxes[index].lastOffset = drawingViewModel.textBoxes[index].offset
                            }
                                       )
                )
            }
        }
    }
}
