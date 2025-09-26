//
//  CustomImageManager.swift
//  PhotoEditor
//
//  Created by Begench on 24.09.2025.
//

import Foundation
import Photos
import UIKit
import SwiftUI
import PencilKit

class CustomImageManager {
    static func saveImageToPhotoLibrary(image: UIImage?, onSuccess: @escaping () -> ()) {
        guard let image else {
            print("cant get image from data")
            return
        }
        
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }) { success, error in
                    if success {
                        print("Image saved to library.")
                        onSuccess()
                    } else {
                        print("Error saving image: \(String(describing: error))")
                    }
                }
            } else {
                print("Permission denied to access photo library.")
            }
        }
    }
    
    static func renderViewToImage<V: View>(_ view: V, size: CGSize) -> UIImage? {
        let controller = UIHostingController(rootView: view)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
    
    
    static func mergeCanvasDrawingWithImageData(
        imageData: Data,
        canvasView: PKCanvasView,
        textBoxes: [TextBoxModel],
        exportAsJPEG: Bool = true,
        compressionQuality: CGFloat = 0.9
    ) -> Data? {
        
        guard let backgroundImage = UIImage(data: imageData) else {
            print("Failed to convert imageData to UIImage")
            return nil
        }
        
        let imageSize = backgroundImage.size
        let renderer = UIGraphicsImageRenderer(size: imageSize)

        // Calculate scale between canvas (SwiftUI size) and actual image
        let scaleX = imageSize.width / canvasView.bounds.width
        let scaleY = imageSize.height / canvasView.bounds.height
        
        let mergedImage = renderer.image { context in
            // 1. Draw background image
            backgroundImage.draw(in: CGRect(origin: .zero, size: imageSize))
            
            // 2. Draw PKCanvasView drawing
            let drawingImage = canvasView.drawing.image(
                from: CGRect(origin: .zero, size: canvasView.bounds.size),
                scale: 1.0
            )
            drawingImage.draw(in: CGRect(origin: .zero, size: imageSize))
            
            // 3. Draw text boxes with scaled offsets
            for box in textBoxes {
                let text = box.text as NSString
                
                let uiFont = UIFont.systemFont(
                    ofSize: box.fontSize,
                    weight: box.isBold ? .bold : .regular
                )
                
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: uiFont,
                    .foregroundColor: UIColor(box.textColor)
                ]
                
                let drawPoint = CGPoint(
                    x: box.offset.width * scaleX,
                    y: box.offset.height * scaleY
                )
                text.draw(at: drawPoint, withAttributes: attributes)
            }
        }
        
        // 4. Return image data
        return exportAsJPEG
            ? mergedImage.jpegData(compressionQuality: compressionQuality)
            : mergedImage.pngData()
    }
}
