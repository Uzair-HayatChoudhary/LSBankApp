//
//  Payee.swift
//  IOS-FinalProject-LSBank
//
//  Created by Daniel Carvalho on 14/11/21.
//

import Foundation
import CoreData

extension Payee : CoreDataProviderProtocol {
    
    static let entityName : String = "Payee"
    
    static func all(context : NSManagedObjectContext) -> [Payee] {
        return CoreDataProvider.all(context: context, entityName: entityName) as! [Payee]
    }
    
    static func allByFirstName(context : NSManagedObjectContext) -> [Payee] {
        
        let sort = NSSortDescriptor(key: "firstName", ascending: true)
        
        return CoreDataProvider.all(context: context, entityName: entityName, sortDescriptors: [sort]) as! [Payee]
    }
    
    static func findByEmail(context : NSManagedObjectContext, email : String) -> Payee? {
        if let payee = CoreDataProvider.findBy(context: context, entityName: entityName, key: "email", value: email) {
            return payee as? Payee
        } else {
            return nil
        }
    }
    
    func save(context: NSManagedObjectContext) -> UUID? {
        if self.uuid == nil {
            self.uuid = UUID()
        }
        do {
            try CoreDataProvider.save(context: context)
            return self.uuid
        } catch {
            return nil
        }
        
    }
    
    func delete(context: NSManagedObjectContext) -> Bool {
        do {
            let result = try CoreDataProvider.delete(context: context, objectToDelete: self)
            return result
        } catch {
            return false
        }
    }

    
    
}
