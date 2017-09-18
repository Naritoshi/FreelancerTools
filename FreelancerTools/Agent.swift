//
//  Agent.swift
//  FreelancerTools
//
//  Created by matsuo on 2017/09/17.
//  Copyright © 2017年 matsuo. All rights reserved.
//

import Foundation
import RealmSwift

class Agent:Object {
    dynamic public var id: String = ""
    dynamic public var name:String = ""
    dynamic public var emailAdress:String?
    dynamic public var compay:Company?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
