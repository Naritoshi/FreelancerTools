//
//  Project.swift
//  FreelancerTools
//
//  Created by matsuo on 2017/07/30.
//  Copyright © 2017年 matsuo. All rights reserved.
//

import Foundation
class Project: NSObject,NSCoding, IKeyData{
    
    public var ID: String
    public var name:String
    public var pgLang:String
    public var place:String
    public var price:Int?
    public var lowerTime:Int?
    public var upperTime:Int?
    public var state:String
    public var note:String
    
    public convenience init(name: String, pgLang: String?, place: String?, price: Int?
                , lowerTime: Int?, upperTime: Int?, state:String?, note:String?){
        //ID自動採番用
        let ID = Util.GetTableID()
        self.init(ID: ID, name: name, pgLang: pgLang, place: place, price: price, lowerTime: lowerTime, upperTime: upperTime, state: state, note: note)
    }
    
    public init(ID: String,name: String, pgLang: String?, place: String?, price: Int?
        , lowerTime: Int?, upperTime: Int?, state:String?, note:String?){
        self.name = name
        self.pgLang = pgLang ?? ""
        self.place = place ?? ""
        self.price = price
        self.lowerTime = lowerTime
        self.upperTime = upperTime
        self.state = state ?? ""
        self.note = note ?? ""
        //
        self.ID = ID
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.ID = aDecoder.decodeObject(forKey: "ID") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.pgLang = aDecoder.decodeObject(forKey: "pgLang") as! String
        self.place = aDecoder.decodeObject(forKey: "place") as! String
        self.price = aDecoder.decodeObject(forKey: "price") as? Int
        self.lowerTime = aDecoder.decodeObject(forKey: "lowerTime") as? Int
        self.upperTime = aDecoder.decodeObject(forKey: "upperTime") as? Int
        self.state = aDecoder.decodeObject(forKey: "state") as! String
        self.note = aDecoder.decodeObject(forKey: "note") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(ID, forKey: "ID")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(pgLang, forKey: "pgLang")
        aCoder.encode(place, forKey: "place")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(lowerTime, forKey: "lowerTime")
        aCoder.encode(upperTime, forKey: "upperTime")
        aCoder.encode(state, forKey: "state")
        aCoder.encode(note, forKey: "note")
    }
}
