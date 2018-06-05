//
//  Category.swift
//  Todoey
//
//  Created by Jason Feibelman on 6/4/18.
//  Copyright © 2018 Feibel. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<Item>()
}
