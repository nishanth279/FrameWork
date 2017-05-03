//
//  ViewController.swift
//  StatesInformation
//
//  Created by Kuninti, Nishanth on 4/4/17.
//  Copyright © 2017 Kuninti, Nishanth. All rights reserved.
//

import UIKit
import StatesListCell

class ViewController: UIViewController {
    
    var statesList:NSArray?
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.tableView.register(UINib(nibName: "StatesListCell", bundle: Bundle(for: StatesListCell.self)), forCellReuseIdentifier: "statesListCell")
        
        let url = "http://services.groupkt.com/state/get/USA/all"
        StatesNetworkServices.fetchStatesList(urlString: url) { (responseData) in
            let responseData = responseData as! NSDictionary
            let response = responseData["RestResponse"] as! NSDictionary
            let statesList = response["result"] as! NSArray
            self.statesList = statesList
            self.tableView.reloadData()
        }
    }
    
}


extension ViewController : UITableViewDataSource {
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : StatesListCell = tableView.dequeueReusableCell(withIdentifier: "statesListCell", for: indexPath) as! StatesListCell
        
        if let statesList = self.statesList {
            let valuesForCell = statesList[indexPath.row] as! NSDictionary
            cell.countryValueLabel.text = valuesForCell["country"] as? String
            cell.stateNameLabel.text = valuesForCell["name"] as? String
            cell.abbrevationValueLabel.text = valuesForCell["abbr"] as? String
            
            if let areaInKMS = valuesForCell["area"] as? String {
                if let areaInMiles = String.convertKMSToMiles(kms: areaInKMS)  {
                    cell.areaValueLabel.text = areaInMiles //valuesForCell["area"] as? String
                }
            }
            
            cell.capitalValueLabel.text = valuesForCell["capital"] as? String
            
            if let largestCity = valuesForCell["largest_city"] as? String {
                cell.largestCityValueLabel.text = largestCity
            } else {
                cell.largestCityValueLabel.text = "--"
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let statesList = self.statesList {
            return statesList.count
        } else {
            return 0
        }
    }
}


extension String {
    static func convertKMSToMiles(kms:String) -> String? {
        let result = String(kms.characters.filter { String($0).rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789")) != nil })
        
        if let kmValue = Double(result) {
            let mileValue = (kmValue/1.6)
            return "\(mileValue)" + "mi"
        }
        
        return nil
    }
}


