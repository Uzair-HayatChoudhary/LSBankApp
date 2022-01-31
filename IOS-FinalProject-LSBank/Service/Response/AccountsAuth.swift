//
//  LSBankAPIStruct.swift
//  IOS-FinalProject-LSBank
//
//  Created by user203175 on 10/19/21.
//

import Foundation


struct AccountsAuth : Codable {
    
    var token : String = ""
    var expiration : Int = 0

    
    static func decode( json : [String:Any] ) -> AccountsAuth? {
        
        let decoder = JSONDecoder()
        do{
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let object = try decoder.decode(AccountsAuth.self, from: data)

            return object
        } catch {
        }
        return nil
    }
    
}


