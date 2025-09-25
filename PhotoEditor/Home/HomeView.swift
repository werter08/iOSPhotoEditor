//
//  DrawingView.swift
//  PhotoEditor
//
//  Created by Begench on 24.09.2025.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .overlay(alignment: .topLeading) {
                logout.padding()
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

#Preview {
    HomeView()
}
