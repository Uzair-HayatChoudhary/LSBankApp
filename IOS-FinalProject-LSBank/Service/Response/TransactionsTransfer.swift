//
//  LSBankAPIStruct.swift
//  IOS-FinalProject-LSBank
//
//  Created by user203175 on 10/19/21.
//

import Foundation


struct TransactionsTransfer : Codable {
    
    var transactionId : String = ""

    
    static func decode( json : [String:Any] ) -> TransactionsTransfer? {
        
        let decoder = JSONDecoder()
        do{
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let object = try decoder.decode(TransactionsTransfer.self, from: data)

            return object
        } catch {
        }
        return nil
    }
    
}


