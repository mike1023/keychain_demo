//
//  ViewController.swift
//  keychain_demo
//
//  Created by Harris on 2021/11/24.
//

import UIKit

class ViewController: UIViewController {

    var username: String = "abc@123.com"
    var pwd: String = "007007"
    var server: String = "com.apple.www"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unhandledError(status: OSStatus)
    }
    
    // add
    @IBAction func addKeychain(_ sender: Any) {
        let password = pwd.data(using: String.Encoding.utf8)!
        print("password: \(password)")
        let query:[String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                   kSecAttrAccount as String: username,
                                   kSecAttrServer as String: server,
                                   kSecAttrSynchronizable as String: kCFBooleanTrue!,
                                   kSecValueData as String: password]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            print("error")
            return
        }
    }
    
    // search
    @IBAction func queryKeychain(_ sender: Any) {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: server,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true
                                    ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else {
            print("no pwd")
            return
        }
        guard status == errSecSuccess else {
            print("error")
            return
        }
        
        guard let res = item as? [String: Any],
              let pwdData = res[kSecValueData as String] as? Data,
              let password = String(data: pwdData, encoding: .utf8),
              let server = res[kSecAttrServer as String] as? String,
              let account = res[kSecAttrAccount as String] as? String
        else {
            print("error")
            return
        }
        
        print("pwdData: \(pwdData)")
        print("password: \(password)")
        print("server: \(server)")
        print("username: \(account)")
    }
    
    // update
    @IBAction func updateKeychain(_ sender: Any) {
        let query:[String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                   kSecAttrServer as String: server]
        pwd = "008008"
        let pwdData = pwd.data(using: .utf8)!
        let attr:[String: Any] = [kSecAttrAccount as String: username, kSecValueData as String: pwdData]
        let status = SecItemUpdate(query as CFDictionary, attr as CFDictionary)
        guard status != errSecItemNotFound else {
            print("not found")
            return
        }
        guard status == errSecSuccess else {
            print("error")
            return
        }
    }
    
    // delete
    @IBAction func deleteKeychain(_ sender: Any) {
        let query:[String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                   kSecAttrAccount as String: username]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            print("error")
            return
        }
    }
    
    
    
    
    
    
    
    
}
