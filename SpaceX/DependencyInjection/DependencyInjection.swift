//
//  DependencyInjection.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/14/23.
//

import Foundation
import Swinject

@propertyWrapper
struct Inject<Component> {
    let wrappedValue: Component
    init() {
        self.wrappedValue = Resolver.shared.resolve(Component.self)
    }
}

class Resolver {
    static let shared = Resolver()
    private var container = DependencyInjection.makeContainer()
    
    func resolve<T>(_ type: T.Type) -> T {
        return container.resolve(type)!
    }
    
    func setDependencyContainer(_ container: Container) {
        self.container = container
    }
}

class DependencyInjection{
    static func makeContainer() -> Container {
        
        let container = Container()
        
        //MARK: - Network
        container.register(NetworkServiceProtocol.self) { _ in
            NetworkService()
        }.inObjectScope(.container)
        
        // MARK: - Realm
        container.register(DataBaseProviderProtocol.self) { _ in
            DataBaseProvider()
        }.inObjectScope(.container)
        
        container.register(DataBaseManagerProtocol.self) { _ in
            DataBaseManager()
        }.inObjectScope(.container)
        
        //MARK: - Date Formater
        container.register(DateFormatterProtocol.self) { _ in
            DateUtility()
        }.inObjectScope(.container)
        
        return container
    }
}
