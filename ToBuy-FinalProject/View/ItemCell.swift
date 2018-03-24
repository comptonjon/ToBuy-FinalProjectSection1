//
//  ItemCell.swift
//  ToBuyApp
//
//  Created by Jonathan Compton on 3/20/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import UIKit
import AVFoundation

class ItemCell: UITableViewCell {

    @IBOutlet weak var contentContainerView: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemDetailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //contentContainerView.backgroundColor = UIColor.lightGray
    }

 

}
