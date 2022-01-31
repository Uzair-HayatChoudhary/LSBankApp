//
//  UIViewController_setAsBottomSheetDialog.swift
//  IOS-FinalProject-LSBank
//
//  Created by Daniel Carvalho on 06/11/21.
//

import Foundation
import UIKit

extension UIViewController {

    func setAsBottomSheetDialog( parentViewController : UIViewController, viewContainer : UIView, viewContainerCornerRadius : CGFloat = 12,
        backGroundAlphaValue : CGFloat = 0.10) {

        /*
         To keep the transition animation, it should be called inside
            
            override func viewWillAppear(_ animated: Bool)

         */
        
        viewContainer.layer.cornerRadius = viewContainerCornerRadius
        parentViewController.view.backgroundColor = UIColor.black.withAlphaComponent(backGroundAlphaValue)
        
        
        let screenSize : CGSize = UIScreen.main.bounds.size
        let viewHeight : CGFloat = viewContainer.bounds.size.height
        
        viewContainer.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: CGFloat(viewHeight))
        
        UIView.animate(withDuration: 0.3,
                       delay: 0, usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut, animations: {

            viewContainer.frame = CGRect(x: 0, y: screenSize.height - viewHeight, width: screenSize.width, height: viewHeight)
        }, completion: nil)
        
    }
    
}

