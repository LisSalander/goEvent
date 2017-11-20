//
//  CustomDateView.swift
//  goEventS
//
//  Created by vika on 10/11/17.
//  Copyright © 2017 VikaMaksymuk. All rights reserved.
//

import UIKit

class CustomDateView: UIViewController{

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var controllerOutlet: UISegmentedControl!
    
    let formatter = DateFormatter()
    static var fromDate = Date()
    static var toDate = Date()
    var datePickerData = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        CustomDateView.fromDate = datePicker.date
        CustomDateView.toDate = datePicker.date

        loadDate()
    }
    
    @IBAction func selectedDate(_ sender: Any) {
        
        loadDate()
        
    }
    
    @IBAction func okButton(_ sender: Any) {

       // let eventList = self.storyboard?.instantiateViewController(withIdentifier: "eventList") as! EventList
       // eventList.startDate = fromDate
        //eventList.endDate = toDate
        //self.navigationController?.pushViewController(eventList, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
       dismiss(animated: true, completion: nil)

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
            
            /*dateLabel.text = fromDate
            datePicker.date = formatter.date(from: fromDate)!*/
            dateLabel.text = formatter.string(from: CustomDateView.fromDate)
            datePicker.date = CustomDateView.fromDate
            
        }
        if controllerOutlet.selectedSegmentIndex == 1{
            
            dateLabel.text = formatter.string(from: CustomDateView.toDate)
            datePicker.date = CustomDateView.toDate
        }
 
    }

    
    func loadDate() {
        
        formatter.dateFormat = "MMMM dd yyyy"
        dateLabel.text = formatter.string(from: datePicker.date)

        if controllerOutlet.selectedSegmentIndex == 0{
            //fromDate = formatter.string(from: datePicker.date)
            CustomDateView.fromDate = datePicker.date
            print(CustomDateView.fromDate)
        }
        if controllerOutlet.selectedSegmentIndex == 1{
            CustomDateView.toDate = datePicker.date
            print(CustomDateView.toDate)
        }
    }
    
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EventList {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM dd yyyy"
            let start  = fromDate
            let end = dateFormatter.date(from: toDate)!
            destination.startDate = start
            destination.endDate = end
        }
    }*/
}
