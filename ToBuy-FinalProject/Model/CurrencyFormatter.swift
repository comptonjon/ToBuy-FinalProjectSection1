//
//  CurrencyFormatter.swift
//  ToBuy-FinalProject
//
//  Created by Jonathan Compton on 3/25/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import Foundation

class CurrencyFormatter: NumberFormatter {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
        override init(){
            super.init()
            self.locale = NSLocale.current
            self.maximumFractionDigits = 2
            self.minimumFractionDigits = 2
            self.alwaysShowsDecimalSeparator = true
            self.numberStyle = .currency
        }
        
        static let sharedInstance = CurrencyFormatter()
        
        
    
}
