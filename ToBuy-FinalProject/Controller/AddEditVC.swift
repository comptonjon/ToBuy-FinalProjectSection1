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
    

    @IBOutlet weak var itemTitleTextField: UITextField!
    @IBOutlet weak var itemPriceTextField: UITextField!
    @IBOutlet weak var itemDetailsTextField: UITextField!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var changePreviewBtn: UIButton!
    @IBOutlet weak var addEditBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if editMode {
            itemTitleTextField.placeholder = database.items[index].title
            itemPriceTextField.placeholder = database.items[index].price
            itemDetailsTextField.placeholder = database.items[index].details
            previewImageView.image = database.items[index].image
            changePreviewBtn.setTitle("Change Image", for: .normal)
            addEditBtn.setTitle("Edit Item", for: .normal)
            navigationItem.title = "Edit Item"
        }
        imagePicker.delegate = self

        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            previewImageView.image = image
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
  
    @IBAction func changePreviewBtnTapped(_ sender: UIButton) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func addEditBtnTapped(_ sender: Any) {
        if editMode {
            if itemTitleTextField.text! != "" {
                database.items[index].title = itemTitleTextField.text!
            }
            if itemPriceTextField.text! != "" {
                database.items[index].price = itemPriceTextField.text!
            }
            if itemDetailsTextField.text! != "" {
                database.items[index].details = itemDetailsTextField.text!
            }
            database.items[index].image = previewImageView.image!
        } else {
            let newItem = Item(title: itemTitleTextField.text!, price: itemPriceTextField.text!, image: previewImageView.image!, details: itemDetailsTextField.text!)
            database.items.append(newItem)
        }
        
        navigationController!.popViewController(animated: true)
    }
    

}
