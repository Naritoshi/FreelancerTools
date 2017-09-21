//
//  SearchTableViewController.swift
//  FreelancerTools
//
//  Created by matsuo on 2017/09/19.
//  Copyright © 2017年 matsuo. All rights reserved.
//

import UIKit
import RealmSwift

class SearchTableViewController<T:Object>: ListViewBaseController<T> {
    var delegate: SearchModalDelegate?
    
    override func viewDidLoad() {
        backImage = #imageLiteral(resourceName: "back")
        super.viewDidLoad()
    }
    //画面遷移
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = self.delegate {
            delegate.selectedObject(object: objects[indexPath.row])
        }
        //画面遷移
        self.dismiss(animated: true, completion: nil)
    }
}
