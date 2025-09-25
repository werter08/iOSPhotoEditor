//
//  CustomImageManager.swift
//  PhotoEditor
//
//  Created by Begench on 24.09.2025.
//

import Foundation
import Photos
import UIKit
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
}
