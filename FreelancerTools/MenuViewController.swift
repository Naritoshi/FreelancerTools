//
//  MenuViewController.swift
//  FreelancerTools
//
//  Created by matsuo on 2017/09/15.
//  Copyright © 2017年 matsuo. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Test(_ sender: Any) {
        let pjEntryVC = EntryViewBaseController<Project>()
        pjEntryVC.backImage = #imageLiteral(resourceName: "pjent.jpg")
        present(pjEntryVC, animated: true, completion: nil)
    }

    @IBAction func moveProjcetList(_ sender: Any) {
        let pjListVC = ListViewBaseController<Project>()
        pjListVC.backImage = #imageLiteral(resourceName: "back.jpg")
        present(pjListVC, animated: true, completion: nil)
    }
    
}
