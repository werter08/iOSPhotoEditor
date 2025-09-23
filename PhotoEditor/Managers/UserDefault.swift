//
//  UserDefault.swift
//  PhotoEditor
//
//  Created by Begench on 23.09.2025.
//

import Foundation



@propertyWrapper
public struct UserDefault<T> {
    let key: String
    let defaultValue: T
    private let storage: UserDefaults

    public init(_ key: String, defaultValue: T, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }

    public var wrappedValue: T {
        get {
            // Специальная обработка для разных типов
            switch T.self {
            case is String.Type:
                return (storage.string(forKey: key) as? T) ?? defaultValue
            case is Int.Type:
                return (storage.integer(forKey: key) as? T) ?? defaultValue
            case is Bool.Type:
                return (storage.bool(forKey: key) as? T) ?? defaultValue
            case is Double.Type:
                return (storage.double(forKey: key) as? T) ?? defaultValue
            case is Float.Type:
                return (storage.float(forKey: key) as? T) ?? defaultValue
            case is Data.Type:
                return (storage.data(forKey: key) as? T) ?? defaultValue
            case is [String].Type:
                return (storage.stringArray(forKey: key) as? T) ?? defaultValue
            default:
                // Для сложных типов через Codable
                if let data = storage.data(forKey: key),
                   let decodable = T.self as? Decodable.Type,
                   let decoded = try? JSONDecoder().decode(decodable, from: data) as? T {
                    return decoded
                }
                // Fallback для других типов
                return storage.object(forKey: key) as? T ?? defaultValue
            }
        }
        set {
            // Специальная обработка для разных типов
            switch newValue {
            case let stringValue as String:
                storage.set(stringValue, forKey: key)
            case let intValue as Int:
                storage.set(intValue, forKey: key)
            case let boolValue as Bool:
                storage.set(boolValue, forKey: key)
            case let doubleValue as Double:
                storage.set(doubleValue, forKey: key)
            case let floatValue as Float:
                storage.set(floatValue, forKey: key)
            case let dataValue as Data:
                storage.set(dataValue, forKey: key)
            case let arrayValue as [String]:
                storage.set(arrayValue, forKey: key)
            default:
                // Для сложных типов через Codable
                if let encodable = newValue as? Encodable,
                   let data = try? JSONEncoder().encode(encodable) {
                    storage.set(data, forKey: key)
                } else {
                    // Fallback для других типов
                    storage.set(newValue, forKey: key)
                }
            }
        }
    }
}
