//
//  Project.swift
//  FreelancerTools
//
//  Created by matsuo on 2017/07/30.
//  Copyright © 2017年 matsuo. All rights reserved.
//

import Foundation
import RealmSwift

class Project: Object,IKeyData{
    dynamic public var id: String = ""
    dynamic public var name:String = ""
    dynamic public var pgLang:String?
    dynamic public var place:String?
    public var price = RealmOptional<Int>()
    public var lowerTime = RealmOptional<Int>()
    public var upperTime = RealmOptional<Int>()
    dynamic public var state:String?
    dynamic public var note:String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
