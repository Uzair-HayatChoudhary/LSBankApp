//
//  UIView_setLayerRound.swift
//  IOS-FinalProject-LSBank
//
//  Created by user203175 on 11/5/21.
//

import Foundation
import UIKit

extension UIView {
    
    func setLayerRound() {
        self.layer.cornerRadius = (self.bounds.size.width / 2)
    }
    
}
