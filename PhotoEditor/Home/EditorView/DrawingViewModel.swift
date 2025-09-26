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
     
    @Published var imageData = Data(count: 0)
    @Published var textBoxes: [TextBoxModel] = []
    
    
    @Published var canvas = PKCanvasView()
    @Published var toolPicker = PKToolPicker()
    
    @Published var currentTextInd: Int = 0
    @Published var textInd: Int? = nil
    
    func cancelImagediting() {
        withAnimation {
            imageData = Data(count: 0)
            canvas = PKCanvasView()
            toolPicker = PKToolPicker()
            canDraw = false
        }
    }
    
    func cancelTextAdding(isNewText: Bool = true) {
        withAnimation {
            addNewTextBox = false
            canDraw = true
        }
   
        if isNewText {
            textBoxes.removeLast()
            currentTextInd -= 1
        }
        
        toolPicker.setVisible(true, forFirstResponder: canvas)
        toolPicker.addObserver(canvas)
        textInd = nil
        
        DispatchQueue.main.async {
            if self.canvas.canBecomeFirstResponder {
                self.canvas.becomeFirstResponder()
            }
        }
       
    }
    
    func addingNewText() {
        textInd = nil
        withAnimation {
            addNewTextBox = false
            canDraw = true
        }
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
        
        toolPicker.setVisible(false, forFirstResponder: canvas)
        toolPicker.removeObserver(canvas)
        DispatchQueue.main.async {
            self.canvas.resignFirstResponder()
        }
    }
    
    
    func onSetImage() {
        canDraw = true
    }
    
    


    func saveAnImage() {
        isSaving = true
        exportEverythingToImage()
    }
    
    func exportEverythingToImage() {
        guard let uiImage = UIImage(data: imageData) else {
            return
            print("cant get an image")
        }

        let exportView = FullExportView(
            uiImage: uiImage,
            canvasView: canvas,
            textBoxes: textBoxes,
            canDraw: canDraw,
            toolPicker: toolPicker
        )

        let size = CGSize(width: 1080, height: 1920) // or any size you want
        if let finalImage = CustomImageManager.renderViewToImage(exportView, size: size) {
            UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil)
            isSaving = false
            print("✅ Exported successfully")
        } else {
            isSaving = false
            print("❌ Failed to render image")
        }
    }
    
    func getInd(textBox: TextBoxModel) -> Int? {
        textBoxes.firstIndex { textBox.id == $0.id }
    }
    
    func setData(imageData: Data = Data(count: 0), textBoxes: [TextBoxModel], canvas: PKCanvasView = PKCanvasView(), toolPicker: PKToolPicker = PKToolPicker()) {
        self.imageData = imageData
        self.textBoxes = textBoxes
        self.canvas = canvas
        self.toolPicker = toolPicker
    }
}
