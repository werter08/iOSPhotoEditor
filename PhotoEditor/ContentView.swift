//
//  ContentView.swift
//  PhotoEditor
//
//  Created by Begench on 23.09.2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject var coordinator = Coordinator()
    
    var body: some View {
        switch coordinator.flow {
        case .home:
            HomeView()
                .environmentObject(coordinator)
        case .login:
            LoginInView()
                .environmentObject(coordinator)
        }
        
    }
}
   
