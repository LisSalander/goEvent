//
//  CustomDateView.swift
//  goEventS
//
//  Created by vika on 10/11/17.
//  Copyright © 2017 VikaMaksymuk. All rights reserved.
//

import UIKit

class CustomDateView: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var controllerOutlet: UISegmentedControl!
    
    let formatter = DateFormatter()
    var fromDate = String()
    var toDate = String()
    var datePickerData = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        formatter.dateFormat = "MMMM dd yyyy"
        datePickerData = formatter.string(from: datePicker.date)
        fromDate = datePickerData
        toDate = datePickerData

        loadDate()
    }
    
    @IBAction func selectedDate(_ sender: Any) {
        
        loadDate()
        
    }
    
    @IBAction func dismissPopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func canselButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func segmentedController(_ sender: Any) {
        
        formatter.dateFormat = "MMMM dd yyyy"
        
        if controllerOutlet.selectedSegmentIndex == 0{
            
            dateLabel.text = fromDate
            datePicker.date = formatter.date(from: fromDate)!
            
        }
        if controllerOutlet.selectedSegmentIndex == 1{
            
            dateLabel.text = toDate
            datePicker.date = formatter.date(from: toDate)!
        }
 
    }
    
    func loadDate() {
        
        formatter.dateFormat = "MMMM dd yyyy"
        dateLabel.text = formatter.string(from: datePicker.date)

        if controllerOutlet.selectedSegmentIndex == 0{
            fromDate = formatter.string(from: datePicker.date)
            print(fromDate)
        }
        if controllerOutlet.selectedSegmentIndex == 1{
            toDate = formatter.string(from: datePicker.date)
            print(toDate)
        }
    }
    
}
