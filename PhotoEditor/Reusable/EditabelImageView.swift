//
//  EditabelImageView.swift
//  PhotoEditor
//
//  Created by Begench on 26.09.2025.
//

import SwiftUI

struct EditableImageView: View {
    let uiImage: UIImage

    @EnvironmentObject var drawingViewModel: DrawingViewModel

    // Temporary gesture state
    @GestureState private var gestureScale: CGFloat = 1.0
    @GestureState private var gestureRotation: Angle = .zero
    @GestureState private var gestureOffset: CGSize = .zero

    var body: some View {
        Image(uiImage: uiImage)
            .resizable()
            .scaledToFit()
            .scaleEffect(drawingViewModel.imageScale * gestureScale)
            .rotationEffect(drawingViewModel.imageRotation + gestureRotation)
            .offset(
                x: drawingViewModel.imageOffset.width + gestureOffset.width,
                y: drawingViewModel.imageOffset.height + gestureOffset.height
            )
            .gesture(drawingViewModel.resizeMode ? gesture : nil)
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            let proposedSize = proxy.size
                            let maxHeight = UIScreen.main.bounds.height / 1.75

                            if proposedSize.height > maxHeight {
                                let scale = maxHeight / proposedSize.height
                                drawingViewModel.size = CGSize(
                                    width: proposedSize.width * scale,
                                    height: proposedSize.height * scale
                                )
                            } else {
                                drawingViewModel.size = proposedSize
                            }
                        }
                }
            )
            .frame(
                width: drawingViewModel.size.width == 0 ? nil : drawingViewModel.size.width,
                height: drawingViewModel.size.height == 0 ? nil : drawingViewModel.size.height
            )

    }
    
    var gesture: some Gesture {
        SimultaneousGesture(
            SimultaneousGesture(
                MagnificationGesture()
                    .updating($gestureScale) { value, state, _ in
                        state = value
                    }
                    .onEnded { value in
                        drawingViewModel.imageScale *= value
                    },
                RotationGesture()
                    .updating($gestureRotation) { angle, state, _ in
                        state = angle
                    }
                    .onEnded { angle in
                        drawingViewModel.imageRotation += angle
                    }
            ),
            DragGesture()
                .updating($gestureOffset) { value, state, _ in
                    state = value.translation
                }
                .onEnded { value in
                    drawingViewModel.imageOffset.width += value.translation.width
                    drawingViewModel.imageOffset.height += value.translation.height
                }
        )
    }
}
