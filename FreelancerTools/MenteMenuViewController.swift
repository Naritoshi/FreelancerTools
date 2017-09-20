//
//  MenteMenuViewController.swift
//  FreelancerTools
//
//  Created by matsuo on 2017/09/18.
//  Copyright © 2017年 matsuo. All rights reserved.
//

import UIKit

class MenteMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //会社
    @IBAction func moveCompanyEntry(_ sender: Any) {
        let cmEntryVC = EntryViewBaseController<Company>()
        cmEntryVC.backImage = #imageLiteral(resourceName: "pjent.jpg")
        present(cmEntryVC, animated: true, completion: nil)
    }

    @IBAction func moveCompanyList(_ sender: Any) {
        let cmListVC = ListViewBaseController<Company>()
        cmListVC.backImage = #imageLiteral(resourceName: "back.jpg")
        present(cmListVC, animated: true, completion: nil)
    }
    
    //営業
    @IBAction func moveAgentEntry(_ sender: Any) {
        let arEntryVC = EntryViewBaseController<Agent>()
        arEntryVC.backImage = #imageLiteral(resourceName: "pjent.jpg")
        present(arEntryVC, animated: true, completion: nil)
    }
    
    @IBAction func moveAgentList(_ sender: Any) {
        let arListVC = ListViewBaseController<Agent>()
        arListVC.backImage = #imageLiteral(resourceName: "back.jpg")
        present(arListVC, animated: true, completion: nil)
    }

}
