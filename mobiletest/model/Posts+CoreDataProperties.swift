//
//  Posts+CoreDataProperties.swift
//  mobiletest
//
//  Created by sebastian panesso on 21/09/22.
//
//

import Foundation
import CoreData


extension Posts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Posts> {
        return NSFetchRequest<Posts>(entityName: "Posts")
    }

    @NSManaged public var body: String?
    @NSManaged public var favorite: Bool
    @NSManaged public var id: Int32
    @NSManaged public var title: String?

}

extension Posts : Identifiable {

}
