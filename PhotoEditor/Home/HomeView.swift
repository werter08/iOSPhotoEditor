//
//  HomeView.swift
//  PhotoEditor
//
//  Created by Begench on 23.09.2025.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    
    
    var body: some View {
        Text("Home, World!")
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
