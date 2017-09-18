//
//  ListViewBaseController.swift
//  FreelancerTools
//
//  Created by matsuo on 2017/09/14.
//  Copyright © 2017年 matsuo. All rights reserved.
//

import UIKit
import RealmSwift

class ListViewBaseController<T: Object>: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView: UITableView = UITableView()
    var backImageView:UIImageView?
    var backImage: UIImage?
    
    //id
    let cellIdentifier = "Cell"
    let entryIdentifier = "projectEntry"
    let seachIdntifier = "projectSeach"
    
    //検索結果
    var objects:Results<T>!
    //検索条件
    var searchKey:T = T()
    var orderKey = "id"
    
    /*　ナビゲーションバー */
    let entryTitle = "登録画面"
    let updateTitle = "変更画面"
    let searchTitle = "検索画面"
    var titleText = ""
    var navigationBar: UINavigationBar?
    var backButton: UIButton?
    var registorButton: UIButton?
    
    //テーブルビュー
    let cellItemHeight:CGFloat = 30.0
    let cellXMargin:CGFloat = 20.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        //テーブルビュー（ナビゲーションバーより先）
        setTableVIew()
        
        /*　ナビゲーションバー　*/
        navigationBar = UINavigationBar()
        navigationBar?.frame = CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: 44)
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(navigationBar!)
        
        let naviItem = UINavigationItem(title: titleText);
        let backItem = UIBarButtonItem(title: "戻る", style: .done, target: nil, action: #selector(back))
        let doneItem = UIBarButtonItem(title: "検索条件", style: .done, target: nil, action: #selector(search))
        naviItem.leftBarButtonItem = backItem;
        naviItem.rightBarButtonItem = doneItem;
        navigationBar?.setItems([naviItem], animated: false);
        
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
    
    func setTableVIew(){
        tableView.frame = CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(tableView)
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    //---------------------------------------------------------------------------------------------------------------------
    //検索ボタン押下処理
    //---------------------------------------------------------------------------------------------------------------------
    func search(){
        //画面遷移
        //検索モードで画面表示
        let entryVC = EntryViewBaseController<T>()
        entryVC.targetObject = searchKey
        entryVC.entryMode = .search
        present(entryVC, animated: true, completion: nil)
    }
    //---------------------------------------------------------------------------------------------------------------------
    //戻るボタン押下処理
    //---------------------------------------------------------------------------------------------------------------------
    func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let object = T()
        return getCellHeight(object: object)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = objects[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let cellView = getCellView(object:object)
        cell.backgroundColor = UIColor.clear
        cell.addSubview(cellView)
        
        return cell
    }
    
    //セルの高さを取得する（Objectのサイズ）
    func getCellHeight(object: T)-> CGFloat {
        let objectMirror = Mirror(reflecting: object)
        let count:CGFloat = CGFloat(objectMirror.children.count)
        let cellHeight:CGFloat = (cellItemHeight) * count
        return cellHeight
    }
    
    func getCellView(object: T)-> UIView{
        let cellView = UIView()
        let objectMirror = Mirror(reflecting: object)
        let x:CGFloat = cellXMargin
        var y:CGFloat = 0.0
        
        for (name, value) in objectMirror.children {
            guard let name = name else { continue }
            
            if skipTextFieldItem(value: value) { continue }
            
            //children.valueでは値が取れなかった
            //object.valueであれば取れた何故かは不明
            var strValue = ""
            if let value = object.value(forKey: name) {
                strValue = Util.toStringObjectItem(value: value)
            }

            //ラベルを追加する
            let label = UILabel()
            label.frame = CGRect(x: x, y: y, width: self.view.frame.width - (x * 2), height: cellItemHeight)
            label.text = name + "：" + strValue
            cellView.addSubview(label)
            //テキストフィールドの間隔
            y = y + cellItemHeight
        }
        
        //
        cellView.backgroundColor = UIColor.clear
        cellView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: getCellHeight(object: object))
        
        return cellView
    }
    
    func skipTextFieldItem(value: Any) -> Bool {
        var isSkipItem = false
        switch Util.getTypeString(value: value) {
        case "String", "Optional<String>","Int", "RealmOptional<Int>", "Agent":
            break
        default:
            isSkipItem = true
        }
        return isSkipItem
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            let deleteObject = objects[indexPath.row]
            //削除処理
            DataAccess.delete(deleteObj: deleteObject)
            //再読み込み
            reloadTableView()
        }else if(editingStyle == .insert){
            
        }
    }
    
    //画面遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = objects[indexPath.row]
        //画面遷移
        //変更モードで画面表示
        let entryVC = EntryViewBaseController<T>()
        entryVC.targetObject = object
        entryVC.entryMode = .update
        present(entryVC, animated: true, completion: nil)
    }
    
    
    //テーブルのセクション数を返す
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //リロード
    func reloadTableView(){
        let predicate = Util.CreatePredicate(object: searchKey)
        self.objects = DataAccess.select(predicate: predicate ,orderKey: orderKey)
        tableView.reloadData()
    }
    
}
