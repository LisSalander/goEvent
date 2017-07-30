//
//  MenuView.swift
//  goEventS
//
//  Created by vika on 6/15/17.
//  Copyright © 2017 VikaMaksymuk. All rights reserved.
//

import UIKit

class MenuView: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuTable: UITableView!
    var tableArray = ["Головна","Список подій","Карта","Збережені","Вхід",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTable.delegate = self
        menuTable.dataSource = self
       // tableArray = ["Головна","Список подій","Карта","Збережені","Вхід",""]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: tableArray[indexPath.row], for: indexPath)
        
        cell.textLabel?.text = tableArray[indexPath.row]
        return cell
    }
}
