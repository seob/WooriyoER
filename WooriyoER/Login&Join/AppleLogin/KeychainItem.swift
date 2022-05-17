//
//  KeychainItem.swift
//  PinPle
//
//  Created by seob on 2020/01/20.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import Foundation

struct KeychainItem {

    // MARK: Types
    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unexpectedItemData
        case unhandledError
    }

    // MARK: Properties
    let service: String
    let accessGroup: String?
    private(set) var account: String

    // MARK: Intialization
    init(service: String, account: String, accessGroup: String? = nil) {
        self.service = service
        self.account = account
        self.accessGroup = accessGroup
    }

    // MARK: Keychain access
    func readItem() throws -> String {
        // Build a query to find the item that matches the service, account and access group.
        var query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue

        // Try to fetch the existing keychain item that matches the query.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        // Check the return status and throw an error if appropriate.
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == noErr else { throw KeychainError.unhandledError }

        // Parse the password string from the query result.
        guard let existingItem = queryResult as? [String: AnyObject],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8)
            else {
                throw KeychainError.unexpectedPasswordData
        }

        return password
    }

    func saveItem(_ password: String) throws {
        // Encode the password into an Data object.
        let encodedPassword = password.data(using: String.Encoding.utf8)!

        do {
            // Check for an existing item in the keychain.
            try _ = readItem()

            // Update the existing item with the new password.
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedPassword as AnyObject?

            let query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)

            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError }
        } catch KeychainError.noPassword {
            //No password was found in the keychain. Create a dictionary to save as a new keychain item.
            var newItem = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            newItem[kSecValueData as String] = encodedPassword as AnyObject?

            // Add a the new item to the keychain.
            let status = SecItemAdd(newItem as CFDictionary, nil)

            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError }
        }
    }

    func deleteItem() throws {
        // Delete the existing item from the keychain.
        let query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        let status = SecItemDelete(query as CFDictionary)

        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError }
    }

    // MARK: Convenience
    private static func keychainQuery(withService service: String, account: String? = nil, accessGroup: String? = nil) -> [String: AnyObject] {
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?

        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }

        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }

        return query
    }
}

//Mark - Demo App Helper
extension KeychainItem {
    static var bundleIdentifier: String {
        return Bundle.main.bundleIdentifier ?? "com.wooriyo.WooriyoER"
    }

    //Get and Set Current User Identifier. Set nil to delete.
    static var currentUserIdentifier: String? {
        get {
            return try? KeychainItem(service: bundleIdentifier, account: "userIdentifier").readItem()
        }
        set {
            guard let value = newValue else {
                try? KeychainItem(service: bundleIdentifier, account: "userIdentifier").deleteItem()
                return
            }
            do {
                try KeychainItem(service: bundleIdentifier, account: "userIdentifier").saveItem(value)
            } catch {
                print("Unable to save userIdentifier to keychain.")
            }
        }
    }
    
    //기존 형식 : 001746.1e3ae9cee13644c897b7344d9bb5adea.0043
    static var fidcurrentUserIdentifier: String? {
        get {
            return try? KeychainItem(service: bundleIdentifier, account: "fiduserIdentifier").readItem()
        }
        set {
            guard let value = newValue else {
                try? KeychainItem(service: bundleIdentifier, account: "fiduserIdentifier").deleteItem()
                return
            }
            do {
                try KeychainItem(service: bundleIdentifier, account: "fiduserIdentifier").saveItem(value)
            } catch {
                print("Unable to save userIdentifier to keychain.")
            }
        }
    }
    

    //Get and Set Current User First Name. Set nil to delete.
    static var currentUserFirstName: String? {
        get {
            return try? KeychainItem(service: bundleIdentifier, account: "userFirstName").readItem()
        }
        set {
            guard let value = newValue else {
                try? KeychainItem(service: bundleIdentifier, account: "userFirstName").deleteItem()
                return
            }
            do {
                try KeychainItem(service: bundleIdentifier, account: "userFirstName").saveItem(value)
            } catch {
                print("Unable to save userFirstName to keychain.")
            }
        }
    }

    //Get and Set Current User Last Name. Set nil to delete.
    static var currentUserLastName: String? {
        get {
            return try? KeychainItem(service: bundleIdentifier, account: "userLastName").readItem()
        }
        set {
            guard let value = newValue else {
                try? KeychainItem(service: bundleIdentifier, account: "userLastName").deleteItem()
                return
            }
            do {
                try KeychainItem(service: bundleIdentifier, account: "userLastName").saveItem(value)
            } catch {
                print("Unable to save userLastName to keychain.")
            }
        }
    }


    //Get and Set Current User Email. Set nil to delete.
    static var currentUserEmail: String? {
        get {
            return try? KeychainItem(service: bundleIdentifier, account: "userEmail").readItem()
        }
        set {
            guard let value = newValue else {
                try? KeychainItem(service: bundleIdentifier, account: "userEmail").deleteItem()
                return
            }
            do {
                try KeychainItem(service: bundleIdentifier, account: "userEmail").saveItem(value)
            } catch {
                print("Unable to save userEmail to keychain.")
            }
        }
    }
    
    
    

}
//
//struct KeychainItem {
//    // MARK: Types
//
//    enum KeychainError: Error {
//        case noPassword
//        case unexpectedPasswordData
//        case unexpectedItemData
//        case unhandledError
//    }
//
//    // MARK: Properties
//
//    let service: String
//
//    private(set) var account: String
//
//    let accessGroup: String?
//
//    // MARK: Intialization
//
//    init(service: String, account: String, accessGroup: String? = nil) {
//        self.service = service
//        self.account = account
//        self.accessGroup = accessGroup
//    }
//
//    // MARK: Keychain access
//
//    func readItem() throws -> String {
//        /*
//         Build a query to find the item that matches the service, account and
//         access group.
//         */
//        var query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
//        query[kSecMatchLimit as String] = kSecMatchLimitOne
//        query[kSecReturnAttributes as String] = kCFBooleanTrue
//        query[kSecReturnData as String] = kCFBooleanTrue
//
//        // Try to fetch the existing keychain item that matches the query.
//        var queryResult: AnyObject?
//        let status = withUnsafeMutablePointer(to: &queryResult) {
//            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
//        }
//
//        // Check the return status and throw an error if appropriate.
//        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
//        guard status == noErr else { throw KeychainError.unhandledError }
//
//        // Parse the password string from the query result.
//        guard let existingItem = queryResult as? [String: AnyObject],
//            let passwordData = existingItem[kSecValueData as String] as? Data,
//            let password = String(data: passwordData, encoding: String.Encoding.utf8)
//            else {
//                throw KeychainError.unexpectedPasswordData
//        }
//
//        return password
//    }
//
//    func saveItem(_ password: String) throws {
//        // Encode the password into an Data object.
//        let encodedPassword = password.data(using: String.Encoding.utf8)!
//
//        do {
//            // Check for an existing item in the keychain.
//            try _ = readItem()
//
//            // Update the existing item with the new password.
//            var attributesToUpdate = [String: AnyObject]()
//            attributesToUpdate[kSecValueData as String] = encodedPassword as AnyObject?
//
//            let query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
//            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
//
//            // Throw an error if an unexpected status was returned.
//            guard status == noErr else { throw KeychainError.unhandledError }
//        } catch KeychainError.noPassword {
//            /*
//             No password was found in the keychain. Create a dictionary to save
//             as a new keychain item.
//             */
//            var newItem = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
//            newItem[kSecValueData as String] = encodedPassword as AnyObject?
//
//            // Add a the new item to the keychain.
//            let status = SecItemAdd(newItem as CFDictionary, nil)
//
//            // Throw an error if an unexpected status was returned.
//            guard status == noErr else { throw KeychainError.unhandledError }
//        }
//    }
//
//    func deleteItem() throws {
//        // Delete the existing item from the keychain.
//        let query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
//        let status = SecItemDelete(query as CFDictionary)
//
//        // Throw an error if an unexpected status was returned.
//        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError }
//    }
//
//    // MARK: Convenience
//
//    private static func keychainQuery(withService service: String, account: String? = nil, accessGroup: String? = nil) -> [String: AnyObject] {
//        var query = [String: AnyObject]()
//        query[kSecClass as String] = kSecClassGenericPassword
//        query[kSecAttrService as String] = service as AnyObject?
//
//        if let account = account {
//            query[kSecAttrAccount as String] = account as AnyObject?
//        }
//
//        if let accessGroup = accessGroup {
//            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
//        }
//
//        return query
//    }
//
//    /*
//     For the purpose of this demo app, the user identifier will be stored in the device keychain.
//     You should store the user identifier in your account management system.
//     */
//    static var currentUserIdentifier: String {
//        do {
//            let storedIdentifier = try KeychainItem(service: "com.wooriyo.pinplm", account: "userIdentifier").readItem()
//            return storedIdentifier
//        } catch {
//            return ""
//        }
//    }
//
//    static func deleteUserIdentifierFromKeychain() {
//        do {
//            try KeychainItem(service: "com.wooriyo.pinplm", account: "userIdentifier").deleteItem()
//        } catch {
//            print("Unable to delete userIdentifier from keychain")
//        }
//    }
//}
