//
//  LSBankAPIStruct.swift
//  IOS-FinalProject-LSBank
//
//  Created by user203175 on 10/19/21.
//

import Foundation


struct AccountsAll : Codable {
    
    var accounts : [AccountsInfo] = []

    
    static func decode( json : [String:Any] ) -> AccountsAll? {
        
        let decoder = JSONDecoder()
        do{
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let object = try decoder.decode(AccountsAll.self, from: data)

            return object
        } catch {
        }
        return nil
    }
    
}


