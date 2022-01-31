//
//  ViewController.swift
//  IOS-FinalProject-LSBank
//
//  Created by user203175 on 10/15/21.
//

import UIKit

class ViewController: UIViewController {

    var token : String = ""
    
    @IBOutlet weak var txtFirstName : UITextField!
    @IBOutlet weak var txtLastName : UITextField!
    @IBOutlet weak var txtEmail : UITextField!
    @IBOutlet weak var txtMobile : UITextField!
    @IBOutlet weak var txtPassword : UITextField!
    
    @IBOutlet weak var txtDebug : UITextView!

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    
    
    func signUpSuccess(httpStatusCode : Int, response : [String:Any] ){
        var debug = "SUCCESS!\n\n"
        debug += "httpStatusCode: \(httpStatusCode)\n"
        debug += "response:\n\(response)"

        if httpStatusCode == 200 {
            if let newAccount = AccountsCreate.decode(json: response){
                debug = "New Account ID: \(newAccount.accountId)"
            } else {
                debug = "Error decoding JSON/Response"
            }
            
        } else {
            if let errorMessage : String = response["error"] as! String? {
                debug += "\nError message: \(errorMessage)\n"
            } else {
                debug += "EXCEPTION: Error message not found on server response!"
            }
        }
        
        
        txtDebug.text = debug

        
    }
    
    func signUpFail( httpStatusCode : Int, message : String ){
        let debug = "FAIL!\n\nStatus code: \(httpStatusCode)\nError message:\n\(message)"
        txtDebug.text = debug

        
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        txtDebug.text = ""
        
        
        let account = Account()
        account.firstName = txtFirstName.text!
        account.lastName = txtLastName.text!
        account.email = txtEmail.text!
        account.mobilePhone = txtMobile.text!
        account.password = txtPassword.text!
        
        LSBankAPI.newAccount(account: account, successHandler: signUpSuccess, failHandler: signUpFail)
        
        
    }
    
    
    func signInSuccess(httpStatusCode : Int, response : [String:Any] ){
        var debug = "SUCCESS!\n\n"
        debug += "httpStatusCode: \(httpStatusCode)\n"
        debug += "response:\n\(response)"

        if httpStatusCode == 200 {
            if let auth = AccountsAuth.decode(json: response){
                self.token = auth.token

                debug = "THIS IS THE TOKEN \(auth.token)"
            } else {
                debug = "Error decoding JSON/Response"
            }
            
        } else {
            if let errorMessage : String = response["error"] as! String? {
                debug += "\nError message: \(errorMessage)\n"
            } else {
                debug += "EXCEPTION: Error message not found on server response!"
            }
        }
        
        
        txtDebug.text = debug

        
    }
    
    func signInFail( httpStatusCode : Int, message : String ){
        let debug = "FAIL!\n\nStatus code: \(httpStatusCode)\nError message:\(message)"
        txtDebug.text = debug

        
    }
    
    @IBAction func btnSignIn(_ sender: Any) {
        
        txtDebug.text = ""
        
        LSBankAPI.signIn(email: txtEmail.text!, password: txtPassword.text!, successHandler: signInSuccess, failHandler: signInFail)
        
        
    }
    
    
    func accountInfoSuccess(httpStatusCode : Int, response : [String:Any] ){
        var debug = "SUCCESS!\n\n"
        
        debug += "httpStatusCode: \(httpStatusCode)\n"
        debug += "response:\n\(response)"

        if httpStatusCode == 200 {
            if let accountInfo = AccountsInfo.decode(json: response["account"] as! [String : Any]){
                print(accountInfo)
                debug = "Account \(accountInfo)"
            } else {
                debug = "Error decoding JSON/Response"
            }
            
        } else {
            if let errorMessage : String = response["error"] as! String? {
                debug += "\nError message: \(errorMessage)\n"
            } else {
                debug += "EXCEPTION: Error message not found on server response!"
            }
        }
        
        txtDebug.text = debug

        
    }
    
    func accountInfoFail( httpStatusCode : Int, message : String ){
        let debug = "FAIL!\n\nStatus code: \(httpStatusCode)\nError message:\(message)"
        txtDebug.text = debug

        
    }
    
    @IBAction func btnAccountInfo(_ sender: Any) {
        
        txtDebug.text = ""
        
        LSBankAPI.accountInfo(token: self.token, email: txtEmail.text!, successHandler: accountInfoSuccess, failHandler: accountInfoFail)
        
        
    }

    
    
    func accountBalanceSuccess(httpStatusCode : Int, response : [String:Any] ){
        var debug = "SUCCESS!\n\n"
        
        debug += "httpStatusCode: \(httpStatusCode)\n"
        debug += "response:\n\(response)"

        if httpStatusCode == 200 {
            if let accountBalance = AccountsBalance.decode(json: response){
                print(accountBalance)
                debug = "\(accountBalance)"
            } else {
                debug = "Error decoding JSON/Response"
            }
            
        } else {
            if let errorMessage : String = response["error"] as! String? {
                debug += "\nError message: \(errorMessage)\n"
            } else {
                debug += "EXCEPTION: Error message not found on server response!"
            }
        }
        
        txtDebug.text = debug

        
    }
    
    func accountBalanceFail( httpStatusCode : Int, message : String ){
        let debug = "FAIL!\n\nStatus code: \(httpStatusCode)\nError message:\(message)"
        txtDebug.text = debug

        
    }
    
    @IBAction func btnAccountBalance(_ sender: Any) {
        
        txtDebug.text = ""
        
        LSBankAPI.accountBalance(token: self.token, successHandler: accountBalanceSuccess, failHandler: accountBalanceFail)
        
        
    }


    
    func accountsSuccess(httpStatusCode : Int, response : [String:Any] ){
        var debug = "SUCCESS!\n\n"
        
        debug += "httpStatusCode: \(httpStatusCode)\n"
        debug += "response:\n\(response)"

        
        if httpStatusCode == 200 {
            if let accountsAll = AccountsAll.decode(json: response){
                print(accountsAll)
                
                for account in accountsAll.accounts {
                    debug += "\(account.accountId)\n-------------\n"
                }
                
                //debug = "\(accountsAll)"
            } else {
                debug += "Error decoding JSON/Response"
            }
            
        } else {
            if let errorMessage : String = response["error"] as! String? {
                debug += "\nError message: \(errorMessage)\n"
            } else {
                debug += "EXCEPTION: Error message not found on server response!"
            }
        }
        
        
        txtDebug.text = debug

        
    }
    
    func accountsFail( httpStatusCode : Int, message : String ){
        let debug = "FAIL!\n\nStatus code: \(httpStatusCode)\nError message:\(message)"
        txtDebug.text = debug

        
    }
    
    @IBAction func btnAccounts(_ sender: Any) {
        
        txtDebug.text = ""
        
        LSBankAPI.accounts(token: self.token, successHandler: accountsSuccess, failHandler: accountsFail)
        
        
    }

    
    
    func accountActivateSuccess(httpStatusCode : Int, response : [String:Any] ){
        var debug = "SUCCESS!\n\n"
        
        debug += "httpStatusCode: \(httpStatusCode)\n"
        debug += "response:\n\(response)"

        
        if httpStatusCode == 200 {

            // Activated
            debug += "ACCOUNT ACTIVATED!"
            
        } else {
            if let errorMessage : String = response["error"] as! String? {
                debug += "\nError message: \(errorMessage)\n"
            } else {
                debug += "EXCEPTION: Error message not found on server response!"
            }
        }
        
        
        txtDebug.text = debug

        
    }
    
    func accountActivateFail( httpStatusCode : Int, message : String ){
        let debug = "FAIL!\n\nStatus code: \(httpStatusCode)\nError message:\(message)"
        txtDebug.text = debug

        
    }

    
    @IBAction func btnAccountActivate(_ sender: Any) {
        
        txtDebug.text = ""
        
        LSBankAPI.accountActivate(email: txtEmail.text!, activationCode: txtPassword.text!, successHandler: accountActivateSuccess, failHandler: accountActivateFail)
        
        
    }

    @IBAction func btnStatementTouchUp(_ sender : Any?) {
        
        txtDebug.text = ""
        
        LSBankAPI.statement(token: self.token , days: 30, successHandler: accountStatementSuccess, failHandler: accountStatementFail)
        
        
    }
    
    
    func accountStatementSuccess(httpStatusCode : Int, response : [String:Any] ){
        var debug = "SUCCESS!\n\n"
        
        debug += "httpStatusCode: \(httpStatusCode)\n"
        debug += "response:\n\(response)"

        
        if httpStatusCode == 200 {

            if let transactions = TransactionStatement.decode(json: response){
                print(transactions)
                
            } else {
                debug += "Error decoding JSON/Response"
            }

        } else {
            if let errorMessage : String = response["error"] as! String? {
                debug += "\nError message: \(errorMessage)\n"
            } else {
                debug += "EXCEPTION: Error message not found on server response!"
            }
        }
        
        
        txtDebug.text = debug

        
    }
    
    func accountStatementFail( httpStatusCode : Int, message : String ){
        let debug = "FAIL!\n\nStatus code: \(httpStatusCode)\nError message:\(message)"
        txtDebug.text = debug

        
    }

}

