//
//  LSBankAPIStruct.swift
//  IOS-FinalProject-LSBank
//
//  Created by user203175 on 10/19/21.
//

import Foundation


struct TransactionStatement : Codable {
    
    var statement : [TransactionsStatementTransaction] = []

    static func decode( json : [String:Any] ) -> TransactionStatement? {
        
        let decoder = JSONDecoder()
        do{
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let object = try decoder.decode(TransactionStatement.self, from: data)

            return object
        } catch {
        }
        return nil
    }
    
}


struct TransactionsStatementTransaction : Codable {
    
    var type : String = ""
    var amount : Double = 0
    var dateTime : String = ""
    var fromAccount : AccountsInfo?
    var toAccount : AccountsInfo?
    var transactionId : String = ""
    var message : String = ""

    
    static func decode( json : [String:Any] ) -> TransactionsStatementTransaction? {
        
        let decoder = JSONDecoder()
        do{
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let object = try decoder.decode(TransactionsStatementTransaction.self, from: data)

            return object
        } catch {
        }
        return nil
    }
    
}


