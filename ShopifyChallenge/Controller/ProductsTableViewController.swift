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
    //Will store data passed from the CollectionsViewController and will be used later on for networking
    var id = ""
    var collectionName = ""
    
    //Arrays will store names, images, and inventory of each product
    var productArray : [Product] = [Product]()
    var imageArray : [UIImage] = [UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getCollectionDetails(id: id)
        
        //TODO: Register your MessageCell.xib file here:
        productsTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "productTableViewCell")

    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource/Delegate Methods
    /**************************************************************/

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productTableViewCell", for: indexPath) as! ProductTableViewCell

         //Configure the cell using data from the global imageArray and productArray
        cell.productName.text = productArray[indexPath.row].nameOfProduct
        cell.collectionTitle.text = productArray[indexPath.row].collectionTitle
        cell.inventory.text = "Inventory: \(productArray[indexPath.row].inventoryTotal)"
        
        //Ensures that ArrayOutOfBounds Does not occur
        if imageArray.count >= productArray.count {
            cell.productImage.image = imageArray[indexPath.row]
        }

        return cell
    }
    
    //TODO: configureTableView
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80.0)
    }


    // MARK: - Networking
    /**************************************************************/
    
    //TODO: Declare getCollectionDetails here:
    func getCollectionDetails(id : String) {
            let params : [String : String] = ["collection_id" : id, "page" : "1", "access_token" : "c32313df0d0ef512ca64d5b336a0d7c6"]
            Alamofire.request(PRODUCT_URL, method: .get, parameters: params).responseJSON {
                response in
                if response.result.isSuccess {
                    print("Got the Collection Details!")
    
                    let collectionJSON : JSON = JSON(response.result.value!)
                    
                    //Array storing productIDS for each product in the collection
                    var arr = collectionJSON["collects"].arrayValue
                    
                    //This array will retrieve data about each product using the getProductDetails function and store in the global arrays productArray and imageArray
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
    
    //TODO: Declare getProductDetails here:
    func getProductDetails(params : [String : String]) {
        Alamofire.request(PRODUCT_DETAILS_URL, method: .get, parameters: params).responseJSON {
            (response) in
            if response.result.isSuccess {
                print("Got the Product Details!")
                
                let productJSON : JSON = JSON(response.result.value!)
                
                //Printing JSON data to the console to see format
                print(productJSON)
                
                //Initialzing a Product object will store the name, collection title, and inventory for every object.
                //Product object will be added to the global productArray
                let product = Product()
                product.nameOfProduct = productJSON["products"][0]["title"].stringValue
                product.collectionTitle = self.collectionName
                
                //Calculates total inventory across all variants of the product
                let variantsArray  = productJSON["products"][0]["variants"].arrayValue
                for number in (0...variantsArray.count-1) {
                    product.inventoryTotal += variantsArray[number]["inventory_quantity"].intValue
                }
                
                //Adds the product object to the global productArray
                self.productArray.append(product)
                
                //Passes the URL of the product image to the getProductImage
                let imageURL = productJSON["products"][0]["image"]["src"].stringValue
                self.getProductImage(imageURL: imageURL)
                
                //Testing to see if imageURL is valid and correctly saved
                print("imageURL: \(imageURL)")
                
            } else {
                print("Error: \(response.result.error!)")
            }
        }
    }
    
    //TODO: Declare getProductImage here:
    //Function will use imageURL to save and store image in the global imageArray
    func getProductImage(imageURL : String) {
        Alamofire.request(imageURL).responseData(completionHandler: { response in
            debugPrint(response)
            
            debugPrint(response.result)
            
            if let image1 = response.result.value {
                let image = UIImage(data: image1)
                self.imageArray.append(image!)
                
                //Now that all product has been retreived we can populate the tableView cells with the product data using this method
                self.productsTableView.reloadData()
            }
        })
    }
}
