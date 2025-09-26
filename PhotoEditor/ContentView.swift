//
//  ContentView.swift
//  PhotoEditor
//
//  Created by Begench on 23.09.2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @AppStorage("user_authorized") var isAuthorized: Bool = false
    
    var body: some View {
        NavigationView {
            if isAuthorized {
                EditerView()
            } else {
                LoginView()
            }
        }
    }
}
   
