//
//  SearchModalDelegate.swift
//  FreelancerTools
//
//  Created by matsuo on 2017/09/20.
//  Copyright © 2017年 matsuo. All rights reserved.
//

import Foundation
import RealmSwift

//検索用画面から選択結果を受け取るためのデリゲート
protocol SearchModalDelegate {
    func selectedObject(object: Object)
}
