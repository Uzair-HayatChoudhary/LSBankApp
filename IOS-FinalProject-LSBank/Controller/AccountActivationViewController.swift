//
//  AccountActivationViewController.swift
//  IOS-FinalProject-LSBank
//
//  Created by user203175 on 10/23/21.
//

import UIKit

class AccountActivationViewController: UIViewController {
    
    public var emailAddress : String = ""
    
    @IBOutlet weak var txtActivationCode : UITextField!
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var viewContainer : UIView!
    @IBOutlet weak var actLoading: UIActivityIndicatorView!
    @IBOutlet weak var btnActivate : UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
       
        initialize()
    }
    

    private func initialize(){
        customizeView()
        
        txtActivationCode.becomeFirstResponder()

    }
    
    private func customizeView() {
        viewContainer.setLayerCornerRadius(MyAppDefaults.LayerCornerRadius.topViewContainer)
        btnActivate.setLayerCornerRadius(MyAppDefaults.LayerCornerRadius.button)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.frame = CGRect(x: 0, y: 0, width: mainView.frame.width, height: 2000)
    }
    
    @IBAction func handlePan( _ recognizer : UIPanGestureRecognizer ) {
        UIViewGestureScroll.handlePan(recognizer, view: view)
    }
    
    @IBAction func btnClose(_ sender : Any?) {
        navigationController!.popViewController(animated: true)
    }
    
    
    func accountActivateSuccess(httpStatusCode : Int, response : [String:Any] ){
        
        DispatchQueue.main.async {
            self.btnActivate.isEnabled = true
            self.actLoading.stopAnimating()
        }
        
        
        if httpStatusCode == 200 {
            
            DispatchQueue.main.async {
                Toast.ok(view: self, title: "Welcome", message: "Your account was successfully activated!", handler: {action in self.navigationController!.popViewController(animated: true)})
            }
            
        } else {
            DispatchQueue.main.async {
                Toast.ok(view: self, title: "Failed to activate!", message: "Something went wrong when trying to activate your account!")
            }
        }
        
    }
    
    func accountActivateFail( httpStatusCode : Int, message : String ){
        
        DispatchQueue.main.async {
            self.btnActivate.isEnabled = true
            self.actLoading.stopAnimating()
            Toast.ok(view: self, title: "Failed to activate!", message: message)
        }
        
    }
    
    
    @IBAction func btnActivateTouchUp ( _ sender : Any? ){
        
        actLoading.startAnimating()
        btnActivate.isEnabled = false
        
        if let activationCode : String = txtActivationCode.text {
            print(activationCode)
            
            LSBankAPI.accountActivate(email: emailAddress, activationCode: activationCode, successHandler:accountActivateSuccess, failHandler: accountActivateFail)

        } else {
            Toast.ok(view: self, title: "Activation code", message: "Enter a valid activation code!")

        }
        
        
        
    }
    
}
