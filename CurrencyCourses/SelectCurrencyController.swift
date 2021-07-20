//
//  SelectCurrencyController.swift
//  CurrencyCourses
//
//  Created by Kirill Davydov on 23.11.2020.
//

import UIKit

enum FlagCurrencySelected {
    case from
    case to
}

class SelectCurrencyController: UITableViewController {
    
    var flagCurrency: FlagCurrencySelected = .from
    
    @IBAction func pushCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.shared.currencies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let currentCurrency: Currency = Model.shared.currencies[indexPath.row]
        cell.textLabel?.text = currentCurrency.Name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCurrency: Currency = Model.shared.currencies[indexPath.row]
        switch flagCurrency {
        case .from:
            Model.shared.fromCurrency = selectedCurrency
        case .to:
            Model.shared.toCurrency = selectedCurrency
        }
        
        dismiss(animated: true, completion: nil)
    }
}
