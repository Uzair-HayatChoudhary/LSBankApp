//
//  LSBankAPIStruct.swift
//  IOS-FinalProject-LSBank
//
//  Created by user203175 on 10/19/21.
//

import Foundation



struct AccountsInfo : Codable {
    
    var accountId : String = ""
    var firstName : String = ""
    var lastName : String = ""
    var email : String = ""
    var mobilePhone : String = ""

    
    static func decode( json : [String:Any] ) -> AccountsInfo? {
        
        let decoder = JSONDecoder()
        do{
            let data = try JSONSerialization.data(withJSONObject: json["account"], options: .prettyPrinted)
            let object = try decoder.decode(AccountsInfo.self, from: data)

            return object
        } catch {
        }
        return nil
    }
    
}


