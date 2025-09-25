//
//  CameraView.swift
//  PhotoEditor
//
//  Created by Begench on 24.09.2025.
//

import SwiftUI
import UIKit
import Foundation

struct CameraView: UIViewControllerRepresentable {
    // for get access parents image
    @Binding var imageData: Data
    var onSet: (() -> ())?
    // dismiss the view when it done
    @Environment (\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        // create camera picker
        let picker = UIImagePickerController()
        
        // set the coordinator as delegate
        picker.delegate = context.coordinator
        
        // make the source camera
        picker.sourceType = .camera
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // no update needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView
        
        init(parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = (info[.originalImage] as? UIImage)?.pngData() {
                parent.imageData = image
                parent.onSet?()
                parent.presentationMode.wrappedValue.dismiss()
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
