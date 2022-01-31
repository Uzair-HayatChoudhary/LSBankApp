//
//  Account.swift
//  IOS-FinalProject-LSBank
//
//  Created by user203175 on 10/15/21.
//

import Foundation

class Account : Codable {
    
    public var id : String?
    public var firstName : String = ""
    public var lastName : String = ""
    public var email : String = ""
    public var mobilePhone : String = ""
    public var password : String = ""
    
    init(firstName: String = "", lastName: String = "", email: String = "", mobilePhone: String = "", password: String = "") {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.mobilePhone = mobilePhone
        self.password = password
    }
    

    
}
