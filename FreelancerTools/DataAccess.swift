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
    static func selectAll<T: IKeyData>()-> Results<T>
}

protocol IKeyData {
    var id:String {get set}
}

class DataAccess:IDataAccess {
    static func insert<T: IKeyData>(insetObj: T){
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(insetObj as! Object)
            }
        } catch {
            
        }
    }
    
    static func update<T: IKeyData>(updateObj: T){
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(updateObj as! Object, update:true)
            }
        } catch {
            
        }
    }
    
    static func delete<T: IKeyData>(deleteObj: T){
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(deleteObj as! Object)
            }
        } catch {
            
        }
    }
    
    static func select<T: IKeyData>(obj: T)-> T?{
        do {
            let realm = try Realm()
            let predicate = NSPredicate(format: "id = %@ ", obj.id)
            if let data = realm.objects(type(of:(obj as! Object))).filter(predicate).first{
                return data as? T
            }
        } catch {
            
        }
        return nil
    }
    
    static func selectAll<T: IKeyData>()-> Results<T>{
        let realm = try! Realm()
        return realm.objects(T.self).sorted(byKeyPath: "id")
    }
}
