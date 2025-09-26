//
//  DrawingViewModel.swift
//  PhotoEditor
//
//  Created by Begench on 24.09.2025.
//

import Foundation
import SwiftUI
import PencilKit
import PhotosUI

class DrawingViewModel: ObservableObject {
    @Published var showPicker = false
    @Published var showCamera = false
    @Published var canDraw = false
    @Published var isSaving = false
    @Published var addNewTextBox = false
    @Published var resizeMode = true
     
    @Published var size: CGSize = .zero
    
    @Published var imageData = Data(count: 0)
    @Published var textBoxes: [TextBoxModel] = []
    
    
    @Published var canvas = PKCanvasView()
    @Published var toolPicker = PKToolPicker()
    
    @Published var currentTextInd: Int = 0
    @Published var textInd: Int? = nil
    
    @Published var imageScale: CGFloat = 1.0
    @Published var imageRotation: Angle = .zero
    @Published var imageOffset: CGSize = .zero
    
    func cancelImagediting() {
        withAnimation {
            resizeMode = true
            imageData = Data(count: 0)
            canvas = PKCanvasView()
            toolPicker = PKToolPicker()
            textBoxes = []
            canDraw = false
            size = .zero
            imageScale = 1.0
            imageRotation = .zero
            imageOffset = .zero
        }
    }
    
    func cancelTextAdding(isNewText: Bool = true) {
        addNewTextBox = false

        withAnimation {
            canDraw = true
        }

        if isNewText {
            textBoxes.removeLast()
            currentTextInd -= 1
        }
        
        openToolPeeker()
       
    }
    
    func addingNewText() {
        textInd = nil
        withAnimation {
            addNewTextBox = false
            canDraw = true
        }
        
        openToolPeeker()
    }
    
    func openResizeMode() {
        resizeMode = true
        closeToolPeeker()
        canvas.drawingPolicy = .pencilOnly
    }
    
    
    func openPaintMode() {
        resizeMode = false
        canvas.drawingPolicy = .anyInput
        openToolPeeker()
    }
    
    
    
    func startTextAdding(isNewText: Bool = true, textInd: Int? = nil) {
        if isNewText {
            textBoxes.append(TextBoxModel())
            currentTextInd = textBoxes.count - 1
        } else {
            self.textInd = textInd
        }
        withAnimation {
            addNewTextBox = true
            canDraw = false
        }
        
        closeToolPeeker()
    }
    
    
    func onSetImage() {
        canDraw = true
        openToolPeeker()
    }
    
    
    func saveAnImage() {
        isSaving = true
        exportEverythingToImage()
        closeToolPeeker()
    }
    
    func getInd(textBox: TextBoxModel) -> Int? {
        textBoxes.firstIndex { textBox.id == $0.id }
    }
    

    private func exportEverythingToImage() {
        guard let uiImage = UIImage(data: imageData) else {
            print("cant get an image")
            return
        }

        let exportView = FullExportView(
            uiImage: uiImage,
            canvasView: canvas,
            textBoxes: textBoxes,
            canDraw: canDraw,
            toolPicker: toolPicker,
            imageScale: imageScale,
            imageRotation: imageRotation,
            imageOffset: imageOffset
        )

        let size = CGSize(width: size.width, height: size.height) 
        if let finalImage = CustomImageManager.renderViewToImage(exportView, size: size) {
            UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil)
            isSaving = false
            cancelImagediting()
            print("✅ Exported successfully")
        } else {
            isSaving = false
            cancelImagediting()
            print("❌ Failed to render image")
        }
    }
    
    
    private func openToolPeeker() {
        toolPicker.setVisible(true, forFirstResponder: canvas)
        toolPicker.addObserver(canvas)
        
        DispatchQueue.main.async {
            if self.canvas.canBecomeFirstResponder {
                self.canvas.becomeFirstResponder()
            }
        }
    }
    
    
    private func closeToolPeeker() {
        toolPicker.setVisible(false, forFirstResponder: canvas)
        toolPicker.removeObserver(canvas)
        DispatchQueue.main.async {
            self.canvas.resignFirstResponder()
        }
    }
}
