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
            
            if drawingViewModel.addNewTextBox {
                Color.black.opacity(0.75)
                    .ignoresSafeArea()
                
                TextField("Type here", text: $drawingViewModel.textBoxes[drawingViewModel.currentTextInd].text)
                    .font(.system(size: 35))
                    .colorScheme(.dark)
                
                HStack {
                    Button {
                        
                    } label: {
                        Text("add")
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                            .padding()
                    }
                    Spacer()
                    Button {
                        drawingViewModel.cancelTextAdding()
                    } label: {
                        Text("cancel")
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                            .padding()
                    }
                }.frame(maxHeight: .infinity, alignment: .top )
            }
        }
        
        .sheet(isPresented: $drawingViewModel.showCamera, content: {
            CameraView(imageData: $drawingViewModel.imageData) {
                drawingViewModel.onSetImage()
            }
        })
        .onChange(of: drawingViewModel.selecteedItem) { newItem in
            if let newItem {
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self) {
                        drawingViewModel.imageData = data
                        drawingViewModel.onSetImage()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    var topBarButtons: some View {
        HStack(spacing: 18) {
            
            Button {
                drawingViewModel.cancelImagediting()
                refreshID = UUID()
            } label: {
                Image(systemName: "xmark")
                    
            }
            
            Spacer()
            
            if drawingViewModel.imageData != Data(count: 0) {
                Button {
                    drawingViewModel.saveAnImage()
                } label: {
                    if drawingViewModel.isSaving {
                        ProgressView()
                            .tint(.blue)
                    } else {
                        Text("save photo")
                    }
                }
                
                Button {
                    drawingViewModel.startTextAdding()
                } label: {
                    Image(systemName: "plus")
                }
            } else {
                
                Button {
                    drawingViewModel.showCamera = true
                } label: {
                    Image(systemName: "camera")
                }
                
                PhotosPicker(selection: $drawingViewModel.selecteedItem, matching: .images) {
                    Image(systemName: "photo")
                }
            }
        }.padding()
    }
    
   
    
    @ViewBuilder
    var emptyView: some View {
        Text("No image yet")
            .frame(maxWidth: .infinity)
            .foregroundStyle(.black)
            .frame(height: 400)
            .background(Color.gray.opacity(0.5))
            .cornerRadius(12)
     }
 
   
}

#Preview {
    EditerView()
}
