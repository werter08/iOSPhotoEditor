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
    @Published var showResultView = false
    @Published var showCamera = false
    @Published var isSaving = false
    @Published var addNewTextBox = false
    @Published var resizeMode = true
     
    @Published var size: CGSize = .zero
    @Published var message = ""
    
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
            showResultView = false
            imageData = Data(count: 0)
            canvas = PKCanvasView()
            toolPicker = PKToolPicker()
            textBoxes = []
            size = .zero
            imageScale = 1.0
            imageRotation = .zero
            imageOffset = .zero
        }
    }
    
    func cancelTextAdding(isNewText: Bool = true) {
        addNewTextBox = false

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
        }
        
        openToolPeeker()
    }
    
    func openResizeMode() {
        resizeMode = true
        closeToolPeeker()
        canvas.drawingPolicy = .pencilOnly
    }
    
    func openResultView() {
        resizeMode = false
        showResultView = true
        closeToolPeeker()
        canvas.drawingPolicy = .pencilOnly
    }
    
    func closeResultView() {
        resizeMode = true
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
        }
        
        closeToolPeeker()
    }
    
    
    func onSetImage() {
        openToolPeeker()
    }
    
    
    func saveAnImage(isSuccess: @escaping (Bool) -> ()) {
        isSaving = true
        isSuccess(exportEverythingToImage())
        closeToolPeeker()
    }
    
    func getInd(textBox: TextBoxModel) -> Int? {
        textBoxes.firstIndex { textBox.id == $0.id }
    }
    

    private func exportEverythingToImage() -> Bool {
        guard let uiImage = UIImage(data: imageData) else {
            print("cant get an image")
            return false
        }

        let exportView = FullExportView(
            uiImage:        uiImage,
            canvasView:     canvas,
            textBoxes:      textBoxes,
            toolPicker:     toolPicker,
            imageScale:     imageScale,
            imageRotation:  imageRotation,
            imageOffset:    imageOffset,
            exportImageSize:size
        )

        let size = CGSize(width: size.width, height: size.height) 
        if let finalImage = CustomImageManager.renderViewToImage(exportView, size: size) {
            UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil)
            isSaving = false
//            cancelImagediting()
            return true
        } else {
            isSaving = false
//            cancelImagediting()
            return false
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
        withAnimation {
            toolPicker.setVisible(false, forFirstResponder: canvas)
            toolPicker.removeObserver(canvas)
        }
        DispatchQueue.main.async {
            self.canvas.resignFirstResponder()
        }
    }
}
