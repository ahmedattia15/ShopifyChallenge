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

class CollectionsViewController: UITableViewController {
    
    @IBOutlet var collectionsTableView: UITableView!
    //Constants
    let BASE_URL = "https://shopicruit.myshopify.com/admin/custom_collections.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
    let PRODUCT_URL = "https://shopicruit.myshopify.com/admin/collects.json?"
    var collections : [String] = [String]()
    var collectionIDs 

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Register your MessageCell.xib file here:
        collectionsTableView.register(UINib(nibName: "DisplayCell", bundle: nil), forCellReuseIdentifier: "displayCell")
        
        //configureTableView()
        configureTableView()
        
        getCustomCollectionList()
        

    }
    
    
    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "displayCell", for: indexPath) as! CustomDisplayCell
        
        cell.nameOfCollection.text = collections[indexPath.row]
        
        return cell
    }
    
    //TODO: Declare numberOfRowsInSection here:
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    
    //TODO: configureTableView
    func configureTableView() {
        collectionsTableView.rowHeight = UITableView.automaticDimension
        collectionsTableView.estimatedRowHeight = 120.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    
    //MARK: - Networking
    /**************************************************************/
    
    //Calling the main API with Custom Collections List
    func getCustomCollectionList() {
        Alamofire.request(BASE_URL).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! We've got the weather data!")
                
                let shopifyJSON : JSON = JSON(response.result.value!)
                
                print(shopifyJSON)
                
                let arr = shopifyJSON["custom_collections"].arrayValue
                
                //Creating an array
                for number in (0...(arr.count-1)) {
                    self.collections.append(arr[number]["title"].stringValue)
                    print(self.collections[number])
                }
                
                self.configureTableView()
                self.collectionsTableView.reloadData()
                
                //let params : [String : String] = ["collection_id" : collectionID, "page" : "1", "access_token" : "c32313df0d0ef512ca64d5b336a0d7c6"]
                
//                self.getCollectionDetails(Params: params)
                
            } else {
                print("Error: \(response.result.error!)")
            }
        }
    }
    
//    func getCollectionDetails(Params : [String : String]) {
//        Alamofire.request(PRODUCT_URL, method: .get, parameters: Params).responseJSON {
//            response in
//            if response.result.isSuccess {
//                print("Got the Collection Details!")
//
//                let collectionJSON : JSON = JSON(response.result.value!)
//
//                print(collectionJSON)
//            } else {
//                print("Error: \(response.result.error!)")
//            }
//        }
//    }
    
    func getProductDetails(Params : [String : String]) {
        
    }


}

