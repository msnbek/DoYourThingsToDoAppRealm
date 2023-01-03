//
//  Plan.swift
//  DoYourThingsToDoApp
//
//  Created by Mahmut Senbek on 29.12.2022.
//

import Foundation
import RealmSwift


class Plan: Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "plans")
    
    
}
