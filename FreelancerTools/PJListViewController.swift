//
//  PJListViewController.swift
//  FreelancerTools
//
//  Created by matsuo on 2017/07/30.
//  Copyright © 2017年 matsuo. All rights reserved.
//

import UIKit
import RealmSwift

class PJListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var projects:Results<Project>!
    
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
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let project = projects[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.layer.cornerRadius = 10.0
    
        //名前
        let nameLabel = cell.contentView.viewWithTag(1) as! UILabel
        nameLabel.text = project.name
        
        //言語名
        let langLabel = cell.contentView.viewWithTag(2) as! UILabel
        langLabel.text = project.pgLang
        
        //場所
        let placeLabel = cell.contentView.viewWithTag(3) as! UILabel
        placeLabel.text = project.place
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            let deleteProject = projects[indexPath.row]
            //削除処理
            DataAccess.delete(deleteObj: deleteProject)
            //再読み込み
            reloadTableView()
        }else if(editingStyle == .insert){
            
        }
    }
    
    //画面遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let project = projects[indexPath.row]
        //画面遷移
        performSegue(withIdentifier: "projectEntry", sender: project)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "projectEntry"{
            let pjEntryVC = segue.destination as! PJEntryViewController
            pjEntryVC.targetProjet = sender as? Project
            pjEntryVC.entryMode = .update
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func reloadTableView(){
        self.projects = DataAccess.selectAll()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
