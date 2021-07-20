//
//  SettingController.swift
//  CurrencyCourses
//
//  Created by Kirill Davydov on 30.10.2020.
//

import UIKit

class SettingController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func pushUpdateCourses(_ sender: Any) {
        Model.shared.loadXMLData(date: datePicker.date)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
