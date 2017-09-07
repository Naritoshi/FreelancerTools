//
//  DataAccess.swift
//  FreelancerTools
//
//  Created by matsuo on 2017/09/06.
//  Copyright © 2017年 matsuo. All rights reserved.
//

import Foundation

protocol IDataAccess {
    /**
     指定したデータを登録する
     */
    static func insert<T: IKeyData>(insetObj: T)
    
    /**
     指定したKeyのデータを更新する
     */
    static func update<T: IKeyData>(updateObj: T)
    
    /**
     指定したKeyのデータを削除する
     */
    static func delete<T: IKeyData>(deleteObj: T)
    
    /**
     指定したKeyのデータを取得する
     */
    static func select<T: IKeyData>(obj: T)-> T?
    
    /**
     全データ取得する
     */
    static func selectAll<T: IKeyData>()-> [T]
}

protocol IKeyData {
    var ID:String {get set}
}

class DataAccessUserDefault:IDataAccess {
    static func insert<T: IKeyData>(insetObj: T){
        let key: String = String(describing: type(of: insetObj))
        let encodecInsObj = NSKeyedArchiver.archivedData(withRootObject: insetObj)
        
        if var table = UserDefaults.standard.dictionary(forKey: key){
            table[insetObj.ID] = encodecInsObj
            UserDefaults.standard.set(table, forKey: key)
        }else{
            var table = [String:Data]()
            table[insetObj.ID] = encodecInsObj
            UserDefaults.standard.set(table, forKey: key)
        }
    }
    
    static func update<T: IKeyData>(updateObj: T){
        let key: String = String(describing: type(of: updateObj))
        
        if var table = UserDefaults.standard.dictionary(forKey: key) as? [String:Data] {
            let encodecUpdObj = NSKeyedArchiver.archivedData(withRootObject: updateObj)
            table[updateObj.ID] = encodecUpdObj
            UserDefaults.standard.set(table, forKey: key)
        }
    }
    
    static func delete<T: IKeyData>(deleteObj: T){
        let key: String = String(describing: type(of: deleteObj))
        
        if var table = UserDefaults.standard.dictionary(forKey: key) as? [String:Data] {
            table.removeValue(forKey: deleteObj.ID)
            UserDefaults.standard.set(table, forKey: key)
        }
    }
    
    static func select<T: IKeyData>(obj: T)-> T?{
        let key: String = String(describing: type(of: obj))
        
        if let table = UserDefaults.standard.dictionary(forKey: key) as? [String:Data] {
            if let data = table[obj.ID] {
                let decodedData = NSKeyedUnarchiver.unarchiveObject(with: data) as! T
                return decodedData
            }
        }
        return nil
    }
    
    static func selectAll<T: IKeyData>()-> [T]{
        let key: String = String(describing: T.self)
        var array = [T]()
        if let table = UserDefaults.standard.dictionary(forKey: key) as? [String:Data] {
            for data in table.values{
                let decodedData = NSKeyedUnarchiver.unarchiveObject(with: data) as! T
                array.append(decodedData)
            }
        }
        return array
    }
}
