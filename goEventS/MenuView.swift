//
//  MenuView.swift
//  goEventS
//
//  Created by vika on 7/30/17.
//  Copyright © 2017 VikaMaksymuk. All rights reserved.
//

import UIKit

class MenuView: UIViewController{
    
    //var nameCellArray = [String]()

   // @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // nameCellArray = ["main","event list","map"]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = nameCellArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            // ContainerVC.swift listens for this
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openModalWindow"), object: nil)
        case 1:
            // Both FirstViewController and SecondViewController listen for this
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openPushWindow"), object: nil)
        default:
            print("indexPath.row:: \(indexPath.row)")
        }
    }*/
    
}
