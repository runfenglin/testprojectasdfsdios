//
//  KeyChainUtil.swift
//  TURides
//
//  Created by Dennis Hui on 13/04/15.
//
//

import UIKit
import Security

public class KeyChainUtil {
    struct TegKeychainConstants {
        static var klass: String { return toString(kSecClass) }
        static var classGenericPassword: String { return toString(kSecClassGenericPassword) }
        static var attrAccount: String { return toString(kSecAttrAccount) }
        static var valueData: String { return toString(kSecValueData) }
        static var returnData: String { return toString(kSecReturnData) }
        static var matchLimit: String { return toString(kSecMatchLimit) }
        
        private static func toString(value: CFStringRef) -> String {
            return (value as? String) ?? ""
        }
    }
    
    
    public class func set(key: String, value: String) -> Bool {
        if let currentData = value.dataUsingEncoding(NSUTF8StringEncoding) {
            return set(key, value: currentData)
        }
        
        return false
    }
    
    public class func set(key: String, value: NSData) -> Bool {
        let query = [
            TegKeychainConstants.klass       : TegKeychainConstants.classGenericPassword,
            TegKeychainConstants.attrAccount : key,
            TegKeychainConstants.valueData   : value ]
        
        SecItemDelete(query as CFDictionaryRef)
        
        let status: OSStatus = SecItemAdd(query as CFDictionaryRef, nil)
        
        return status == noErr
    }
    
    public class func get(key: String) -> String? {
        if let currentData = getData(key) {
            if let currentString = NSString(data: currentData,
                encoding: NSUTF8StringEncoding) as? String {
                    
                    return currentString
            }
        }
        
        return nil
    }
    
    public class func getData(key: String) -> NSData? {
        let query = [
            TegKeychainConstants.klass       : kSecClassGenericPassword,
            TegKeychainConstants.attrAccount : key,
            TegKeychainConstants.returnData  : kCFBooleanTrue,
            TegKeychainConstants.matchLimit  : kSecMatchLimitOne ]
        
        var result: AnyObject?
        
        let status = withUnsafeMutablePointer(&result) {
            SecItemCopyMatching(query, UnsafeMutablePointer($0))
        }
        
        if status == noErr { return result as? NSData }
        
        return nil
    }
    
    public class func delete(key: String) -> Bool {
        let query = [
            TegKeychainConstants.klass       : kSecClassGenericPassword,
            TegKeychainConstants.attrAccount : key ]
        
        let status: OSStatus = SecItemDelete(query as CFDictionaryRef)
        
        return status == noErr
    }
    
    public class func clear() -> Bool {
        let query = [ kSecClass as String : kSecClassGenericPassword ]
        
        let status: OSStatus = SecItemDelete(query as CFDictionaryRef)
        
        return status == noErr
    }
}
