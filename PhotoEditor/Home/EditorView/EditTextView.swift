//
//  EditTextView.swift
//  PhotoEditor
//
//  Created by Begench on 25.09.2025.
//

import SwiftUI

struct EditTextView: View {
    
    @EnvironmentObject var drawingViewModel: DrawingViewModel
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.75)
                .ignoresSafeArea()
            
            TextField("Type here", text: $drawingViewModel.textBoxes[drawingViewModel.textInd ?? drawingViewModel.currentTextInd].text)
                .font(.system(size: 35))
                .colorScheme(.dark)
                .foregroundStyle(drawingViewModel.textBoxes[drawingViewModel.textInd ?? drawingViewModel.currentTextInd].textColor)
                .frame(maxWidth: .infinity, alignment: .center)
            
            HStack {
                
                Button {
                    drawingViewModel.cancelTextAdding(isNewText: drawingViewModel.textInd == nil ? true : false)
                } label: {
                    Text("cancel")
                        .fontWeight(.heavy)
                        .foregroundStyle(.white)
                        .padding()
                }
                
                Spacer()
                
                Button {
                    drawingViewModel.addingNewText()
                } label: {
                    Text(drawingViewModel.textInd == nil ? "add" : "edit")
                        .fontWeight(.heavy)
                        .foregroundStyle(.white)
                        .padding()
                }
                
            }.frame(maxHeight: .infinity, alignment: .top )
            
                .overlay(alignment: .top) {
                    ColorPicker("", selection: $drawingViewModel.textBoxes[drawingViewModel.textInd ?? drawingViewModel.currentTextInd].textColor)
                        .labelsHidden()
                }
        }
    }
}

#Preview {
    EditTextView()
}
