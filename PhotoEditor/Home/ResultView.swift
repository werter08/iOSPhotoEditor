//
//  DrawingView.swift
//  PhotoEditor
//
//  Created by Begench on 24.09.2025.
//

import SwiftUI
import FirebaseAuth

struct ResultView: View {
    
    @EnvironmentObject var drawingViewModel: DrawingViewModel
    
    var body: some View {
        if let uiImage = UIImage(data: drawingViewModel.imageData) {
            VStack {
                HStack {
                    if drawingViewModel.message != "" {
                        Text(drawingViewModel.message)
                            .font(.headline)
                    }
                }.padding(.vertical, 50)
                
                HStack {
                    Spacer()
                    FullExportView(
                        uiImage:        uiImage,
                        canvasView:     drawingViewModel.canvas,
                        textBoxes:      drawingViewModel.textBoxes,
                        toolPicker:     drawingViewModel.toolPicker,
                        imageScale:     drawingViewModel.imageScale,
                        imageRotation:  drawingViewModel.imageRotation,
                        imageOffset:    drawingViewModel.imageOffset,
                        exportImageSize:drawingViewModel.size
                    )
//                    .frame(width: drawingViewModel.size.width/1.5, height: drawingViewModel.size.height/1.5)
                    .background(Rectangle().stroke(Color.black, lineWidth: 2))
                    Spacer()
                }
               
                
                Spacer()
                
                CustomButton(title: "Export as PNG", showProggresView: $drawingViewModel.isSaving) {
                    drawingViewModel.saveAnImage() { done in
                        if done {
                            drawingViewModel.message = "✅ Saved Successfully"
                        } else {
                            drawingViewModel.message = "🚫 Can't Save"
                        }
                    }
                }
                .padding(.horizontal, 20)
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
}
