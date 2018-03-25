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
            itemPriceTextField.placeholder = database.items[index].stringPrice()
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
    
    
    @IBAction func addEditBtnTapped(_ sender: Any) {
        if editMode {
            if itemTitleTextField.text! != "" {
                database.items[index].title = itemTitleTextField.text!
            }
            if itemPriceTextField.text! != "" {
                database.items[index].price = Double(itemPriceTextField.text!)!
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
