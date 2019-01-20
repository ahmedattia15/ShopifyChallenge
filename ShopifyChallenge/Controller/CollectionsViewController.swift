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
import ChameleonFramework

class CollectionsViewController: UITableViewController {
    
    @IBOutlet var collectionsTableView: UITableView!
    //Constants and Variables
    let colourArray : [UIColor] = [UIColor.flatRed(), UIColor.flatBlue()]
    let BASE_URL = "https://shopicruit.myshopify.com/admin/custom_collections.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
    //Will store the JSON data corresponding to each list
    var collections : [JSON] = [JSON]()
    //These variables will be passed to the ProductsTableViewController to retrieve product data.
    var ID = ""
    var collectionName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Register your MessageCell.xib file here:
        collectionsTableView.register(UINib(nibName: "DisplayCell", bundle: nil), forCellReuseIdentifier: "displayCell")
        
        //configureTableView() called to change size of the TableViewCells
        configureTableView()
        
        //Networking call to get name of collections which will populate the tableView cells
        getCustomCollectionList()
        

    }
    
    
    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    /**************************************************************/
    //TODO: Declare cellForRowAtIndexPath here:
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "displayCell", for: indexPath) as! CustomDisplayCell
        
        cell.backgroundColor = UIColor.flatWhite()
        
        //Retrieving name of each collections from the collections JSON array
        cell.nameOfCollection.text = collections[indexPath.row]["title"].stringValue
        
        return cell
    }
    
    //TODO: Declare numberOfRowsInSection here:
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    
    //TODO: configureTableView
    func configureTableView() {
        collectionsTableView.rowHeight = UITableView.automaticDimension
        collectionsTableView.estimatedRowHeight = 200.0
    }
    
    //TODO: Declare didSelectRowAt here:
    //Will be used to perform a segue to the ProductsTableView controller and send it the relevant data for retreiving product data
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ID = collections[indexPath.row]["id"].stringValue
        collectionName = collections[indexPath.row]["title"].stringValue
        performSegue(withIdentifier: "goToProducts", sender: self)
    }
    
    //MARK: - Segue Methods
    /**************************************************************/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let secondVC = segue.destination as! ProductsTableViewController
        secondVC.id = ID
        secondVC.collectionName = collectionName
    }
    
    
    //MARK: - Networking
    /**************************************************************/
    
    //Calling the main API for Custom Collections List
    func getCustomCollectionList() {
        Alamofire.request(BASE_URL).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! We've got the weather data!")
                
                let shopifyJSON : JSON = JSON(response.result.value!)
                
                //Testing to see the format of JSON
                print(shopifyJSON)
                
                //Set global array collections equal to custom_collections JSON. This array contains the name of each collection.
                self.collections = shopifyJSON["custom_collections"].arrayValue
                
                //Update cells with the name of the collections
                self.configureTableView()
                self.collectionsTableView.reloadData()
                
            } else {
                print("Error: \(response.result.error!)")
            }
        }
    }
}

