//
//  LSBankAPIStruct.swift
//  IOS-FinalProject-LSBank
//
//  Created by user203175 on 10/19/21.
//

import Foundation


struct AccountsCreate : Codable {
    
    var accountId : String = ""

    
    static func decode( json : [String:Any] ) -> AccountsCreate? {
        
        let decoder = JSONDecoder()
        do{
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let object = try decoder.decode(AccountsCreate.self, from: data)

            return object
        } catch {
        }
        return nil
    }
    
}


