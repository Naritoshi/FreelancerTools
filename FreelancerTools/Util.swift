//
//  ConvertUtil.swift
//  FreelancerTools
//
//  Created by matsuo on 2017/09/06.
//  Copyright © 2017年 matsuo. All rights reserved.
//

import Foundation
class Util{
    
    static func CleateProjectInstans(nameText: String, pgLangText: String?, placeText: String?, priceText: String?
        , lowerTimeText: String?, upperTimeText: String?, stateText:String?, noteText:String?) -> Project {
        let name = nameText
        let pgLang = pgLangText
        let place = placeText
        var price:Int? = nil
        var lower:Int? = nil
        var upper:Int? = nil
        let state = stateText
        let note = noteText
        
        if let priceStr = priceText{
            price = Int(priceStr)
        }
        if let lowerStr = lowerTimeText{
            lower = Int(lowerStr)
        }
        if let upperStr = upperTimeText {
            upper = Int(upperStr)
        }
        
        return Project(name: name, pgLang: pgLang, place: place, price: price, lowerTime: lower, upperTime: upper, state: state, note: note)
    }
    
    static func CleateProjectInstans(ID: String,nameText: String, pgLangText: String?, placeText: String?, priceText: String?
        , lowerTimeText: String?, upperTimeText: String?, stateText:String?, noteText:String?) -> Project {
        let name = nameText
        let pgLang = pgLangText
        let place = placeText
        var price:Int? = nil
        var lower:Int? = nil
        var upper:Int? = nil
        let state = stateText
        let note = noteText
        
        if let priceStr = priceText{
            price = Int(priceStr)
        }
        if let lowerStr = lowerTimeText{
            lower = Int(lowerStr)
        }
        if let upperStr = upperTimeText {
            upper = Int(upperStr)
        }
        
        return Project(ID: ID,name: name, pgLang: pgLang, place: place, price: price, lowerTime: lower, upperTime: upper, state: state, note: note)
    }
    
    //一意なIDを発行する
    static func GetTableID() -> String{
        return NSUUID().uuidString
    }
}
