//
//  EntryViewBaseController.swift
//  FreelancerTools
//
//  Created by matsuo on 2017/09/15.
//  Copyright © 2017年 matsuo. All rights reserved.
//

import UIKit
import RealmSwift

class EntryViewBaseController<T: Object>: UIViewController {

    enum mode:Int {
        case insert
        case update
        case search
    }
    var entryMode:mode = .insert
    var targetObject:T? = nil
    
    //背景
    var backImageView:UIImageView?
    var backImage: UIImage?
    
    /*
     ナビゲーションバー
     */
    let entryTitle = "登録画面"
    let updateTitle = "変更画面"
    let searchTitle = "検索画面"
    var titleText = ""
    var navigationBar: UINavigationBar?
    var backButton: UIButton?
    var registorButton: UIButton?
    var textFields = [String: UITextField]()
    
    //---------------------------------------------------------------------------------------------------------------------
    //ビューの表示
    //---------------------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //タイトルを決定する
        switch entryMode {
        case .insert:
            titleText = entryTitle
        case .update:
            titleText = updateTitle
        case .search:
            titleText = searchTitle
        }
        
        /*　ナビゲーションバー　*/
        navigationBar = UINavigationBar()
        navigationBar?.frame = CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: 44)
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(navigationBar!)
        
        //
        let naviItem = UINavigationItem(title: titleText);
        let backItem = UIBarButtonItem(title: "戻る", style: .done, target: nil, action: #selector(back))
        let doneItem = UIBarButtonItem(title: "実行", style: .done, target: nil, action: #selector(done))
        naviItem.leftBarButtonItem = backItem;
        naviItem.rightBarButtonItem = doneItem;
        navigationBar?.setItems([naviItem], animated: false);
        
        //画面にテキストフィールドを設定する
        setTextFiled()
        
        //画面に値を設定する
        if entryMode == .update || entryMode == .search {
            setObjectToDisp()
        }
        
        //背景を設定する
        if let backImageData = backImage {
            //画像設定
            backImageView = UIImageView()
            backImageView?.frame = self.view.frame
            backImageView?.image = backImageData
            self.view.insertSubview(backImageView!, at: 0)
            //ブラー設定
            // Blurエフェクトを適用するEffectViewを作成.
            let effect = UIBlurEffect(style: UIBlurEffectStyle.light)
            let effectView = UIVisualEffectView(effect: effect)
            effectView.frame = self.view.frame
            self.view.insertSubview(effectView, at: 1)
        }
    }
    
    //画面にテキストフィールドを設定する
    func setTextFiled(){
        let objectMirror = Mirror(reflecting: targetObject ?? T())
        let x:CGFloat = 20.0
        var y:CGFloat = 100.0
        let height:CGFloat = 30.0
        for (name, value) in objectMirror.children {
            guard let name = name else { continue }
            
            //テキストフィールドを追加する
            let textField = UITextField()
            textField.frame = CGRect(x: x, y: y, width: self.view.frame.width - (x * 2), height: height)
            textField.backgroundColor = UIColor.white
            textField.borderStyle = .bezel
            textField.placeholder = name
            textField.text = Util.toStringObjectItem(value: value)
            setTextFiledSettingByObjectType(textField: textField, value: value)
            textFields[name] = textField
            
            //nameがidの場合、無効化する
            if name == "id" {
                textField.backgroundColor = UIColor.lightGray
                textField.isEnabled = false
                if entryMode == .insert{
                    textField.text = Util.GetTableID()
                }
            }
            
            self.view.addSubview(textField)
            
            //テキストフィールドの間隔
            y = y + 40
        }
    }
    
    func setTextFiledSettingByObjectType(textField: UITextField,value: Any){
        switch value {
        case is String:
            textField.textAlignment = .left
            break
        case is Int, is RealmOptional<Int>:
            textField.textAlignment = .right
            textField.keyboardType = .numberPad
            break
        default:
            break
        }
    }
    
    //---------------------------------------------------------------------------------------------------------------------
    //実行ボタン押下処理
    //---------------------------------------------------------------------------------------------------------------------
    func done(){
        //
        switch entryMode {
        case .insert:
            insert()
        case .update:
            update()
        case .search:
            search()
        }
        //
        self.dismiss(animated: true, completion: nil)
    }
    
    //検索
    func search(){
        let searchKey = T()
        setDipsToObject(object: searchKey)
        // このモーダルビューを表示しているビューコントローラー(=ListViewBaseController)
        // これ自体はUIViewController型なので、ListViewBaseController型に強制ダウンキャストする
        if let listVc = presentingViewController as? ListViewBaseController<T> {
            // テキストフィールドの内容をHomeViewController側に設定
            listVc.searchKey = searchKey
        }
    }
    //継承して記載する部分
    func getSearchObject() -> T{
        return T()
    }
    
    //登録
    func insert(){
        let object = T()
        setDipsToObject(object: object)

        DataAccess.insert(insetObj: object)
    }
    
    //変更
    func update(){
        guard let object = targetObject else {
            return
        }

        setDipsToObject(object: object)
        DataAccess.update(updateObj: object)
    }
    
    //画面値をセットする
    func setDipsToObject(object:Object){
        let objectMirror = Mirror(reflecting: object)
        
        for (name, value) in objectMirror.children {
            if let propertyName = name as String! {
                if let nameField = textFields[propertyName]{
                    
                    switch value {
                    case is String:
                        if let textValue = nameField.text{
                            object.setValue(textValue, forKey: propertyName)
                        }
                        break
                    case is RealmOptional<Int>:
                        if let textValue = nameField.text, let intValue = Int(textValue)  {
                            object.setValue(RealmOptional<Int>(intValue), forKey: propertyName)
                        }
                        break
                    default:
                        if let textValue = nameField.text{
                            object.setValue(textValue, forKey: propertyName)
                        }
                        break
                    }
                }
            }
        }
    }
    
    //---------------------------------------------------------------------------------------------------------------------
    //戻るボタン押下処理
    //---------------------------------------------------------------------------------------------------------------------
    func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //---------------------------------------------------------------------------------------------------------------------
    //プロジェクトが渡ってきた場合の処理
    //---------------------------------------------------------------------------------------------------------------------
    func setObjectToDisp(){
        guard let object = targetObject else {
            return
        }
        for textFieldName in textFields.keys {
            guard let value = object.value(forKey: textFieldName) else {
                continue
            }
            textFields[textFieldName]?.text = Util.toStringObjectItem(value: value)
        }
    }
    
    //---------------------------------------------------------------------------------------------------------------------
    //キーボード以外を触ったらキーボードを閉じる
    //---------------------------------------------------------------------------------------------------------------------
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    //
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}