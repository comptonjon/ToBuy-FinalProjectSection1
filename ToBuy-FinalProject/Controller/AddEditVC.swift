//
//  AddEditVC.swift
//  ToBuy-FinalProject
//
//  Created by Jonathan Compton on 3/23/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import UIKit

class AddEditVC: UIViewController {
    
    var editMode = false
    

    @IBOutlet weak var itemTitleTextField: UITextField!
    @IBOutlet weak var itemPriceTextField: UITextField!
    @IBOutlet weak var itemDetailsTextField: UITextField!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var changePreviewBtn: UIButton!
    @IBOutlet weak var addEditBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

  
    @IBAction func changePreviewBtnTapped(_ sender: UIButton) {
    }
    
    @IBAction func addEditBtnTapped(_ sender: Any) {
    }
    

}
