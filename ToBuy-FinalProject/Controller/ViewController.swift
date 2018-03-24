//
//  ViewController.swift
//  ToBuy-FinalProject
//
//  Created by Jonathan Compton on 3/23/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var database = ItemDB.singletonDB
    var index : Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortToggler: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem  = editButtonItem
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "toAddEditVCEdit", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddEditVCEdit" {
            let destinationVC = segue.destination as! AddEditVC
            destinationVC.editMode = true
            destinationVC.index = self.index
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        let item = database.items[indexPath.row]
        cell.itemImageView.image = item.image
        cell.itemTitleLabel.text = item.title
        cell.itemPriceLabel.text = item.price
        cell.itemDetailLabel.text = item.details
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return database.items.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            database.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            tableView.setEditing(true, animated: true)
        } else {
            tableView.setEditing(false, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = database.items[sourceIndexPath.row]
        database.items.remove(at: sourceIndexPath.row)
        database.items.insert(itemToMove, at: destinationIndexPath.row)
    }

    @IBAction func sortTogglerTapped(_ sender: UISegmentedControl) {
        if sortToggler.selectedSegmentIndex == 1 {
            database.sortByPrice()
            tableView.reloadData()
        }
    }
}

