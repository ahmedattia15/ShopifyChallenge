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
    let PRODUCT_DETAILS_URL = "https://shopicruit.myshopify.com/admin/products.json?"
    var id = ""
    var collectionName = ""
    var productArray : [Product] = [Product]()
    var imageArray : [UIImage] = [UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCollectionDetails(id: id)
        
        //TODO: Register your MessageCell.xib file here:
        productsTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "productTableViewCell")
        
        //productsTableView.reloadData()
        
        
        
        //configureTableView()
        
        //print(productArray[0].nameOfProduct)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productTableViewCell", for: indexPath) as! ProductTableViewCell

         //Configure the cell...
        cell.productName.text = productArray[indexPath.row].nameOfProduct
        cell.collectionTitle.text = productArray[indexPath.row].collectionTitle
        cell.inventory.text = "Inventory: \(productArray[indexPath.row].inventoryTotal)"
        
        if imageArray.count >= productArray.count {
            cell.productImage.image = imageArray[indexPath.row]
        }

        return cell
    }
    
    //TODO: configureTableView
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80.0)
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
                    
                    var arr = collectionJSON["collects"].arrayValue
                    
                    for number in (0...arr.count-1) {
                        let params : [String : String] = ["ids" : arr[number]["product_id"].stringValue, "page" : "1", "access_token" : "c32313df0d0ef512ca64d5b336a0d7c6"]
                        self.getProductDetails(params: params)
                    }
    
                    print(collectionJSON)
                } else {
                    print("Error: \(response.result.error!)")
                }
            }
        }
    
    func getProductDetails(params : [String : String]) {
        Alamofire.request(PRODUCT_DETAILS_URL, method: .get, parameters: params).responseJSON {
            (response) in
            if response.result.isSuccess {
                print("Got the Product Details!")
                
                let productJSON : JSON = JSON(response.result.value!)
                
                print(productJSON)
                
                let product = Product()
                product.nameOfProduct = productJSON["products"][0]["title"].stringValue
                product.collectionTitle = self.collectionName
                
                let variantsArray  = productJSON["products"][0]["variants"].arrayValue
                for number in (0...variantsArray.count-1) {
                    product.inventoryTotal += variantsArray[number]["inventory_quantity"].intValue
                }
                self.productArray.append(product)
                
                let imageURL = productJSON["products"][0]["image"]["src"].stringValue
                
                self.getProductImage(imageURL: imageURL)
                
                print("imageURL: \(imageURL)")
                
                
            } else {
                print("Error: \(response.result.error!)")
            }
        }
    }
    
    func getProductImage(imageURL : String) {
        Alamofire.request(imageURL).responseData(completionHandler: { response in
            debugPrint(response)
            
            debugPrint(response.result)
            
            if let image1 = response.result.value {
                let image = UIImage(data: image1)
                self.imageArray.append(image!)
                //self.configureTableView()
                self.productsTableView.reloadData()
            }
        })
    }
}
