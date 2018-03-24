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
    var imagePicker = UIImagePickerController()
    

    @IBOutlet weak var itemTitleTextField: UITextField!
    @IBOutlet weak var itemPriceTextField: UITextField!
    @IBOutlet weak var itemDetailsTextField: UITextField!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var changePreviewBtn: UIButton!
    @IBOutlet weak var addEditBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let newItem = Item(title: itemTitleTextField.text!, price: itemPriceTextField.text!, image: previewImageView.image!, details: itemDetailsTextField.text!)
        database.items.append(newItem)
        navigationController!.popViewController(animated: true)
    }
    

}
