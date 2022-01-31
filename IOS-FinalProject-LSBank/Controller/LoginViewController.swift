//
//  LoginViewController.swift
//  IOS-FinalProject-LSBank
//
//  Created by user203175 on 10/20/21.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    static var token : String = ""
    static var account : AccountsInfo?
    
    private var focusedTextFieldTag : Int = 0
    
    @IBOutlet weak var uLoginContainer : UIView!
    @IBOutlet weak var btnLogin : UIButton!
    
    @IBOutlet weak var txtLogin : UITextField!
    @IBOutlet weak var txtPassword : UITextField!
    
    @IBOutlet weak var actLoading: UIActivityIndicatorView!
    
    @IBOutlet weak var imgShowPassword : UIImageView!

    @IBOutlet weak var lblAppVersion : UILabel!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initialize()
        
    }
    
    private func initialize() {
        customizeView()
        
        lblAppVersion.text = "version \(Bundle.appVersion())"

        txtLogin.delegate = self
        txtPassword.delegate = self
        
        imgShowPassword.enableTapGestureRecognizer(target: self, action: #selector(imgShowPasswordTapped(tapGestureRecognizer: )))
        
        
        // Handling keyboard show/hide
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        


    }
    
    private func customizeView() {
        uLoginContainer.setLayerCornerRadius(MyAppDefaults.LayerCornerRadius.topViewContainer)
        btnLogin.setLayerCornerRadius(MyAppDefaults.LayerCornerRadius.button)

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
    
    
    
    
    
    
    private func signInSuccess(httpStatusCode : Int, response : [String:Any] ){
        
        DispatchQueue.main.async {
            self.btnLogin.isEnabled = true
            self.actLoading.stopAnimating()
        }
        
        if httpStatusCode == 200 {
            if let auth = AccountsAuth.decode(json: response){
                
                DispatchQueue.main.async {
                    LoginViewController.token = auth.token
                    self.btnLogin.isEnabled = false
                    self.actLoading.startAnimating()
                    
                    LSBankAPI.accountInfo(token: auth.token, email: self.txtLogin.text!, successHandler: self.accountInfoSuccess, failHandler: self.apiCallFail)

                }
                
                
            }
        } else {
            
            DispatchQueue.main.async {
                Toast.show(view: self, title: "Something went wront!", message: "Error parsing data received from server! Try again!")
            }
        }
        
    }
    
    func signInFail ( httpStatusCode : Int, message : String ){
        
        if httpStatusCode == 420 {
            // account not activated
            DispatchQueue.main.async {
                self.btnLogin.isEnabled = true
                self.actLoading.stopAnimating()
                
                self.performSegue(withIdentifier: Segue.toAccountActivationView, sender: nil)
            }

        } else {
            
            DispatchQueue.main.async {
                self.btnLogin.isEnabled = true
                self.actLoading.stopAnimating()
                
                Toast.show(view: self, title: "Ooops!", message: message)
            }
        }
        
    }
    

    
    func accountInfoSuccess(httpStatusCode : Int, response : [String:Any] ){
        
        DispatchQueue.main.async {
            self.btnLogin.isEnabled = true
            self.actLoading.stopAnimating()
        }
        
        if httpStatusCode == 200 {
            
            if let accountInfo = AccountsInfo.decode(json: response){
                
                DispatchQueue.main.async {
                    LoginViewController.account = accountInfo
                    self.btnLogin.isEnabled = true
                    self.actLoading.stopAnimating()
                    
                    self.performSegue(withIdentifier: Segue.toMainView, sender: nil)
                }
                
            }
        } else {
            DispatchQueue.main.async {
                Toast.show(view: self, title: "Something went wront!", message: "Error parsing data received from server! Try again!")
            }
        }
        
    }
    
    
    func apiCallFail( httpStatusCode : Int, message : String ){
        
        DispatchQueue.main.async {
            self.btnLogin.isEnabled = true
            self.actLoading.stopAnimating()
            
            Toast.show(view: self, title: "Ooops!", message: message)
        }
        
    }
    
    
    
    @IBAction func btnLoginTouchUp(_ sender : Any?) {
        
        guard let login = txtLogin!.text, let password = txtPassword.text else {
            return
        }
        
        btnLogin.isEnabled = false
        actLoading.startAnimating()
        
        LSBankAPI.signIn(email: login, password: password, successHandler: signInSuccess, failHandler: signInFail)
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.toAccountActivationView {
            
            (segue.destination as! AccountActivationViewController).emailAddress = txtLogin.text!

        }
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
