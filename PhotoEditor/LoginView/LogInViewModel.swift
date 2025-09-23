//
//  LogInViewModel.swift
//  PhotoEditor
//
//  Created by Begench on 23.09.2025.
//

import Foundation


class LogInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    var canRequest: Bool {
        password.count >= 8 || isValidEmail(email)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return predicate.evaluate(with: email)
    }
}
