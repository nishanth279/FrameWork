//
//  StatesNetworkServices.swift
//  StatesInformation
//
//  Created by Kuninti, Nishanth on 4/4/17.
//  Copyright © 2017 Kuninti, Nishanth. All rights reserved.
//

import Foundation


class StatesNetworkServices: NSObject {
    
    class func fetchStatesList(urlString: String, completionHandler:@escaping (_ responseDate:AnyObject) -> Void) {
        
        if let url : URL = URL(string: urlString) {
            let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
            request.timeoutInterval = 120
            var responseData : AnyObject?
            let dataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
                
                guard data != nil else {
                    print("data not found")
                    return
                }
                
                do {
                    responseData = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    DispatchQueue.main.async {
                        completionHandler(responseData!)
                    }
                } catch {
                    print(error)
                }
                
            })
            
            dataTask.resume()
        } else {
            print("URL Error")
        }
    }
}

