//
//  CanvasView.swift
//  PhotoEditor
//
//  Created by Begench on 24.09.2025.
//

import Foundation
import SwiftUI
import UIKit
import PencilKit

struct CanvasView: UIViewRepresentable {
    @Binding var canvas: PKCanvasView
    @Binding var canDraw: Bool
    @Binding var toolPicker: PKToolPicker

    var rect: CGSize
    
    
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.isOpaque = false
        
        canvas.drawingPolicy = .anyInput
        
        // Set the canvas size by constraining its frame
        canvas.backgroundColor = .clear
        
        // Set the tool picker
        
        toolPicker.setVisible(true, forFirstResponder: canvas)
        toolPicker.addObserver(canvas)
        canvas.becomeFirstResponder()
        
        
        return canvas
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // Update drawing policy
    }
}
