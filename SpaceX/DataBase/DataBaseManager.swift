//
//  DataBaseManager.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/13/23.
//

import RealmSwift
import Foundation

typealias CodableObject = Object

protocol DataBaseManagerProtocol {
    func addObject(objects: [CodableObject]) throws
    func fetchAll<T: Object>(type: T.Type, offset: Int, limit: Int) throws -> [T]
//    func fetchAll<T: CodableObject>(type: T.Type) throws -> Results<T>?
    func getObject<T: CodableObject>(type: T.Type, key: Int) -> T?
    func deleteObject<T: CodableObject>(type: T.Type, by primaryKey: String)
    func removeAll<T: CodableObject>(type: T.Type) throws
    func updateObject<T: CodableObject>(object: T) throws
    func update(block: () -> Void) throws
}


final class DataBaseManager: DataBaseManagerProtocol {
    
    private lazy var realm: Realm = {
        do {
            let realm = try Realm()
            return realm
        } catch let error {
            fatalError("Failed to create Realm instance: \(error)")
        }
    }()
    
    // MARK: - add
    func addObject(objects: [CodableObject]) throws {
        do {
            try realm.write {
                realm.add(objects)
            }
        } catch let error as NSError {
            print("Error adding object in to realm: \(error.localizedDescription)")
        }
    }
    
    // MARK: - fetch
//    func fetchAll<T: CodableObject>(type: T.Type) throws -> Results<T>? {
//        return realm.objects(type)
//    }
    
    func fetchAll<T: Object>(type: T.Type, offset: Int, limit: Int) throws -> [T] {
        let results = realm.objects(type)
        let paginatedResults = Array(results.suffix(from: offset).prefix(limit))
        return paginatedResults
    }
    
    func getObject<T: CodableObject>(type: T.Type, key: Int) -> T? {
        return realm.object(ofType: type, forPrimaryKey: key)
    }
    
    // MARK: - delete
    func deleteObject<T: CodableObject>(type: T.Type, by primaryKey: String) {
        do {
            if let object = realm.object(ofType: T.self, forPrimaryKey: primaryKey) {
                try realm.write {
                    realm.delete(object)
                }
            }
        } catch let error as NSError {
            print("Error deleting object in from realm: \(error.localizedDescription)")
        }
    }
    
    func removeAll<T: CodableObject>(type: T.Type) throws {
        do {
            try realm.write {
                realm.delete(realm.objects(T.self))
            }
        } catch let error as NSError {
            print("Error opening Realm: \(error)")
        }
    }
    
    // MARK: - update
    func updateObject<T: CodableObject>(object: T) throws {
        do {
            try realm.write {
                realm.add(object, update: .modified)
            }
        } catch {
            return print("Failure")
        }
    }
    
    func update(block: () -> Void) throws {
        do {
            try realm.write {
                block()
            }
        } catch let error as NSError {
            print("Error updating object in realm: \(error.localizedDescription)")
        }
    }

}
