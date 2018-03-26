//
//  item.swift
//  ToBuyApp
//
//  Created by Jonathan Compton on 3/20/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import Foundation
import UIKit

class Item {
    var title: String
    var price: Double
    var image: UIImage
    var details: String
    let dateCreated : NSDate
    var doneImage : UIImage? = nil
    var done = false {
        didSet{
            if doneImage == nil {
                doneImage = UIImage(named: "complete.png")
            } else {
                doneImage = nil
            }
        }
    }

    
    
    init(title: String, price: String, image: UIImage, details: String) {
        self.title = title
        self.price = Double(price)!
        self.image = image
        self.details = details
        self.dateCreated = NSDate()

    }
    
    func stringPrice() -> String {
        var stringPrice = "$\(price)"
        if price.truncatingRemainder(dividingBy: 1.0) == 0 {
            stringPrice += "0"
        }
        return stringPrice
    }
    
    func toggleCompete(){
        done = !done
    }
}
