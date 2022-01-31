//
//  OpenAccountViewController.swift
//  IOS-FinalProject-LSBank
//
//  Created by user203175 on 10/20/21.
//

import UIKit

class OpenAccountViewController: UIViewController, UITextFieldDelegate {

    public var focusedTextFieldTag : Int = 0
    
    @IBOutlet weak var btnOk : UIButton!
    @IBOutlet weak var uLoginContainer : UIView!
    
    @IBOutlet weak var txtLogin : UITextField!
    @IBOutlet weak var txtFirstName : UITextField!
    @IBOutlet weak var txtLastName : UITextField!
    @IBOutlet weak var txtPassword : UITextField!
    @IBOutlet weak var txtMobilePhone : UITextField!
    
    @IBOutlet weak var imgShowPassword : UIImageView!

    
    @IBOutlet weak var actLoading: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialize()
        
    }
    
    private func initialize(){
        customizeView()
       
        txtLogin.delegate = self
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtPassword.delegate = self
        txtMobilePhone.delegate = self
        
        imgShowPassword.enableTapGestureRecognizer(target: self, action: #selector(imgShowPasswordTapped(tapGestureRecognizer:)))
        
        // Handling keyboard show/hide
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        
    }
    
    private func customizeView() {
        uLoginContainer.setLayerCornerRadius(MyAppDefaults.LayerCornerRadius.topViewContainer)
        
        btnOk.setLayerRound()

        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    /* when return key was pressed, keybord is dismissed */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.focusedTextFieldTag = textField.tag
    }
    
    @objc private func keyboardWillShow( notification : NSNotification ){
        
        let containerMarginTop = self.uLoginContainer.frame.origin.y
        
        KeyboardLayoutAdapter.scrollToFit( notification : notification, viewController : self, focusedViewTag : self.focusedTextFieldTag, containerMarginTop: containerMarginTop)
        
    }
    @objc private func keyboardWillHide() {
        
        self.view.frame.origin.y = 0
        
    }
    

    
    @IBAction func btnReturn(_ sender: Any) {
        
        navigationController!.popViewController(animated: true)
        
    }
    
    func closeView() {
        navigationController!.popViewController(animated: true)
    }
    
    func signUpSuccess(httpStatusCode : Int, response : [String:Any] ){
        
        DispatchQueue.main.async {
            self.btnOk.isEnabled = true
            self.actLoading.stopAnimating()
        }

        if httpStatusCode == 200 {
            if let newAccount = AccountsCreate.decode(json: response){
                DispatchQueue.main.async {
                    Toast.ok(view: self, title: "Welcome \(self.txtFirstName!.text ?? "")", message: "Your account was successfully open!\n\nCongratulations and welcome to LSBank.", handler: {action in self.closeView()})
                }
            } else {
                DispatchQueue.main.async {
                    Toast.show(view: self, title: "Something went wront!", message: "Error parsing data received from server! Try again!")
                }
            }
            
        } else {
            if let errorMessage : String = response["error"] as! String? {
                DispatchQueue.main.async {
                    Toast.ok(view: self, title: "Ooops!", message: errorMessage)
                }
                
            } else {
                DispatchQueue.main.async {
                    Toast.ok(view: self, title: "Ooops!", message: "Unkown error from server (http \(httpStatusCode)).")
                }
            }
        }
        
    }
    
    func signUpFail( httpStatusCode : Int, message : String ){

        DispatchQueue.main.async {
            self.btnOk.isEnabled = true
            self.actLoading.stopAnimating()

            Toast.show(view: self, title: "Ooops!", message: message)

        }

        
    }

    @IBAction func btnOk(_ sender : Any) {
        
        guard let firstName = txtFirstName.text, let lastName = txtLastName.text,
              let mobilePhone = txtMobilePhone.text, let login = txtLogin.text, let password = txtPassword.text else {
            print("Please, enter good values!")
            return
        }
        
        btnOk.isEnabled = false
        actLoading.startAnimating()
        
        let account = Account()
        account.firstName = firstName
        account.lastName = lastName
        account.email = login
        account.mobilePhone = mobilePhone
        account.password = password
        
        LSBankAPI.newAccount(account: account, successHandler: signUpSuccess, failHandler: signUpFail)
        
        
        
    }
    
    @objc func imgShowPasswordTapped(tapGestureRecognizer : UITapGestureRecognizer) {

        txtPassword.isSecureTextEntry.toggle()
        if txtPassword.isSecureTextEntry {
            imgShowPassword.image = UIImage(systemName: "eye")
        } else {
            imgShowPassword.image = UIImage(systemName: "eye.slash")
        }
        
    }
    
}
