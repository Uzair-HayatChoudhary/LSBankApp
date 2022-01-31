//
//  KeyboardLayoutAdapter.swift
//  IOS-FinalProject-LSBank
//
//  Created by Daniel Carvalho on 10/23/21.
//

import Foundation
import UIKit

class KeyboardLayoutAdapter {
    

    static func scrollToFit( notification : NSNotification, viewController : UIViewController, focusedViewTag : Int, containerMarginTop : CGFloat = 0, keyboardMarginBottom : CGFloat = 40) {
        
        if focusedViewTag == 0 {
            return
        }
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let keyboardHeight = keyboardFrame.cgRectValue.height
            
            let focusedTextField = viewController.view.viewWithTag(focusedViewTag) as! UITextField
            let bottomSpace = containerMarginTop + focusedTextField.frame.origin.y + focusedTextField.frame.height + keyboardMarginBottom
            
            if (viewController.view.frame.height - keyboardHeight) < bottomSpace {
                viewController.view.frame.origin.y = 0
                viewController.view.frame.origin.y -= bottomSpace - (viewController.view.frame.height - keyboardHeight)
            }
            
        }
        
    }

    
}
