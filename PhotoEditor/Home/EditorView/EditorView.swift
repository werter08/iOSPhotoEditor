//
//  HomeView.swift
//  PhotoEditor
//
//  Created by Begench on 23.09.2025.
//

import SwiftUI
import FirebaseAuth
import PhotosUI

struct EditerView: View {
    @State private var refreshID = UUID()
    @StateObject var drawingViewModel = DrawingViewModel()

    
    var body: some View {
        ZStack {
            Group {
                if drawingViewModel.imageData == Data(count: 0) {
                    emptyView
                } else {
                    if let uiImage = UIImage(data: drawingViewModel.imageData) {
                        
                        if drawingViewModel.size != .zero {
                            Color.green
                                .frame(width: drawingViewModel.size.width, height: drawingViewModel.size.height)
                        }
                        
                        EditableImageView(uiImage: uiImage)

                        if !drawingViewModel.resizeMode {
                            
                            if drawingViewModel.size != .zero  {
                                CanvasView(
                                    canvas: $drawingViewModel.canvas,
                                    toolPicker: $drawingViewModel.toolPicker
                                )
                                .frame(width: drawingViewModel.size.width, height: drawingViewModel.size.height)
                                .clipped()
                                .id(refreshID)
                            }
                            
                            if drawingViewModel.size != .zero {
                                TextesLayerView()
                            }
                            
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .overlay(alignment: .top) {
                topBarButtons
            }
            .overlay(alignment: .bottom) {
                
                if drawingViewModel.imageData != Data(count: 0) {
                    if drawingViewModel.imageData != Data(count: 0) {
                        
                        HStack {
                            CustomButton(title: "Add Text", systemIcon: "plus", showProggresView: .constant(false)) {
                                drawingViewModel.startTextAdding()
                            }
                            
                            if drawingViewModel.resizeMode {
                                CustomButton(title: "Paint Mode", systemIcon: "paintpalette.fill", showProggresView: .constant(false)) {
                                    drawingViewModel.openPaintMode()
                                }
                            } else {
                                CustomButton(title: "Resize Mode", systemIcon: "paintpalette.fill", showProggresView: .constant(false)) {
                                    drawingViewModel.openResizeMode()
                                    
                                }
                            }
                        }
                        
                        .padding(.vertical, drawingViewModel.resizeMode ? 10 : 90)
                        .padding(.horizontal, 20)
                        
                        
                    }
                }
            }
            
            if drawingViewModel.addNewTextBox {
                EditTextView()
            }
            
        }
    
        
        .sheet(isPresented: $drawingViewModel.showCamera, content: {
            CameraView(imageData: $drawingViewModel.imageData) {
                drawingViewModel.onSetImage()
            }
            
        })
        .sheet(isPresented: $drawingViewModel.showPicker, content: {
            PickerView(imageData: $drawingViewModel.imageData) {
                drawingViewModel.onSetImage()
            }
        })
        .sheet(isPresented: $drawingViewModel.showResultView, onDismiss: {
            drawingViewModel.closeResultView()
        }, content: {
            ResultView()
        })
        
        .environmentObject(drawingViewModel)
    }
    
    @ViewBuilder
    var topBarButtons: some View {
        HStack(spacing: 18) {
            if drawingViewModel.imageData != Data(count: 0) {
                Button {
                    drawingViewModel.cancelImagediting()
                    refreshID = UUID()
                } label: {
                    Image(systemName: "xmark")
                    
                }
            }
            Spacer()
            
            if drawingViewModel.imageData != Data(count: 0) {
                Button {
                    drawingViewModel.openResultView()
                } label: {
                    if drawingViewModel.isSaving {
                        ProgressView()
                            .tint(.blue)
                    } else {
                        Text("save photo")
                    }
                }
            }
        }.padding()
    }
    
   
    
    @ViewBuilder
    var emptyView: some View {
        VStack {
            Text("Edit your own photo")
                .padding(.vertical, 150)
                .font(.system(size: 48, weight: .bold))
                .multilineTextAlignment(.center)
            
            CustomButton(title: "make a photo",systemIcon: "camera", showProggresView: .constant(false)) {
                drawingViewModel.showCamera = true
            }
             
            CustomButton(title: "select a photo",systemIcon: "photo", showProggresView: .constant(false)) {
                drawingViewModel.showPicker = true
            }
            Spacer()
        }
     }
}

#Preview {
    EditerView()
}
