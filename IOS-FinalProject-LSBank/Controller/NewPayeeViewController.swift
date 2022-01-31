//
//  NewPayeeViewController.swift
//  IOS-FinalProject-LSBank
//
//  Created by Daniel Carvalho on 06/11/21.
//

import UIKit

protocol PayeesTableRefresh {
    
    func payeesTableRefresh()
    
}

class NewPayeeViewController: UIViewController, UITextFieldDelegate {
    
    enum btnOkRoles {
        case find,
             save
    }
    
    var focusedTextFieldTag : Int = 0
    var btnOkRole : btnOkRoles = .find
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var accountInfo : AccountsInfo?
    
    var delegate : PayeesTableRefresh?
    
    
    @IBOutlet weak var viewContainer : UIView!
    @IBOutlet weak var actLoading: UIActivityIndicatorView!
    @IBOutlet weak var txtEmail : UITextField!
    @IBOutlet weak var txtPayeeName : UILabel!
    @IBOutlet weak var viewContainerPayeeInfo : UIView!
    @IBOutlet weak var btnOk : UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    
    
    }
    
    
    func initialize(){
        customizeView()
        
        txtEmail.delegate = self
        
        // Handling keyboard show/hide
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func customizeView() {
        btnOk.setLayerRound()
        
        viewContainer.layer.cornerRadius = 12
        
        customizeViewBtnOkRole()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.setAsBottomSheetDialog(parentViewController: self, viewContainer: viewContainer, backGroundAlphaValue: 0.20)
    }

    
    /* when return key was pressed, keybord is dismissed */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func txtEmailChanged(_ sender : Any?) {
        self.btnOkRole = .find
        customizeViewBtnOkRole()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.focusedTextFieldTag = textField.tag
    }
    
    @objc private func keyboardWillShow( notification : NSNotification ){
        
        let containerMarginTop = self.viewContainer.frame.origin.y
        
        KeyboardLayoutAdapter.scrollToFit( notification : notification, viewController : self, focusedViewTag : self.focusedTextFieldTag, containerMarginTop: containerMarginTop)
        
    }
    @objc private func keyboardWillHide() {
        
        self.view.frame.origin.y = 0
        
    }
    
    
    @IBAction func btnCloseTouchUp(_ sender : Any? ){
        
        if actLoading.isAnimating {  // waiting for result - user cannot leave
            return
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func customizeViewBtnOkRole(){
        
        if btnOkRole == .find {
            btnOk.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
            self.viewContainerPayeeInfo.isHidden = true
        } else {
            btnOk.setImage(UIImage(systemName: "checkmark"), for: .normal)
            self.viewContainerPayeeInfo.isHidden = false
        }
        
    }
    
    
    
    func accountInfoSuccess(httpStatusCode : Int, response : [String:Any] ){
        
        DispatchQueue.main.async {
            self.btnOk.isEnabled = true
            self.actLoading.stopAnimating()
        }
        
        if httpStatusCode == 200 {
            
            if let accountInfo = AccountsInfo.decode(json: response){
                
                DispatchQueue.main.async {
                    
                    self.accountInfo = accountInfo
                    self.txtPayeeName.text = "\(self.accountInfo!.lastName), \(self.accountInfo!.firstName)"
                    
                    self.btnOkRole = .save
                    self.customizeViewBtnOkRole()
                    
                }
                
            }
        } else {
            DispatchQueue.main.async {
                Toast.ok(view: self, title: "Something went wront!", message: "Error parsing data received from server! Try again!")
            }
        }
        
    }
    
    
    func accountInfoFail( httpStatusCode : Int, message : String ){
        
        DispatchQueue.main.async {
            self.btnOk.isEnabled = true
            self.actLoading.stopAnimating()
            
            Toast.ok(view: self, title: "Ooops!", message: message)
        }
        
    }
    
    
    
    @IBAction func btnOkTouchUp(_ sender : Any? ){
        
        
        guard let email : String = txtEmail.text?.lowercased() else {
            return
        }
        
        if !email.isValidEmail() {
            Toast.ok(view: self, title: "Invalid address", message: "Please, enter a valid email address!")
            return
        }
        
        if email == LoginViewController.account!.email {
            Toast.ok(view: self, title: "Invalid payee", message: "You cannot set yourself as a payee!")
            return
        }
        
        if btnOkRole == .find {
            
            btnOk.isEnabled = false
            actLoading.startAnimating()
            
            LSBankAPI.accountInfo(token: LoginViewController.token, email: email, successHandler: self.accountInfoSuccess, failHandler: self.accountInfoFail)
            
            
        } else {  //save
            
            self.saveNewPayee()
            
        }
        
        
    }
    
    func saveNewPayee() {
        
        // Check if payee is already saved on payeeList
        if let payee = Payee.findByEmail(context: self.context, email: self.accountInfo!.email) {
            Toast.ok(view: self, title: "Already a payee", message: "\(payee.firstName!) is already in your payee list!", handler: nil)
            return
        }
        
        
        let newPayee = Payee(context: context)
        newPayee.firstName = self.accountInfo!.firstName
        newPayee.lastName = self.accountInfo!.lastName
        newPayee.email = self.accountInfo!.email
        
        if let _ = newPayee.save(context: context){
                self.delegate!.payeesTableRefresh()
                self.dismiss(animated: true, completion: nil)
        } else {
            Toast.ok(view: self, title: "New payee", message: "An error occurred when trying to save \(newPayee.firstName!) as a new payee! Please, try again", handler: nil)
        }
        
    }
    
    
}
