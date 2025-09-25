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
    @Published var selecteedItem: PhotosPickerItem?
    
    @Published var currentTextInd: Int = 0
    
    func cancelImagediting() {
        withAnimation {
            imageData = Data(count: 0)
            canvas = PKCanvasView()
            toolPicker = PKToolPicker()
            canDraw = false
        }
    }
    
    func cancelTextAdding() {
        textBoxes.removeLast()
        currentTextInd -= 1
        withAnimation {
            addNewTextBox = false
            canDraw = true
        }
    }
    
    func startTextAdding() {
        textBoxes.append(TextBoxModel())
        currentTextInd = textBoxes.count - 1
        withAnimation {
            addNewTextBox = true
            canDraw = false
        }
    }
    
    
    func onSetImage() {
        canDraw = true
    }
    
    
    
    func mergeCanvasDrawingWithImageData(
        imageData: Data,
        canvasView: PKCanvasView,
        exportAsJPEG: Bool = false,
        compressionQuality: CGFloat = 0.9
    ) -> Data? {
        
        // Step 1: Convert Data to UIImage
        guard let backgroundImage = UIImage(data: imageData) else {
            print("Failed to convert imageData to UIImage")
            return nil
        }

        let imageSize = backgroundImage.size

        // Step 2: Create graphics renderer
        let renderer = UIGraphicsImageRenderer(size: imageSize)

        let mergedImage = renderer.image { context in
            // Draw background image
            backgroundImage.draw(in: CGRect(origin: .zero, size: imageSize))

            // Draw the PKDrawing scaled to match the image size
            let drawingImage = canvasView.drawing.image(from: CGRect(origin: .zero, size: canvasView.bounds.size), scale: 1.0)
            
            // Scale drawing to fit background image size
            drawingImage.draw(in: CGRect(origin: .zero, size: imageSize))
        }

        // Step 3: Convert to Data (JPEG or PNG)
        if exportAsJPEG {
            return mergedImage.jpegData(compressionQuality: compressionQuality)
        } else {
            return mergedImage.pngData()
        }
    }
    
    func saveAnImage() {
        isSaving = true
        if let imageData = mergeCanvasDrawingWithImageData(imageData: imageData, canvasView: canvas) {
            CustomImageManager.saveImageToPhotoLibrary(image: UIImage(data: imageData)) {
                DispatchQueue.main.async {
                    self.isSaving = false
                }
            }
        }
    }
}
