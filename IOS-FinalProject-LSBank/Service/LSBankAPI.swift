//
//  lsbankApi.swift
//  IOS-FinalProject-LSBank
//
//  Created by user203175 on 10/15/21.
//

import Foundation
import UIKit

class LSBankAPI {
    
    static let baseURL = "https://lsbank-mvx6v.ondigitalocean.app/v1/"

    
    
    static func httpStatusCode( response : Any ) -> Int? {
        
        if let httpResponse = response as? HTTPURLResponse {
            return httpResponse.statusCode
        } else {
            return nil
        }
        
    }
    
    
    static func call( method : String = "POST", endpoint : String,
                      header : [String:String] = [:], payload : [String:Any],
        successHandler: @escaping (_ httpStatusCode : Int, _ response : [String : Any]) -> Void,
        failHandler : @escaping (_ httpStatusCode : Int, _ errorMessage: String) -> Void) {
        
        let Url = String(format: "\(baseURL)\(endpoint)")
        guard let serviceUrl = URL(string: Url) else { return }
        
        var httpStatusCode : Int = 0
        
        var request = URLRequest(url: serviceUrl)
        
        request.httpMethod = method.uppercased()
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        for (key, value) in header {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: payload, options: []) else {
            failHandler(httpStatusCode, "Unknow data received from server.")
            return
        }
        if payload.count > 0 {
            request.httpBody = httpBody
        }
        
        let session = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            if error == nil && data != nil {
                
                httpStatusCode = LSBankAPI.httpStatusCode( response : response ) ?? 0

                if let response = data {
                    do {
                        
                        if let jsonObject = try JSONSerialization.jsonObject(with: response, options : []) as? [String : Any]{
                            
                            print(jsonObject)
                            print("*** HTTP Response Code: \(httpStatusCode)")
                            
                            if !(200..<300).contains(httpStatusCode) {
                                if let errorMessage : String = jsonObject["error"] as! String? {
                                    failHandler(httpStatusCode, errorMessage)
                                } else {
                                    failHandler(httpStatusCode, "Something went wrong! (http code: \(httpStatusCode))")
                                }
                                return
                            }
                            
                            successHandler(httpStatusCode, jsonObject)
                            return
                            
                        }
                    } catch {
                        failHandler(httpStatusCode, "Something went wrong when decoding server response!")
                        return
                    }
                } else {
                    failHandler(httpStatusCode, "Unknow data received from the server!")
                    return
                }
                
            } else {
                print(error)
                let errorMsg = "Fetch failed: \(error?.localizedDescription ?? "Unknown error")"
                failHandler(httpStatusCode, errorMsg)
                return
            }
            
        }.resume()
        
    }
    


    
    static func newAccount( account : Account,
            successHandler: @escaping (_ httpStatusCode : Int, _ response : [String : Any]) -> Void,
            failHandler : @escaping (_ httpStatusCode : Int, _ errorMessage: String) -> Void) {

        let endpoint = "accounts/create"
        
        let payload = ["firstName" : account.firstName,
                       "lastName" : account.lastName,
                       "email" : account.email,
                       "mobilePhone": account.mobilePhone,
                       "password" : account.password]

        LSBankAPI.call(method: "POST", endpoint: endpoint, payload: payload, successHandler: successHandler, failHandler: failHandler)
        
    }
    

    
    
    static func signIn( email : String, password : String, 
            successHandler: @escaping (_ httpStatusCode : Int, _ response : [String : Any]) -> Void,
            failHandler : @escaping (_ httpStatusCode : Int, _ errorMessage: String) -> Void) {

        let endpoint = "accounts/auth"
        
        let payload = ["email" : email,
                       "password" : password]

        LSBankAPI.call(method: "POST", endpoint: endpoint, payload: payload, successHandler: successHandler, failHandler: failHandler)
        
    }
    
    
    
    static func accountInfo( token : String, email : String,
            successHandler: @escaping (_ httpStatusCode : Int, _ response : [String : Any]) -> Void,
            failHandler : @escaping (_ httpStatusCode : Int, _ errorMessage: String) -> Void) {

        let endpoint = "accounts/info/\(email)"
        
        let header = ["x-access-token" : token]

        let payload : [String:String] = [:]

        LSBankAPI.call(method: "GET", endpoint: endpoint, header: header, payload: payload, successHandler: successHandler, failHandler: failHandler)
        
    }
    
    
    static func accounts( token : String,
            successHandler: @escaping (_ httpStatusCode : Int, _ response : [String : Any]) -> Void,
            failHandler : @escaping (_ httpStatusCode : Int, _ errorMessage: String) -> Void) {

        let endpoint = "accounts/info"
        
        let header = ["x-access-token" : token]

        let payload : [String:String] = [:]

        LSBankAPI.call(method: "GET", endpoint: endpoint, header: header, payload: payload, successHandler: successHandler, failHandler: failHandler)
        
    }
    
    static func accountBalance( token : String,
            successHandler: @escaping (_ httpStatusCode : Int, _ response : [String : Any]) -> Void,
            failHandler : @escaping (_ httpStatusCode : Int, _ errorMessage: String) -> Void) {

        let endpoint = "accounts/balance"
        
        let header = ["x-access-token" : token]

        let payload : [String:String] = [:]

        LSBankAPI.call(method: "GET", endpoint: endpoint, header: header, payload: payload, successHandler: successHandler, failHandler: failHandler)
        
    }
 
    
    static func accountActivate( email : String, activationCode : String,
            successHandler: @escaping (_ httpStatusCode : Int, _ response : [String : Any]) -> Void,
            failHandler : @escaping (_ httpStatusCode : Int, _ errorMessage: String) -> Void) {

        let endpoint = "accounts/activate"
        
        let header : [String:String] = [:]

        let payload : [String:String] = ["email" : email,
                                         "activationCode" : activationCode]

        LSBankAPI.call(method: "POST", endpoint: endpoint, header: header, payload: payload, successHandler: successHandler, failHandler: failHandler)
        
    }
    
    
    static func sendMoney( token : String, email : String, message : String, amount : Double,
            successHandler: @escaping (_ httpStatusCode : Int, _ response : [String : Any]) -> Void,
            failHandler : @escaping (_ httpStatusCode : Int, _ errorMessage: String) -> Void) {

        let endpoint = "transactions/transfer"
        
        let header = ["x-access-token" : token]

        let payload : [String:Any] = ["account" : email,
                                      "message" : message,
                                      "amount" : amount]

        LSBankAPI.call(method: "POST", endpoint: endpoint, header: header, payload: payload, successHandler: successHandler, failHandler: failHandler)
        
    }
    
    
    
    static func allAccounts( token : String,
            successHandler: @escaping (_ httpStatusCode : Int, _ response : [String : Any]) -> Void,
            failHandler : @escaping (_ httpStatusCode : Int, _ errorMessage: String) -> Void) {

        let endpoint = "accounts/info"
        
        let header = ["x-access-token" : token]

        let payload : [String:String] = [:]

        LSBankAPI.call(method: "GET", endpoint: endpoint, header: header, payload: payload, successHandler: successHandler, failHandler: failHandler)
        
    }
    
    
    
    static func statement( token : String, days : Int,
            successHandler: @escaping (_ httpStatusCode : Int, _ response : [String : Any]) -> Void,
            failHandler : @escaping (_ httpStatusCode : Int, _ errorMessage: String) -> Void) {

        let endpoint = "transactions/\(days)/statement"
        
        let header = ["x-access-token" : token]

        let payload : [String:String] = [:]

        LSBankAPI.call(method: "GET", endpoint: endpoint, header: header, payload: payload, successHandler: successHandler, failHandler: failHandler)
        
    }
    
    
}



