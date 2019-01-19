//
//  ViewController.swift
//  ShopifyChallenge
//
//  Created by Ahmed Attia on 2019-01-18.
//  Copyright © 2019 Ahmed Attia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    //Constants
    let BASE_URL = "https://shopicruit.myshopify.com/admin/custom_collections.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mainCall()

    }
    
    func mainCall() {
        Alamofire.request(BASE_URL).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! We've got the weather data!")
                
                let shopifyJSON : JSON = JSON(response.result.value!)
                
                print(shopifyJSON)
            } else {
                print("Error: \(response.result.error!)")
            }
        }
    }


}

