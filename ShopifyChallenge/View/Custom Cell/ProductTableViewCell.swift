//
//  ProductTableViewCell.swift
//  ShopifyChallenge
//
//  Created by Ahmed Attia on 2019-01-20.
//  Copyright © 2019 Ahmed Attia. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
