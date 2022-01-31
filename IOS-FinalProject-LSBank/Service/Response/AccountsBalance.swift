//
//  LSBankAPIStruct.swift
//  IOS-FinalProject-LSBank
//
//  Created by user203175 on 10/19/21.
//

import Foundation


struct AccountsBalance : Codable {
    
    var balance : Double = 0

    
    static func decode( json : [String:Any] ) -> AccountsBalance? {
        
        let decoder = JSONDecoder()
        do{
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let object = try decoder.decode(AccountsBalance.self, from: data)

            return object
        } catch {
        }
        return nil
    }
    
}


