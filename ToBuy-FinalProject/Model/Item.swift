//
//  item.swift
//  ToBuyApp
//
//  Created by Jonathan Compton on 3/20/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import Foundation
import UIKit

class Item: Equatable {
    
    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.title == rhs.title && lhs.price == rhs.price && lhs.details == rhs.details
    }
    
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
        if price == "" {
            self.price = 0
        } else {
            self.price = Double(price)!
        }
        self.price = Double(price)!
        self.image = image
        self.details = details
        self.dateCreated = NSDate()

    }
    

    
    //Return NSNumber to for formatting in CurrencyFormatter
    func nsPrice() -> NSNumber {
        return NSNumber(value: price)
    }
}
