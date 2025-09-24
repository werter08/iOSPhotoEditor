//
//  LogInViewModel.swift
//  PhotoEditor
//
//  Created by Begench on 23.09.2025.
//

import Foundation
import FirebaseAuth

class LogInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showErrors: Bool = false
    @Published var inProccess: Bool = false
    @Published var errorMessage: String = ""
    
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
    
    func requestLogIn() {
        print("logIn")
        inProccess = true
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let user = result?.user else {
                self?.errorMessage = error?.localizedDescription ?? ""
                self?.inProccess = false
                return
            }
            UserDefaultsManager.userAuthorized = true
            UserDefaultsManager.userProfile = UserProfile(email: user.email ?? "", isVerifeid: user.isEmailVerified)
            self?.inProccess = false
        }
    }
}
