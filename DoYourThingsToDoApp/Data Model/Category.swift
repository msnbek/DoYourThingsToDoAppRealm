//
//  Category.swift
//  DoYourThingsToDoApp
//
//  Created by Mahmut Senbek on 29.12.2022.
//

import Foundation
import RealmSwift


class Category : Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let plans = List<Plan>()  // Her kategorinin icinde bir plan oldugunu belirten kod bloku.
}
