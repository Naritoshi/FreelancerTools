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
        case let strValue as String:
            retStr = strValue
        case let intValue as Int:
            retStr = String(intValue)
        case is RealmOptional<Int>:
            if let intValue = (value as? RealmOptional<Int>)?.value {
                retStr = String(intValue)
            }
        case is Company, is Project, is Agent:
            if let strValue = (value as? Object)?.value(forKey: "name") as? String {
                retStr = strValue
            }
        default:
            break
        }
        
        return retStr
    }
    
    //型を文字列で取得する
    static func getTypeString(value: Any)-> String {
        let valueType = type(of: value)
        let strValueType = String(describing: valueType)
        return strValueType
    }
}
