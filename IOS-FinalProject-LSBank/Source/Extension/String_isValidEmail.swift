//
//  String_isEmail.swift
//  IOS-FinalProject-LSBank
//
//  Created by user203175 on 11/9/21.
//

import Foundation

extension String {
    
    func isValidEmail() -> Bool {
        
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
            
            return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
            
        } catch {
            
        }
        return false
    }
}
