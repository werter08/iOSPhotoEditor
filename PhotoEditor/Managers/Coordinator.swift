//
//  Coordinator.swift
//  PhotoEditor
//
//  Created by Begench on 23.09.2025.
//

import Foundation


enum Views {
    case login
    case home
}


class Coordinator: ObservableObject {
    @Published var flow: Views = UserDefaultsManager.userAuthorized ? .home : .login
}
