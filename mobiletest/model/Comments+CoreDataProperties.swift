//
//  Comments+CoreDataProperties.swift
//  mobiletest
//
//  Created by sebastian panesso on 21/09/22.
//
//

import Foundation
import CoreData


extension Comments {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comments> {
        return NSFetchRequest<Comments>(entityName: "Comments")
    }

    @NSManaged public var body: String?
    @NSManaged public var email: String?
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var idPost: Int32

}

extension Comments : Identifiable {

}
