//
//  CameraView.swift
//  PhotoEditor
//
//  Created by Begench on 24.09.2025.
//

import SwiftUI
import UIKit
import Foundation

struct PickerView: UIViewControllerRepresentable {
    // for get access parents image
    @Binding var imageData: Data
    var onSet: (() -> ())?
    // dismiss the view when it done
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        // create camera picker
        let picker = UIImagePickerController()
        
        // set the coordinator as delegate
        picker.delegate = context.coordinator
        
        // make the source camera
        picker.sourceType = .photoLibrary
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // no update needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: PickerView
        
        init(parent: PickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let imageData = (info[.originalImage] as? UIImage)?.pngData() {
                parent.imageData = imageData
                parent.presentationMode.wrappedValue.dismiss()
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
