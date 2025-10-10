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
        if drawingViewModel.textBoxes.count > 0 {
            
            ZStack {
                Color.black.opacity(0.75)
                    .ignoresSafeArea()
                HStack {
                    TextField("Type here", text: $drawingViewModel.textBoxes[drawingViewModel.textInd ?? drawingViewModel.currentTextInd].text)
                        .font(.system(size: drawingViewModel.textBoxes[drawingViewModel.textInd ?? drawingViewModel.currentTextInd].fontSize, weight: drawingViewModel.textBoxes[drawingViewModel.textInd ?? drawingViewModel.currentTextInd].isBold ? .bold : .regular))
                        .colorScheme(.dark)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(drawingViewModel.textBoxes[drawingViewModel.textInd ?? drawingViewModel.currentTextInd].textColor)
                        .onAppear {
                            print(drawingViewModel.textInd)
                            print(drawingViewModel.textInd ?? drawingViewModel.currentTextInd)
                            print(drawingViewModel.textBoxes.count)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                HStack {
                    
                    Button {
                        drawingViewModel.cancelTextAdding(isNewText: drawingViewModel.textInd == nil ? true : false)
                    } label: {
                        Text("Cancel")
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Button {
                        drawingViewModel.addingNewText()
                    } label: {
                        Text(drawingViewModel.textInd == nil ? "Add" : "Edit")
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                            .padding()
                    }
                    
                }.frame(maxHeight: .infinity, alignment: .top )
                
                    .overlay(alignment: .bottom) {
                        VStack(spacing: 12) {
                            CustomFontPickerView(
                                fontSize: $drawingViewModel.textBoxes[
                                    drawingViewModel.textInd ?? drawingViewModel.currentTextInd
                                ].fontSize
                            )
                            
                            ColorPicker("", selection: $drawingViewModel.textBoxes[
                                drawingViewModel.textInd ?? drawingViewModel.currentTextInd
                            ].textColor)
                            .labelsHidden()
                            .frame(width: 40, height: 40)
                            .padding(6)
                            .background(Color.white.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            Toggle("Bold", isOn: $drawingViewModel.textBoxes[
                                drawingViewModel.textInd ?? drawingViewModel.currentTextInd
                            ].isBold)
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                            .foregroundColor(.white)
                        }
                        .padding()
                        .cornerRadius(20)
                        .padding()
                    }
            }
        }
    }
}
