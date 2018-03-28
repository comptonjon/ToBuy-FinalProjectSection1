//
//  ViewController.swift
//  ToBuy-FinalProject
//
//  Created by Jonathan Compton on 3/23/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import UIKit
import AVFoundation

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate {
    
    var database = ItemDB.singletonDB
    var index : Int = 0
    var rankedItems = false
    var audioPlayer : AVAudioPlayer!
    let soundURL = Bundle.main.url(forResource: "coin", withExtension: "mp3")
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortToggler: UISegmentedControl!
    @IBOutlet weak var totalLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem  = editButtonItem
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    //Update view after AddEditVC is popped off
    override func viewWillAppear(_ animated: Bool) {
        if sortToggler.selectedSegmentIndex == 0 {
            database.sortByPrice()
        } else {
            database.sortByDate()
        }
        tableView.reloadData()
        totalLabel.text = getTotalString()
    }

    //MARK: TableView DataSource methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "toAddEditVCEdit", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddEditVCEdit" {
            let destinationVC = segue.destination as! AddEditVC
            destinationVC.editMode = true
            destinationVC.index = self.index
            destinationVC.rankedItem = rankedItems
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        let item : Item
        if rankedItems {
            item = database.items[indexPath.row]
        } else {
            item = database.nonRankedItems[indexPath.row]
        }
        
        cell.itemImageView.image = item.image
        cell.itemTitleLabel.text = item.title
        cell.itemPriceLabel.text = CurrencyFormatter.sharedInstance.string(from: item.nsPrice())!
        cell.itemDetailLabel.text = item.details
        cell.completeImageView.image = item.doneImage
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swiped(recognizer:)))
        swipeRightGesture.direction = .right
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swiped(recognizer:)))
        swipeLeftGesture.direction = .left
        cell.gestureRecognizers = [swipeLeftGesture, swipeRightGesture]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return database.items.count
    }
    
    //MARK: TableView delegate methods
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if rankedItems {
                database.removeItem(index: indexPath.row, ranked: true)
            } else {
                database.removeItem(index: indexPath.row, ranked: false)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            totalLabel.text = getTotalString()
        }

    }
    //Disable sortToggler when editing
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            tableView.setEditing(true, animated: true)
            sortToggler.isEnabled = false
        } else {
            sortToggler.isEnabled = true
            tableView.setEditing(false, animated: false)
        }
    }
    //Disable movement of cells when not ordered by rank
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if rankedItems {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = database.items[sourceIndexPath.row]
        database.items.remove(at: sourceIndexPath.row)
        database.items.insert(itemToMove, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing {
            return .delete
        }
        
        return .none
    
    }
    //Change state and update when sorting by rank or not
    @IBAction func sortTogglerTapped(_ sender: UISegmentedControl) {
        if sortToggler.selectedSegmentIndex == 0 {
            rankedItems = false
            database.sortByPrice()
            tableView.reloadData()
        }
        if sortToggler.selectedSegmentIndex == 1 {
            rankedItems = false
            database.sortByDate()
            tableView.reloadData()
        }
        if sortToggler.selectedSegmentIndex == 2 {
            rankedItems = true
            tableView.reloadData()
        }
        
        
    }
    //MARK: Gesture Handler
    @objc func swiped(recognizer: UISwipeGestureRecognizer){
        let swipe = recognizer as UISwipeGestureRecognizer
        let locationInView = swipe.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: locationInView)!
        let item : Item
        if rankedItems {
            item = database.items[indexPath.row]
        } else {
            item = database.nonRankedItems[indexPath.row]
        }
        if swipe.direction == .right {
            if !item.done {
                item.done = true
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
                } catch {
                    print(error)
                }
                audioPlayer.play()
            }
        }
        if swipe.direction == .left {
            if item.done {
                item.done = false
            }
        }
        
        tableView.reloadRows(at: [indexPath], with: .fade)
        totalLabel.text = getTotalString()

        
        
    }
    
    func getTotalString() -> String {
        
        return CurrencyFormatter.sharedInstance.string(from: database.getTotal())!
    }
    
    
}



