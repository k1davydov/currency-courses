//
//  Model.swift
//  CurrencyCourses
//
//  Created by Kirill Davydov on 29.10.2020.
//

import UIKit

class Currency {
    var NumCode: String?
    var CharCode: String?
    var Nominal: String?
    var nominalDouble: Double?
    var Name: String?
    var Value: String?
    var valueDouble: Double?
    var image: UIImage? {
        if let image = UIImage(named: CharCode ?? "") {
            return image
        }
        return UIImage(named: "default")
    }
    
    class func rouble () -> Currency {
        let r = Currency()
        r.CharCode = "RUR"
        r.Nominal = "1"
        r.nominalDouble = 1
        r.Name = "Российский рубль"
        r.Value = "1"
        r.valueDouble = 1
        
        return r
    }
}

class Model: NSObject, XMLParserDelegate {
    static let shared = Model()
    
    var currencies: [Currency] = []
    var currentDate: String = ""
    
    var fromCurrency: Currency = Currency.rouble()
    var toCurrency: Currency = Currency.rouble()
    
    func convert(amount: Double?) -> String {
        if amount == nil {
            return ""
        }
        
        let d = (fromCurrency.nominalDouble! * fromCurrency.valueDouble!) / (toCurrency.nominalDouble! * toCurrency.valueDouble!) * amount!
        
        return String(d)
    }
    
    var pathForXML: String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/data.xml"
        if FileManager.default.fileExists(atPath: path) {
            return path
        }
        return Bundle.main.path(forResource: "data", ofType: "xml")!
    }
    
    var urlForXML: URL {
        return URL(fileURLWithPath: pathForXML)
    }
    
//    загрузка XML c  cbr.ru и сохранение
    func loadXMLData(date: Date?) {
        var strURL = "http://www.cbr.ru/scripts/XML_daily.asp?date_req="
            
        if date != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            currentDate = dateFormatter.string(from: date!)
            strURL = strURL + currentDate
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let now = Date()
            currentDate = dateFormatter.string(from: now)
            strURL = strURL + currentDate
        }
        let url = URL(string: strURL)
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            var errorGloval: String?
            
            if error == nil {
                let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/data.xml"
                let URLForSave = URL(fileURLWithPath: path)
                
                do {
                    try data?.write(to: URLForSave)
                    print("Файл загружен")
                    self.parseXML()
                } catch {
                    print("Error wnen save data:\(error.localizedDescription)")
                    errorGloval = error.localizedDescription
                }
            } else {
                print("Error when download XML:"+error!.localizedDescription)
                errorGloval = error?.localizedDescription
            }
            
            if let errorGloval = errorGloval {
                NotificationCenter.default.post(name: NSNotification.Name("ErrorWhenLoadingXML"), object: self, userInfo: ["ErrorName" : errorGloval])
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StartLoading"), object: self )
        
        task.resume()
    }
    
//    парсим XML в currencies: [Currency] и отправляем уведомление приложению (данные обновлены)
    func parseXML () {
        currencies = [Currency.rouble() ]
        let parser = XMLParser(contentsOf: urlForXML)
        parser?.delegate = self
        parser?.parse()
        
        print("Данные обновлены")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FinishLoading"), object: self )
        for c in currencies {
            if c.CharCode == fromCurrency.CharCode {
                fromCurrency = c
            }
            if c.CharCode == toCurrency.CharCode {
                toCurrency = c
            }
        }
    }
    
    var currentCurrency: Currency?
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "Valute" {
            currentCurrency = Currency()
        }
    }
    
    var currentCharacters: String = ""
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentCharacters = string
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "Valute":
            currencies.append(currentCurrency!)
        case "NumCode":
            currentCurrency?.NumCode = currentCharacters
        case "CharCode":
            currentCurrency?.CharCode = currentCharacters
        case "Nominal":
            currentCurrency?.Nominal = currentCharacters
            currentCurrency?.nominalDouble = Double(currentCharacters.replacingOccurrences(of: ",", with: "."))
        case "Name":
            currentCurrency?.Name = currentCharacters
        case "Value":
            currentCurrency?.Value = currentCharacters
            currentCurrency?.valueDouble = Double(currentCharacters.replacingOccurrences(of: ",", with: "."))
        default:
            return ()
        }
    }
}
