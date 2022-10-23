//
//  StorageService.swift
//  nasa
//
//  Created by Danil Demchenko on 20.10.2022.
//

import Foundation

protocol StorageServiceProtocol {
    func store<T: Encodable>(object: T, with key: String)
    func getStoredObject<T: Codable>(with key: String) -> T?
}

final class StorageService: StorageServiceProtocol {
    func store<T: Encodable>(object: T, with key: String) {
        if let encodedObject = try? JSONEncoder().encode(object) {
            UserDefaults.standard.set(encodedObject, forKey: key)
        }
    }
    
    func getStoredObject<T: Codable>(with key: String) -> T? {
        if let savedManifest = UserDefaults.standard.object(forKey: key) as? Data {
            if let loadedObject = try? JSONDecoder().decode(T.self, from: savedManifest) {
                return loadedObject
            }
        }
        return nil
    }
}
