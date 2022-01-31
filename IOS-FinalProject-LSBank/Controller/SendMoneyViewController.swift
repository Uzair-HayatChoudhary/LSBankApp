//
//  SendMoneyViewController.swift
//  IOS-FinalProject-LSBank
//
//  Created by Daniel Carvalho on 18/11/21.
//

import UIKit

protocol BalanceRefresh {
    
    func balanceRefresh()
    
}

class SendMoneyViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    public var payeeList : [Payee]  = []
    public var delegate : BalanceRefresh?
    private var focusedTextFieldTag : Int = 0
    
    @IBOutlet weak var viewContainer : UIView!
    @IBOutlet weak var actLoading: UIActivityIndicatorView!
    @IBOutlet weak var payeePicker : UIPickerView!
    @IBOutlet weak var btnSendMoney : UIButton!
    @IBOutlet weak var txtMessage : UITextField!
    @IBOutlet weak var txtAmount : UITextField!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    
    private func customizeView(){
        
        viewContainer.layer.cornerRadius = 12
        
        btnSendMoney.setLayerRound()
        
    }
    
    private func initialize(){
        customizeView()
        
        
        payeePicker.delegate = self
        payeePicker.dataSource = self
        
        txtMessage.delegate = self
        txtAmount.delegate = self
        
        // Handling keyboard show/hide
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setAsBottomSheetDialog(parentViewController: self, viewContainer: viewContainer, backGroundAlphaValue: 0.20)
    }
    
    @objc private func keyboardWillShow( notification : NSNotification ){
        
        let containerMarginTop = self.viewContainer.frame.origin.y
        
        KeyboardLayoutAdapter.scrollToFit( notification : notification, viewController : self, focusedViewTag : self.focusedTextFieldTag, containerMarginTop: containerMarginTop)
        
    }
    @objc private func keyboardWillHide() {
        
        self.view.frame.origin.y = 0
        
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.payeeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "\(self.payeeList[row].firstName!) \(self.payeeList[row].lastName!)"
        
    }
    
    
    @IBAction func btnCloseTouchUp(_ sender : Any?) {
        
        if actLoading.isAnimating{
            return
        }
        
        self.dismiss(animated: true, completion: nil )
    }
    
    @IBAction func btnSendMoneyTouchUp(_ sender : Any? ) {
        
        guard let amount = Double(txtAmount.text!), let message = txtMessage.text else {
            Toast.ok(view: self, title: "Ooops", message: "Please, enter a valid amount to send!")
            return
        }
        
        if amount < 0.01 {
            Toast.ok(view: self, title: "Ooops", message: "Please, enter a valid amount to send!")
            return
        }

        if Double(amount.formatAsCurrency()) != amount {  // means we have more than 2 decimals
            Toast.ok(view: self, title: "Ooops", message: "Please, enter a valid amount to send!")
            return

        }
        
        let payee = self.payeeList[payeePicker.selectedRow(inComponent: 0)]
        
        let btnYes = Dialog.DialogButton(title: "Yes", style: .default, handler: {action in self.sendMoney(accountEmail: payee.email!, message: message, amount: amount)})
        let btnNo = Dialog.DialogButton(title: "No", style: .destructive, handler: nil)

        Dialog.show(view: self, title: "Confirmation", message: "Do you really want to send CAD$ \(amount.formatAsCurrency()) to \(payee.firstName!) \(payee.lastName!) account at \(payee.email!) ?", style: .actionSheet, completion: nil, presentAnimated: true, buttons: btnYes, btnNo)
        
        
        
    }
    
    func sendMoney( accountEmail : String, message : String, amount : Double ) {

        btnSendMoney.isEnabled = false
        txtAmount.isEnabled = false
        txtMessage.isEnabled = false
        actLoading.startAnimating()
        
        LSBankAPI.sendMoney(token: LoginViewController.token, email: accountEmail, message: message, amount: amount, successHandler: transactionSuccess(httpStatusCode:response:), failHandler: transactionFail(httpStatusCode:message:))

        
    }
    
    
    func transactionSuccess(httpStatusCode : Int, response : [String:Any] ){
        
        DispatchQueue.main.async {
            self.txtAmount.isEnabled = true
            self.txtMessage.isEnabled = true

            self.btnSendMoney.isEnabled = true
            self.actLoading.stopAnimating()
        }

        if httpStatusCode == 200 {
            
            if let transaction = TransactionsTransfer.decode(json: response){
                DispatchQueue.main.async {
                    
                    self.delegate?.balanceRefresh()
                    
                    Toast.ok(view: self, title: "Money sent!", message: "Transaction successfully done!\n\nTransaction ID \(transaction.transactionId)", handler: {action in self.closeView()})
                    
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
    
    func transactionFail( httpStatusCode : Int, message : String ){

        DispatchQueue.main.async {
            self.btnSendMoney.isEnabled = true
            self.actLoading.stopAnimating()

            Toast.show(view: self, title: "Ooops!", message: message)

        }
        
    }
    
    func closeView() {
        
        btnCloseTouchUp(nil)

    }

    
}
