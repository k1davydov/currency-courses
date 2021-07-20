//
//  CurrencyCell.swift
//  CurrencyCourses
//
//  Created by Kirill Davydov on 23.11.2020.
//

import UIKit

class CurrencyCell: UITableViewCell {
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var nameCell: UILabel!
    @IBOutlet weak var valueCell: UILabel!
    
    func initCell (currency: Currency) {
        if let currencyImage = currency.image {
            imageCell.image = currencyImage
        } else {
            imageCell.image = UIImage(named: "flagsImages/default")
        }
        nameCell.text = currency.Name
        valueCell.text = currency.Value
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
