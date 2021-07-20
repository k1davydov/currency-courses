//
//  ConverterController.swift
//  CurrencyCourses
//
//  Created by Kirill Davydov on 20.11.2020.
//

import UIKit

class ConverterController: UIViewController {

    @IBOutlet weak var labelCoursesForDate: UILabel!
    
    @IBOutlet weak var buttonFrom: UIButton!
    
    @IBAction func buttonReplace(_ sender: Any) {
//        let change = Model.shared.fromCurrency
//        Model.shared.fromCurrency = Model.shared.toCurrency
//        Model.shared.toCurrency = change
//        let changeButton = Model.shared.fromCurrency.CharCode
//        buttonFrom.setTitle(Model.shared.toCurrency.CharCode, for: UIControl.State.normal)
//        buttonTo.setTitle(changeButton, for: UIControl.State.normal)
//        self.viewDidLoad()
    }
    
    @IBAction func pushButtonFrom(_ sender: Any) {
        let nc = storyboard?.instantiateViewController(identifier: "selectedCurrencySBID") as! UINavigationController
        nc.modalPresentationStyle = .fullScreen
        (nc.viewControllers[0] as! SelectCurrencyController).flagCurrency = .from
        present(nc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var buttonTo: UIButton!
    
    @IBAction func pushButtonTo(_ sender: Any) {
        let nc = storyboard?.instantiateViewController(identifier: "selectedCurrencySBID") as! UINavigationController
        nc.modalPresentationStyle = .fullScreen
        (nc.viewControllers[0] as! SelectCurrencyController).flagCurrency = .to
        present(nc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBAction func doneButtonAction(_ sender: Any) {
        textFrom.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
    }
    
    @IBOutlet weak var textFrom: UITextField!
    
    @IBOutlet weak var textTo: UITextField!
    
    @IBAction func textFromEditing(_ sender: Any) {
        let amount = Double(textFrom.text!)
        textTo.text = Model.shared.convert(amount: amount)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFrom.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshButtons()
        textFromEditing(self)
        labelCoursesForDate.text = "Курсы за дату: \(Model.shared.currentDate)"
        navigationItem.rightBarButtonItem = nil
    }
    
    func refreshButtons () {
        buttonFrom.setTitle(Model.shared.fromCurrency.CharCode, for: UIControl.State.normal)
        buttonTo.setTitle(Model.shared.toCurrency.CharCode, for: UIControl.State.normal)
    }
}
extension ConverterController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        navigationItem.rightBarButtonItem = doneButton
        return true
    }
}
