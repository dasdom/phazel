//  Created by dasdom on 26/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation

public protocol KeychainManagerProtocol {
    func set(token: String, for username: String) throws
    func token(for username: String) -> String?
    func deleteToken(for username: String)
}

struct KeychainManager: KeychainManagerProtocol {
    
//    private let service = "DDHDefaultService"
    private let service = "com.swiftandpainless.phazel"
    
    func set(token: String, for username: String) throws {
        guard let tokenData: Data = token.data(using: .utf8, allowLossyConversion: false) else { fatalError() }
        let objects: [Any] = [kSecClassGenericPassword, service, username, tokenData]
        let keys: [NSString] = [kSecClass, kSecAttrService, kSecAttrAccount, kSecValueData]
        
        let query = NSDictionary(objects: objects, forKeys: keys)
        SecItemDelete(query)
        
        let status = SecItemAdd(query, nil)
        if status != errSecSuccess {
            let errorCode = Int(status)
            let errorMessage = "Keychain error. Please contact @dasdom and tell him you experienced error \(errorCode)"
            throw NSError(domain: "DDHKeychainError", code: Int(status), userInfo: [NSLocalizedDescriptionKey: errorMessage])
        }
    }
    
    func token(for username: String) -> String? {
        let objects: [Any] = [kSecClassGenericPassword, service, username, true]
        let keys: [NSString] = [kSecClass, kSecAttrService, kSecAttrAccount, kSecReturnData]
        
        let query = NSDictionary(objects: objects, forKeys: keys)
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        if status == errSecItemNotFound {
            return nil
        }
        
        guard let retrievedData = dataTypeRef as? Data else { return nil }
        return String(data: retrievedData, encoding: .utf8)
    }
    
    func deleteToken(for username: String) {
        let objects: [Any] = [kSecClassGenericPassword, service, username]
        let keys: [NSString] = [kSecClass, kSecAttrService, kSecAttrAccount]
        
        let query = NSDictionary(objects: objects, forKeys: keys)
        
        SecItemDelete(query)
    }
}
