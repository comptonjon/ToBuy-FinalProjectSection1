//
//  AddEditVC.swift
//  ToBuy-FinalProject
//
//  Created by Jonathan Compton on 3/23/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import UIKit

class AddEditVC: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var editMode = false
    var database = ItemDB.singletonDB
    var index : Int = 0
    var imagePicker = UIImagePickerController()
    var rankedItem = false
    
    

    @IBOutlet weak var itemTitleTextField: UITextField!
    @IBOutlet weak var itemPriceTextField: UITextField!
    @IBOutlet weak var itemDetailsTextField: UITextField!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var changePreviewBtn: UIButton!
    @IBOutlet weak var addEditBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if editMode {
            let item : Item
            if rankedItem {
                item = database.items[index]
            } else {
                item = database.nonRankedItems[index]
            }
            itemTitleTextField.placeholder = item.title
            let price = CurrencyFormatter.sharedInstance.string(for: item.nsPrice())
            itemPriceTextField.placeholder = price
            itemDetailsTextField.placeholder = item.details
            previewImageView.image = item.image
            changePreviewBtn.setTitle("Change Image", for: .normal)
            addEditBtn.setTitle("Edit Item", for: .normal)
            navigationItem.title = "Edit Item"

        }
        imagePicker.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        
        itemPriceTextField.inputAccessoryView = toolBar
        
    }
    //MARK:  TextField methods
    @objc func doneClicked(){
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //MARK:  Image Picker methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            previewImageView.image = image
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
  
    @IBAction func changePreviewBtnTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose Photo Origin", message: "", preferredStyle: .alert)
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = false
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        let photoRollAction = UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.imagePicker.allowsEditing = false
            self.present(self.imagePicker, animated: true, completion: nil)
            
        })
        alert.addAction(cameraAction)
        alert.addAction(photoRollAction)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //Update or add new cell
    @IBAction func addEditBtnTapped(_ sender: Any) {
        
        if editMode {
            let originalItem : Item
            if rankedItem {
                originalItem = database.items[index]
            } else {
                originalItem = database.nonRankedItems[index]
            }
            let title : String
            if itemTitleTextField.text! != "" {
                title = itemTitleTextField.text!
            } else {
                title = originalItem.title
            }
            let price : String
            if itemPriceTextField.text! != "" {
                price = itemPriceTextField.text!
            } else {
                price = String(originalItem.price)
            }
            let details : String
            if itemDetailsTextField.text! != "" {
                details = itemDetailsTextField.text!
            } else {
                details = originalItem.details
            }
            let item = Item(title: title, price: price, image: previewImageView.image!, details: details)
            database.updateItem(index: index, ranked: rankedItem, newItem: item)
        } else {
            let price : String
            if itemPriceTextField.text == "" {
                price = "0"
            } else {
                price = itemPriceTextField.text!
            }
            let item = Item(title: itemTitleTextField.text!, price: price, image: previewImageView.image!, details: itemDetailsTextField.text!)
            database.items.append(item)
            database.nonRankedItems.append(item)
        }
        
        navigationController!.popViewController(animated: true)
    }
    

}
