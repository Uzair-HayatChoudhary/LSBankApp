//
//  UIViewGestureScroll.swift
//  IOS-FinalProject-LSBank
//
//  Created by Daniel Carvalho on 25/10/21.
//

import Foundation
import UIKit

class UIViewGestureScroll {
    
    
    static func handlePan( _ recognizer : UIPanGestureRecognizer, view : UIView, beyondViewMaxValue : CGFloat = 40 ) {
        
        // Called inside
        //     @IBAction func handlePan( _ recognizer : UIPanGestureRecognizer ) {
        
        
        guard let recognizerView = recognizer.view else {
            return
        }
        
        let deviceHeight = UIScreen.main.bounds.height
        
        let translation = recognizer.translation(in: view)
        recognizerView.center.y += translation.y
        recognizer.setTranslation(.zero, in: view)

        if recognizerView.frame.origin.y < deviceHeight - recognizerView.frame.height  {
            recognizerView.frame.origin.y = deviceHeight - recognizerView.frame.height - beyondViewMaxValue
        } else {
            // top
            if recognizerView.frame.origin.y > 0 {
                recognizerView.frame.origin.y = beyondViewMaxValue
            }
        }
        
        ////
        guard recognizer.state == .ended else {
            return
        }
        let velocity = recognizer.velocity(in: view)
        var vectorToFinalPoint = CGPoint(x: velocity.x/15, y: velocity.y/15)
//        var vectorToFinalPoint = CGPoint(x: velocity.x/10, y: velocity.y/10)
        var finalPoint = recognizerView.center
        
        ////
        if vectorToFinalPoint.y < deviceHeight - recognizerView.frame.height  {
            vectorToFinalPoint.y = deviceHeight - recognizerView.frame.height
        } else {
            // top
            if vectorToFinalPoint.y > 0 {
                vectorToFinalPoint.y = 0
            }
        }
        vectorToFinalPoint.x = 0
        
        finalPoint.y += vectorToFinalPoint.y
        
        let vectorToFinalPointLength = (vectorToFinalPoint.x * vectorToFinalPoint.x + (vectorToFinalPoint.y * vectorToFinalPoint.y) ).squareRoot()
        
        UIView.animate(withDuration: TimeInterval(vectorToFinalPointLength/1800), delay: 0, options: .curveLinear, animations: {recognizerView.center = finalPoint}, completion: nil)
        
        /// no x movement
        recognizerView.frame.origin.x = 0
        // bottom
        
        if recognizerView.frame.origin.y < deviceHeight - recognizerView.frame.height  {
            recognizerView.frame.origin.y = deviceHeight - recognizerView.frame.height
        } else {
            // top
            if recognizerView.frame.origin.y > 0 {
                recognizerView.frame.origin.y = 0
            }
        }

    }

    
    
    
}
