//
//  Filename: MatchHistVC.swift
//  cs371l-tictactoe
//  EID: bv5433, dk9362
//  Course: CS371L
//
//  Created by Billy Vo and Dylan Kan on 6/22/20.
//  Copyright © 2020 billyvo and dylan.kan67. All rights reserved.
//

import UIKit
import CoreData

public var matchTable: [NSManagedObject] = []

class MatchHistVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(settings[0].value(forKeyPath: "isOn") as! Bool) {
            overrideUserInterfaceStyle = .dark
            self.navigationController?.navigationBar.barTintColor = .black
        } else {
            overrideUserInterfaceStyle = .light
            self.navigationController?.navigationBar.barTintColor = .white
        }
    
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
              return
        }
        
        // fetch matches from Core Data.
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Match")
        
        do {
            try matchTable = managedContext.fetch(fetchRequest).reversed()
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            abort()
        }
    }
    
    // Set cell height so we can display everything.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 150
    }
    
    // Tell tableView how many cells to allocate.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchTable.count
    }
    
    // For each cell, set their match-representing board.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath as IndexPath) as! MatchCell
        let row = indexPath.row
        let match = matchTable[row]
        cell.setFieldsFromCoreData(match: match)
        
        return cell
    }
    
    // Selecting a row segues into PostGameVC and sends match.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MatchHistToPostgameSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MatchHistToPostgameSegue" {
            let destination = segue.destination as! PostGameVC
            destination.match = matchTable[tableView.indexPathForSelectedRow!.row]
        }
    }
}
