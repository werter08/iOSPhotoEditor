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
    
}
