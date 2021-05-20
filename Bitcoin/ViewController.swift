//
//  ViewController.swift
//  Bitcoin
//
//  Created by user191390 on 5/18/21.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK:- Outlets
    
    @IBOutlet weak var PriceLabel: UILabel!
    
    @IBOutlet weak var CurrencyPV: UIPickerView!
    
    //MARK:- Variables
    
    let apiKey = "Y2IzZDUyYzQ0OTIzNGU0Y2FiMzZlMWU1NjZiYTQ5NDk"
    let curruncies = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let baseUrl = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCAUD"
    
    
    //var url = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC\(curruncies[row])"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CurrencyPV.delegate = self
        CurrencyPV.dataSource = self
        
        fetchData(url: baseUrl)
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // retorno o numero de moedas para fazer a conversao.
        return curruncies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let url = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC\(curruncies[row])"
        fetchData(url: url)
        
        // retorna o titulo para a selacao
        return curruncies[row]
    }
    
    func formatNumberToDecimal(value:Double) -> String {
        let numberFormatter = NumberFormatter()

        // Atribuindo o locale desejado
        numberFormatter.locale = Locale(identifier: "pt_BR")

        // Importante para que sejam exibidas as duas casas após a vírgula
        numberFormatter.minimumFractionDigits = 2

        numberFormatter.numberStyle = .decimal

        return numberFormatter.string(from: NSNumber(value:value)) ?? "Valor indefinido"
    }
    
    func parseJSON(json: Data) {
        
        do {
            
            if let json = try JSONSerialization.jsonObject(with: json, options: .mutableContainers) as? [String: Any] {
                print(json)
                if let askValue = json["ask"] as? NSNumber {
                    print(askValue)
                    
                    let askvalueString = "\(askValue)"
                    DispatchQueue.main.async {
                        
                        self.PriceLabel.text = self.formatNumberToDecimal(value: Double(askvalueString)!) 
                   }
                    print("success")
                    
                }  } else {
                    print("error")
                   }
            
        } catch {
                    
                    print("error parsing json: \(error)")
                }
    }
    
    func fetchData(url: String) {
        
        let url = URL(string: url)!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        request.addValue(apiKey, forHTTPHeaderField: "x-ba-key")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data{
                //let data = String (data: data, encoding: .utf8)
                self.parseJSON(json: data)
                
            }else{
                print("error")
            }
            
        }
        
        task.resume()
    }
}
