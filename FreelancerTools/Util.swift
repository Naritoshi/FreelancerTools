//
//  ConvertUtil.swift
//  FreelancerTools
//
//  Created by matsuo on 2017/09/06.
//  Copyright © 2017年 matsuo. All rights reserved.
//

import Foundation
import RealmSwift

class Util{
    
    //ID自動採番
    static func CleateProjectInstans(nameText: String, pgLangText: String?, placeText: String?, priceText: String?
        , lowerTimeText: String?, upperTimeText: String?, stateText:String?, noteText:String?) -> Project {

        return CleateProjectInstans(id: GetTableID(), nameText: nameText, pgLangText: pgLangText, placeText: placeText, priceText: priceText, lowerTimeText: lowerTimeText, upperTimeText: upperTimeText, stateText: stateText, noteText: noteText)
    }
    static func CleateProjectInstans(id: String,nameText: String, pgLangText: String?, placeText: String?, priceText: String?
        , lowerTimeText: String?, upperTimeText: String?, stateText:String?, noteText:String?) -> Project {
        let name = nameText
        let pgLang = pgLangText
        let place = placeText
        var price:Int? = nil
        var lowerTime:Int? = nil
        var upperTime:Int? = nil
        let state = stateText
        let note = noteText
        
        if let priceStr = priceText{
            price = Int(priceStr)
        }
        if let lowerStr = lowerTimeText{
            lowerTime = Int(lowerStr)
        }
        if let upperStr = upperTimeText {
            upperTime = Int(upperStr)
        }
        
        //オプジェクト生成
        let project = Project()
        project.id = id
        project.name = name
        project.pgLang = pgLang
        project.place = place
        project.price = RealmOptional<Int>(price)
        project.lowerTime = RealmOptional<Int>(lowerTime)
        project.upperTime = RealmOptional<Int>(upperTime)
        project.state = state
        project.note = note
        return project
    }
    
    //一意なIDを発行する
    static func GetTableID() -> String{
        return NSUUID().uuidString
    }
}
