//
//  LogInViewModel.swift
//  PhotoEditor
//
//  Created by Begench on 23.09.2025.
//

import Foundation
import FirebaseAuth

class RegisterViewModel: ObservableObject {
    @Published var user: User?
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confPassword: String = ""
    @Published var errorMessage: String = ""
    @Published var showErrors: Bool = false
    @Published var inProccess: Bool = false

    
    var canRequest: Bool {
        isValidPassword() || isValidEmail()
    }
    
    func isValidEmail() -> Bool {
        let emailRegex = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return predicate.evaluate(with: email)
    }
    
    var emailIsRed: Bool {
        !isValidEmail()
    }
    
    func isValidPassword() -> Bool {
        password.count >= 8
    }
    
    var passwordIsRed: Bool {
        !isValidPassword()
    }
    
    func isValidConfPassword() -> Bool {
        confPassword == password  && confPassword.count >= 8
    }
    var confPasswordIsRed: Bool {
        !isValidConfPassword()
    }
    
    func requestRegister(onSuccess: @escaping () -> ()) {
        inProccess = true
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error {
                self?.inProccess = false
                self?.errorMessage = error.localizedDescription
                return
            }
            self?.inProccess = false
            onSuccess()
        }
    }
}
