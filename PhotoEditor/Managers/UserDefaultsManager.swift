//
//  UserDefaultsManager.swift
//  PhotoEditor
//
//  Created by Begench on 23.09.2025.
//

import Foundation

struct UserDefaultsManager {

    struct UserDefaultsKeys {
        static var userAuthorizedKey = "user_authorized"
        static var userIDKey = "user_id_key"
        static let welcomeKey = "welcome_key"
        static let userProfileKey = "user_profile_key"
    }
    
    // MARK: - Basic Properties
    @UserDefault(UserDefaultsKeys.userAuthorizedKey, defaultValue: false)
    static var userAuthorized: Bool

    @UserDefault(UserDefaultsKeys.welcomeKey, defaultValue: true)
    static var openFirstWelcomePage: Bool
    
    
    // MARK: - Complex Type Example
    struct UserProfile: Codable {
        let email: String
        
        static let empty = UserProfile(email: "")
    }
    
    @UserDefault(UserDefaultsKeys.userProfileKey, defaultValue: UserProfile.empty)
    static var userProfile: UserProfile
    
    static func resetToDefaults() {
        let defaults = UserDefaults.standard
        let keys = [
            UserDefaultsKeys.userAuthorizedKey,
            UserDefaultsKeys.userIDKey,
            UserDefaultsKeys.welcomeKey,
            UserDefaultsKeys.userProfileKey
        ]
        
        keys.forEach { defaults.removeObject(forKey: $0) }
        print("🔄 UserDefaults reset to defaults")
    }
}
