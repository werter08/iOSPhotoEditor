//
//  HomeView.swift
//  PhotoEditor
//
//  Created by Begench on 23.09.2025.
//

import SwiftUI
import FirebaseAuth
import PhotosUI

struct HomeView: View {
    @State var showCamera = false
    @State var selectedImage: UIImage?
    @State var selecteedItem: PhotosPickerItem?
    
    
    var body: some View {
        VStack {
            
            imageView
            
            HStack {
                Button {
                    showCamera = true
                } label: {
                    Text("take a photo")
                }
                
                PhotosPicker(selection: $selecteedItem, matching: .images) {
                    Text("Select photo")
                }
            }
            
            if let selectedImage {
                Button {
                    CustomImageManager.saveImageToPhotoLibrary(image: selectedImage)
                } label: {
                    Text("save photo")
                }
            }
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .topLeading) {
            logout.padding()
        }
        .sheet(isPresented: $showCamera, content: {
            CameraView(image: $selectedImage)
        })
        .onChange(of: selecteedItem) {  newItem in
            if let newItem {
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self),
                        let image = UIImage(data: data) {
                        selectedImage = image
                    }
                }
            }
        }
    }
    
    
    
    var logout: some View {
        Button {
            do {
                try Auth.auth().signOut()
                UserDefaultsManager.userAuthorized = false
                UserDefaultsManager.resetToDefaults()
            } catch {
                print("erroe with sign out")
            }
        } label: {
            Text("log out")
        }
    }
    
    @ViewBuilder
    var imageView: some View {
        if let selectedImage {
            Image(uiImage: selectedImage)
                .resizable()
                .scaledToFit()
                .frame(height: 400)
        } else {
            Text("noImage")
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    HomeView()
}
