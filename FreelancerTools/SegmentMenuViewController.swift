//
//  SegmentMenuViewController.swift
//  FreelancerTools
//
//  Created by matsuo on 2017/09/18.
//  Copyright © 2017年 matsuo. All rights reserved.
//

import UIKit
import PagingMenuController

class SegmentMenuViewController: UIViewController {
    private var genre_ids: [Int] = [0, 1]
    private var genre_names: [String] = ["案件管理", "マスタ管理"]
    override func viewDidLoad() {
        super.viewDidLoad()

        struct MenuItem: MenuItemViewCustomizable {
            var displayMode: MenuItemDisplayMode {
                let title = MenuItemText(text: name)
                return .text(title: title)
            }
            var name = "";
        }
        struct MenuOptions: MenuViewCustomizable {
            var itemsOptions: [MenuItemViewCustomizable] {
                var menuItems: Array<MenuItemViewCustomizable> = []
                for genre_name in genre_names {
                    let item:MenuItemViewCustomizable = MenuItem(name: genre_name)
                    menuItems.append(item)
                }
                return menuItems
            }
            var menuDisplayMode: MenuDisplayMode {
                return .segmentedControl
                // return .Standard(widthMode: .Flexible, centerItem: true, scrollingMode: .PagingEnabled)
            }
            var genre_names: [String] = []
        }
        struct PagingMenuOptions: PagingMenuControllerCustomizable {
            var componentType: ComponentType {
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                var viewControllers: Array<UIViewController> = []
                var key = 0
                
                //
                let viewController1 = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
                viewController1.title = genre_names[0]
                viewControllers.append(viewController1)
                key += 1
                
                //
                let viewController2 = storyboard.instantiateViewController(withIdentifier: "MenteMenuViewController") as! MenteMenuViewController
                viewController1.title = genre_names[1]
                viewControllers.append(viewController2)
                key += 1
                
                return .all(menuOptions: MenuOptions(genre_names:self.genre_names), pagingControllers: viewControllers)
            }
            var lazyLoadingPage: LazyLoadingPage {
                return .three
            }
            var genre_ids: [Int] = []
            var genre_names: [String] = []
        }
        let options = PagingMenuOptions(genre_ids:self.genre_ids, genre_names:self.genre_names)
        let pagingMenuController = PagingMenuController(options: options)
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMove(toParentViewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

