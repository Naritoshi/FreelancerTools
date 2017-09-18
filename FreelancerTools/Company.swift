//
//  Company.swift
//  FreelancerTools
//
//  Created by matsuo on 2017/09/17.
//  Copyright © 2017年 matsuo. All rights reserved.
//

import Foundation
import RealmSwift

class Company:Object {
    dynamic public var id: String = ""
    dynamic public var name:String = ""
    public let Agents = List<Agent>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
