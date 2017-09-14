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

    var tableView: UITableView!
    
    //
    var cellIdentifier = "Cell"
    var entryIdentifier = "projectEntry"
    var seachIdntifier = "projectSeach"
    
    //検索結果
    var objects:Results<T>!
    //検索条件
    var searchKey:T = T()
    var orderKey = "id"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTableView()
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let project = objects[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.layer.cornerRadius = 10.0
        
        cellCreate(cell: cell)
        
        return cell
    }
    
    func cellCreate(cell: UITableViewCell){
        //継承先で記載
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
        performSegue(withIdentifier: entryIdentifier, sender: object)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == entryIdentifier{
            let pjEntryVC = segue.destination as! PJEntryViewController
            pjEntryVC.targetProjet = sender as? Project
            pjEntryVC.entryMode = .update
        }else if segue.identifier == seachIdntifier{
            let pjEntryVC = segue.destination as! PJEntryViewController
            //pjEntryVC.targetProjet = searchKey
            pjEntryVC.entryMode = .seach
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func reloadTableView(){
        let predicate = Util.CreatePredicate(object: searchKey)
        self.objects = DataAccess.select(predicate: predicate ,orderKey: orderKey)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
