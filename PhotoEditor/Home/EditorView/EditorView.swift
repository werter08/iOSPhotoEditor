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
                        
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .overlay {
                                GeometryReader { proxy in
                                    let size = proxy.size
                                    CanvasView(
                                        canvas: $drawingViewModel.canvas,
                                        canDraw: $drawingViewModel.canDraw,
                                        toolPicker: $drawingViewModel.toolPicker,
                                        rect: size
                                    )
                                    .clipped()
                                    .id(refreshID)
                                    
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
            .overlay(alignment: .center) {
                if drawingViewModel.imageData != Data(count: 0) {
                    if drawingViewModel.imageData != Data(count: 0) {
                        CustomButton(title: "Add text", systemIcon: "plus", showProggresView: .constant(false)) {
                            drawingViewModel.startTextAdding()
                        }
                        .padding(.horizontal, 50)
                    }
                }
            }
            
            if drawingViewModel.addNewTextBox {
                EditTextView()
            }
        }
        
        .sheet(isPresented: $drawingViewModel.showCamera, content: {
//            CameraView(imageData: $drawingViewModel.imageData) {
//                drawingViewModel.onSetImage()
//            }
            if let uiImage = UIImage(data: drawingViewModel.imageData) {
                FullExportView(
                    uiImage:    uiImage,
                    canvasView: drawingViewModel.canvas,
                    textBoxes:  drawingViewModel.textBoxes,
                    canDraw:    drawingViewModel.canDraw,
                    toolPicker: drawingViewModel.toolPicker
                    )
                .frame(width: 1080/4, height: 1920/4)
            } else {
                EmptyView()
            }
            
        })
        .sheet(isPresented: $drawingViewModel.showPicker, content: {
            PickerView(imageData: $drawingViewModel.imageData) {
                drawingViewModel.onSetImage()
            }
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
                    drawingViewModel.saveAnImage()
                    drawingViewModel.showCamera = true
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
            CustomButton(title: "make a photo",systemIcon: "camera", showProggresView: .constant(false)) {
                drawingViewModel.showCamera = true
            }
             
            CustomButton(title: "select a photo",systemIcon: "photo", showProggresView: .constant(false)) {
                drawingViewModel.showPicker = true
            }
            
        }
     }
}

#Preview {
    EditerView()
}
