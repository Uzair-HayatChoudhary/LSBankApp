//
//  Payee+CoreDataProperties.swift
//  IOS-FinalProject-LSBank
//
//  Created by Daniel Carvalho on 14/11/21.
//
//

import Foundation
import CoreData


extension Payee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Payee> {
        return NSFetchRequest<Payee>(entityName: "Payee")
    }

    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var uuid: UUID?

}

extension Payee : Identifiable {

}
