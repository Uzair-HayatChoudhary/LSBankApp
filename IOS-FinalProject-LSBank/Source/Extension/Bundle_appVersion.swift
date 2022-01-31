//
//  UIApplication_appVersion.swift
//  IOS-FinalProject-LSBank
//
//  Created by Daniel Carvalho on 14/11/21.
//

import Foundation
import UIKit

extension Bundle {
    
    static func appVersion() -> String {
        if let release : String = releaseVersion(), let build : String = buildVersion() {
            return "\(release) (build \(build))"
        } else {
            return "(unknow)"
        }
    }
    
    static func releaseVersion() -> String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    static func buildVersion() -> String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
    
    
}
