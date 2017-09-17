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
    
    static func CreatePredicate<T: Object>(object: T) -> NSPredicate?{
        if let project = object as? Project {
            return CleateProjectPredicate(project: project)
        }
        
        let predicats = [NSPredicate]()
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicats)
    }
    
    static func CleateProjectPredicate(project: Project) -> NSPredicate? {
        var predicats = [NSPredicate]()
        
        //名前
        if project.name != "" {
            let predicate = NSPredicate(format: "name = %@", project.name)
            predicats.append(predicate)
        }
        
        //言語
        if let pgLang = project.pgLang, pgLang != "" {
            let predicate = NSPredicate(format: "pgLang = %@", pgLang)
            predicats.append(predicate)
        }
        
        //場所
        if let place = project.place, place != "" {
            let predicate = NSPredicate(format: "place = %@", place)
            predicats.append(predicate)
        }
        
        //金額
        if let price = project.price.value {
            let predicate = NSPredicate(format: "place = %@", price)
            predicats.append(predicate)
        }
        
        //下限
        if let lowerTime = project.lowerTime.value {
            let predicate = NSPredicate(format: "lowerTime = %@", lowerTime)
            predicats.append(predicate)
        }
        
        //上限
        if let upperTime = project.upperTime.value {
            let predicate = NSPredicate(format: "upperTime = %@", upperTime)
            predicats.append(predicate)
        }
        
        //状態
        if let state = project.state, state != "" {
            let predicate = NSPredicate(format: "state = %@", state)
            predicats.append(predicate)
        }
        
        //メモ
        if let note = project.note, note != "" {
            let predicate = NSPredicate(format: "note = %@", note)
            predicats.append(predicate)
        }
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicats)
    }
    
    //一意なIDを発行する
    static func GetTableID() -> String{
        return NSUUID().uuidString
    }
    
    //文字列変換する
    static func toStringObjectItem(value:Any)->String{
        var retStr = String()
        switch value {
        case is String:
            if let strValue = value as? String {
                retStr = strValue
            }
            break
        case is Int:
            if let intValue = value as? Int {
                retStr = String(intValue)
            }
            break
        case is RealmOptional<Int>:
            if let intValue = (value as? RealmOptional<Int>)?.value {
                retStr = String(intValue)
            }
            break
        default:
            break
        }
        
        return retStr
    }
}
