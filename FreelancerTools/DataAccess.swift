//
//  DataAccess.swift
//  FreelancerTools
//
//  Created by matsuo on 2017/09/06.
//  Copyright © 2017年 matsuo. All rights reserved.
//

import Foundation
import RealmSwift

protocol IDataAccess {
    associatedtype object:Object
    /**
     指定したデータを登録する
     */
    static func insert(insetObj: object)
    
    /**
     指定したKeyのデータを更新する
     */
    static func update(updateObj: object)
    
    /**
     指定したKeyのデータを削除する
     */
    static func delete(deleteObj: object)
    
    /**
     プライマリーキーで取得する
     */
    static func selectByKey<K>(key:K)-> object?
    
    /**
     検索した結果を取得する
     */
    static func select(predicate: NSPredicate?, orderKey:String)-> Results<object>
}

class DataAccess<T: Object>:IDataAccess {
    static func insert(insetObj: T){
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(insetObj)
            }
        } catch {
            
        }
    }
    
    static func update(updateObj: T){
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(updateObj , update:true)
            }
        } catch {
            
        }
    }
    
    static func delete(deleteObj: T){
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(deleteObj)
            }
        } catch {
            
        }
    }
    
    static func selectByKey<K>(key: K) -> T? {
        do {
            let realm = try Realm()
            return realm.object(ofType: T.self, forPrimaryKey: key)
        } catch {
            
        }
        return nil
    }
    
    static func select(predicate: NSPredicate?, orderKey:String) -> Results<T> {
        let realm = try! Realm()
        if let predicate = predicate {
            return realm.objects(object.self).filter(predicate).sorted(byKeyPath: orderKey)
        }else{
            //全件
            return realm.objects(object.self).sorted(byKeyPath: orderKey)
        }
    }
}
