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
    
    override func viewWillAppear(_ animated: Bool) {
        if sortToggler.selectedSegmentIndex == 0 {
            database.sortByPrice()
        } else {
            database.sortByDate()
        }
        tableView.reloadData()
        totalLabel.text = getTotalString()
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            database.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            totalLabel.text = getTotalString()
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    @IBAction func sortTogglerTapped(_ sender: UISegmentedControl) {
        if sortToggler.selectedSegmentIndex == 0 {
            database.sortByPrice()
            tableView.reloadData()
        }
        if sortToggler.selectedSegmentIndex == 1 {
            database.sortByDate()
            tableView.reloadData()
        }
    }
    
    @objc func swiped(recognizer: UISwipeGestureRecognizer){
        let swipe = recognizer as UISwipeGestureRecognizer
        let locationInView = swipe.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: locationInView)!
        let item = database.items[indexPath.row]
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
    
//    @objc func swipedLeft(recognizer: UISwipeGestureRecognizer){
//        let swipe = recognizer as UISwipeGestureRecognizer
//        let locationInView = swipe.location(in: tableView)
//        let indexPath = tableView.indexPathForRow(at: locationInView)!
//        let item = database.items[indexPath.row]
//        item.done = false
//        tableView.reloadRows(at: [indexPath], with: .fade)
//        totalLabel.text = getTotalString()
//    }
    
    func getTotalString() -> String {
        
        return CurrencyFormatter.sharedInstance.string(from: database.getTotal())!
    }
    
    
}



