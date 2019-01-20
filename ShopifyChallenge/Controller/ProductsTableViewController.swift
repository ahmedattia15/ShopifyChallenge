//
//  ProductsTableViewController.swift
//  ShopifyChallenge
//
//  Created by Ahmed Attia on 2019-01-20.
//  Copyright © 2019 Ahmed Attia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProductsTableViewController: UITableViewController {
    
    @IBOutlet var productsTableView: UITableView!
    
    //Constants
    let PRODUCT_URL = "https://shopicruit.myshopify.com/admin/collects.json?"
    var id = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Register your MessageCell.xib file here:
        productsTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "productTableViewCell")
        
        configureTableView()
        
        getCollectionDetails(id: id)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productTableViewCell", for: indexPath) as! ProductTableViewCell

         //Configure the cell...

        return cell
    }
    
    //TODO: configureTableView
    func configureTableView() {
        productsTableView.rowHeight = UITableView.automaticDimension
        productsTableView.estimatedRowHeight = 120.0
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    //}
    
    // MARK: - Delegate Methods
    func getCollectionDetails(id : String) {
            let params : [String : String] = ["collection_id" : id, "page" : "1", "access_token" : "c32313df0d0ef512ca64d5b336a0d7c6"]
            Alamofire.request(PRODUCT_URL, method: .get, parameters: params).responseJSON {
                response in
                if response.result.isSuccess {
                    print("Got the Collection Details!")
    
                    let collectionJSON : JSON = JSON(response.result.value!)
    
                    print(collectionJSON)
                } else {
                    print("Error: \(response.result.error!)")
                }
            }
        }
}
