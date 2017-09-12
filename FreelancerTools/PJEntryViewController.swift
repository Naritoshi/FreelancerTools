//
//  PJEntryViewController.swift
//  FreelancerTools
//
//  Created by matsuo on 2017/07/30.
//  Copyright © 2017年 matsuo. All rights reserved.
//

import UIKit

class PJEntryViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource {
    
    enum mode:Int {
        case insert
        case update
    }
    var entryMode:mode = .insert
    var targetProjet:Project? = nil
    
    //ナビゲーションバー
    @IBOutlet var navigationBar: UINavigationBar!
    
    //入力テキスト
    @IBOutlet var nameText: UITextField!
    @IBOutlet var langText: UITextField!
    @IBOutlet var placeText: UITextField!
    @IBOutlet var priceText: UITextField!
    @IBOutlet var lowerText: UITextField!
    @IBOutlet var upperText: UITextField!
    @IBOutlet var stateText: UITextField!
    @IBOutlet var memoText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //状態のリストを初期化する
        pikerViewInit()
        
        //updateモードの場合初期値をセットする
        if entryMode == .update {
            navigationBar.topItem?.title = "案件更新"
            setProjcet()
        }
    }
    
    //登録ボタン押下処理
    @IBAction func regstor(_ sender: Any) {
        //
        if self.entryMode == .update {
            updateProject()
        }else{
            insertProject()
        }
        
        //画面を戻す
        dismiss(animated: true, completion: nil)
    }
    
    func insertProject(){
        let project = Util.CleateProjectInstans(nameText: nameText.text ?? ""
            , pgLangText: langText.text
            , placeText: placeText.text
            , priceText: priceText.text
            , lowerTimeText: lowerText.text
            , upperTimeText: upperText.text
            , stateText: stateText.text
            , noteText: memoText.text)
        
        DataAccess.insert(insetObj: project)
    }
    
    func updateProject(){
        let id = targetProjet?.id
        let project = Util.CleateProjectInstans(id: id!,nameText: nameText.text ?? ""
            , pgLangText: langText.text
            , placeText: placeText.text
            , priceText: priceText.text
            , lowerTimeText: lowerText.text
            , upperTimeText: upperText.text
            , stateText: stateText.text
            , noteText: memoText.text)
        
        DataAccess.update(updateObj: project)
    }
    
    //戻るボタン押下処理
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //プロジェクトが渡ってきた場合の処理
    func setProjcet(){
        nameText.text = targetProjet?.name
        langText.text = targetProjet?.pgLang
        placeText.text = targetProjet?.place
        if let price = targetProjet?.price.value{
            priceText.text = String(price)
        }
        if let lower = targetProjet?.lowerTime.value{
            lowerText.text = String(lower)
        }
        if let upper = targetProjet?.upperTime.value{
            upperText.text = String(upper)
        }
        stateText.text = targetProjet?.state
        memoText.text = targetProjet?.note
    }
    
    //pickerView
    var pickerView: UIPickerView = UIPickerView()
    let stateArray = ["新規","辞退","依頼","面談","失注","決定"]
    func pikerViewInit(){
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        
        let toolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: 0, height: 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem:.done,target: self, action: #selector(self.done))
        let cancelItem = UIBarButtonItem(barButtonSystemItem:.cancel,target: self, action: #selector(self.cancel))
        toolbar.setItems([cancelItem, doneItem], animated: true)
        
        self.stateText.inputView = pickerView
        self.stateText.inputAccessoryView = toolbar
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stateArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stateArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.stateText.text = stateArray[row]
    }
    
    func cancel() {
        self.stateText.text = ""
        self.stateText.endEditing(true)
    }
    
    func done() {
        self.stateText.endEditing(true)
    }
    
    //キーボード以外を触ったらキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
