//
//  CoursesController.swift
//  CurrencyCourses
//
//  Created by Kirill Davydov on 29.10.2020.
//

import UIKit

class CoursesController: UITableViewController {

    @IBAction func pushRefresh(_ sender: Any) {
        Model.shared.loadXMLData(date: nil)
        navigationItem.title = Model.shared.currentDate
    }
    
    @IBOutlet weak var navigationButton: UIButton!
    
    @IBAction func pushNavigationButton(_ sender: Any) {
        let nc = storyboard?.instantiateViewController(identifier: "selectedDateSBID") as! UINavigationController
        nc.modalPresentationStyle = .fullScreen
        present(nc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "StartLoading"), object: nil, queue: nil) { (notification) in
            DispatchQueue.main.async {
                let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
                activityIndicator.startAnimating()
                activityIndicator.color = UIColor.blue
                self.navigationItem.rightBarButtonItem?.customView = activityIndicator
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "FinishLoading"), object: nil, queue: nil) { (notification) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationButton.setTitle(Model.shared.currentDate, for: UIControl.State.normal)
                let barButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(self.pushRefresh(_:)))
                self.navigationItem.rightBarButtonItem = barButtonItem
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "ErrorWhenLoadingXML"), object: nil, queue: nil) { (notification) in
            let errorName = notification.userInfo!["ErrorName"]
            print(errorName!)
            
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Ошибка", message: "Ошибка при загрузке данных: \n\(errorName!)", preferredStyle: UIAlertController.Style.alert)
                
                let cancelButton = UIAlertAction(title: "Отмена", style: UIAlertAction.Style.cancel, handler: nil)
                
                alert.addAction(cancelButton)
                
                self.present(alert, animated: true, completion: nil)
                
                let barButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(self.pushRefresh(_:)))
                self.navigationItem.rightBarButtonItem?.customView = barButtonItem.customView
            }
        }
        
        if Model.shared.currentDate != "" {
            navigationButton.setTitle(Model.shared.currentDate, for: UIControl.State.normal)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        navigationButton.setTitle(dateFormatter.string(from: Date()), for: UIControl.State.normal)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.shared.currencies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CurrencyCell

        let courseForCell = Model.shared.currencies[indexPath.row]
        cell.initCell(currency: courseForCell)

        return cell
    }
}
