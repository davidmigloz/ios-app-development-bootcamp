//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let BASE_URL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbols = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        getBitcoinPriceByCurrency(currency: currencyArray[currencyPicker.selectedRow(inComponent: 0)])
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        getBitcoinPriceByCurrency(currency: currencyArray[row])
    }
    
    func updateUIWithBitcoinPrice(price: Double) {
        bitcoinPriceLabel.text = "\(price) \(currencySymbols[currencyPicker.selectedRow(inComponent: 0)])"
    }
    
    //MARK: - Networking
    /***************************************************************/
    
    func getBitcoinPriceByCurrency(currency: String) {
        let url = BASE_URL + currency
        Alamofire.request(url, method: .get).responseJSON { response in
            switch response.result {
            case .success:
                self.parseBitcoinPrice(json: JSON(response.result.value!))
            case .failure(let error):
                print(error)
                self.bitcoinPriceLabel.text = "Connection issues!"
            }
        }
    }
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func parseBitcoinPrice(json : JSON) {
        if let price = json["last"].double {
            updateUIWithBitcoinPrice(price: price)
        }
    }
}
