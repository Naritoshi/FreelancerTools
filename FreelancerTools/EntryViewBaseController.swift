//
//  EntryViewBaseController.swift
//  FreelancerTools
//
//  Created by matsuo on 2017/09/15.
//  Copyright © 2017年 matsuo. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class EntryViewBaseController<T: Object>: UIViewController,SearchModalDelegate {

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
            
            //スキップする条件
            if skipTextFieldItem(value: value) == true { continue }
            
            //
            var uiCtrls:[UIControl] = [UIControl]()
            
            let frame = CGRect(x: x, y: y, width: self.view.frame.width - (x * 2), height: height)
            
            switch Util.getTypeString(value: value) {
            case "String","Optional<String>", "Int", "RealmOptional<Int>":
                uiCtrls.append(getDispTextField(name: name, value: value, frame: frame))
            case "Optional<Company>":
                uiCtrls.append(getDispTextField(name: name, value: value, frame: frame))
                uiCtrls.append(getDispSearchButton(frame: frame, value: value))
                break
            default:
                break
            }
            
            for uiCtrl in uiCtrls {
                //画面に追加
                self.view.addSubview(uiCtrl)
            }
            
            if (uiCtrls.count > 0) {
                //テキストフィールドの間隔
                y = y + 40
            }
        }
    }
    
    func skipTextFieldItem(value: Any) -> Bool {        
        var isSkipItem = false
        switch Util.getTypeString(value: value) {
        case "String", "Optional<String>","Int", "RealmOptional<Int>", "Optional<Company>":
            break
        default:
            isSkipItem = true
        }
        return isSkipItem
    }
    
    func getDispTextField(name: String , value: Any, frame: CGRect) -> UIControl {
        //テキストフィールドを追加する
        let textField = UITextField()
        textField.frame = frame
        textField.backgroundColor = UIColor.white
        textField.borderStyle = .bezel
        textField.placeholder = name
        textField.text = Util.toStringObjectItem(value: value)
        setTextFiledSettingByObjectType(textField: textField, value: value)
        
        //nameがidの場合、無効化する
        if name == "id" {
            textField.backgroundColor = UIColor.lightGray
            textField.isEnabled = false
            if entryMode == .insert{
                textField.text = Util.GetTableID()
            }
        }
        
        //配列に入れる
        textFields[name] = textField
    
        return textField
    }
    
    //検索用ボタンのコントロール
    func getDispSearchButton(frame: CGRect, value: Any) -> UIControl{
        let button = UIButton()
        button.frame = CGRect(x: self.view.frame.maxX - 100 - frame.minX, y: frame.minY, width: 100, height: frame.height)
        button.setTitle("検索", for: .normal)
        button.backgroundColor = UIColor.lightGray
        
        //ボタン押下時アクション
        switch Util.getTypeString(value: value){
            case "Company", "Optional<Company>":
                button.addTarget(self, action: #selector(searchCompany), for: .touchUpInside)
            default:
                break
        }
        return button
    }
    
    func setTextFiledSettingByObjectType(textField: UITextField,value: Any){
        switch Util.getTypeString(value: value) {
        case "String","Optional<String>":
            textField.textAlignment = .left
            break
        case "Int", "RealmOptional<Int>":
            textField.textAlignment = .right
            textField.keyboardType = .numberPad
            break
        default:
            break
        }
    }
    
    //---------------------------------------------------------------------------------------------------------------------
    //検索ボタン押下
    //---------------------------------------------------------------------------------------------------------------------
    func searchCompany(sender:Any) {
        let sVC = SearchTableViewController<Company>()
        sVC.delegate = self
        present(sVC, animated: true, completion: nil)
    }
    //検索結果受け取りメソッド
    var searchResults = [String: Object]()
    func selectedObject(object: Object) {
        switch Util.getTypeString(value: object) {
        case "Company", "Optional<Company>":
            if let textField = textFields["compay"] {
                textField.text = object.value(forKey: "name") as? String
                searchResults["compay"] = object
            }
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
    
    //登録
    func insert(){
        let object = T()
        setDipsToObject(object: object)
        setChildObject(object: object)
        DataAccess.insert(insetObj: object)
    }
    
    //変更
    func update(){
        guard let targetObj = targetObject else {
            return
        }
        let object = T(value: targetObj, schema: RLMSchema.partialShared())
        setDipsToObject(object: object)
        setChildObject(object: object)
        DataAccess.update(updateObj: object)
    }
    
    //検索結果を反映
    func setChildObject(object: T){
        for key in searchResults.keys{
            switch searchResults[key] {
            case let company as Company:
                object.setValue(company, forKey: "compay")
                break
            default:
                break
            }
        }
    }
    
    //画面値をセットする
    func setDipsToObject(object:Object){
        let objectMirror = Mirror(reflecting: object)
        
        for (name, value) in objectMirror.children {
            if let propertyName = name as String! {
                
                //画面値をクラスに代入
                //テキストフィールド
                if let nameTextField = textFields[propertyName]{
                    switch Util.getTypeString(value: value) {
                    case "String", "Optional<String>":
                        if let textValue = nameTextField.text{
                            object.setValue(textValue, forKey: propertyName)
                        }
                        break
                    case "RealmOptional<Int>":
                        if let textValue = nameTextField.text, let intValue = Int(textValue)  {
                            object.setValue(RealmOptional<Int>(intValue), forKey: propertyName)
                        }
                        break
                    default:
                        if let textValue = nameTextField.text{
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

