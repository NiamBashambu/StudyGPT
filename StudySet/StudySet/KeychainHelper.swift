//
//  KeychainHelper.swift
//  StudySet
//
//  Created by Niam Bashambu on 10/3/24.
//

import Foundation
import Security

class KeychainHelper {
    class func saveUserId(_ userId: String) {
        let data = userId.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "userId",
            kSecValueData as String: data
        ]

        // Delete any existing items
        SecItemDelete(query as CFDictionary)

        // Add new item
        SecItemAdd(query as CFDictionary, nil)
    }

    class func loadUserId() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "userId",
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == errSecSuccess {
            if let data = item as? Data {
                return String(data: data, encoding: .utf8)
            }
        }
        return nil
    }

    class func deleteUserId() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "userId"
        ]

        SecItemDelete(query as CFDictionary)
    }
}
