import Foundation
import SwiftUI

protocol Persistence {
    func save<T: Encodable>(_ object: T, forKey key: String)
    func load<T: Decodable>(forKey key: String) -> T?
}

class DefaultPersistence: Persistence {
    private let defaults = UserDefaults.standard
    
    func save<T: Encodable>(_ object: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(object)
            defaults.set(data, forKey: key)
            print("Saved data for key: \(key)")
        } catch {
            print("Failed to save object: \(error)")
        }
    }
    
    func load<T: Decodable>(forKey key: String) -> T? {
        guard let data = defaults.data(forKey: key) else {
            print("No data found for key: \(key)")
            return nil
        }
        do {
            let object = try JSONDecoder().decode(T.self, from: data)
            print("Loaded data for key: \(key)")
            return object
        } catch {
            print("Failed to load object: \(error)")
            return nil
        }
    }
}

// MARK: - Environment Key
private struct PersistenceKey: EnvironmentKey {
    static let defaultValue: Persistence = DefaultPersistence()
}

extension EnvironmentValues {
    var persistence: Persistence {
        get { self[PersistenceKey.self] }
        set { self[PersistenceKey.self] = newValue }
    }
}
