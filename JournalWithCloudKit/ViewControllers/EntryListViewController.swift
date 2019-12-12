//
//  EntryListViewController.swift
//  JournalWithCloudKit
//
//  Created by Chris Anderson on 12/9/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import UIKit

class EntryListViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var entryTableView: UITableView!
    
    // MARK: - Life Cycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entryTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateViews()
    }
    
    // MARK: - Custom Functions
    
    func updateViews() {
        DispatchQueue.main.async {
            self.entryTableView.reloadData()
        }
    }
    
    @objc func loadData() {
        EntryController.shared.fetchEntries { (success) in
            if success {
                self.updateViews()
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            guard let indexPath = entryTableView.indexPathForSelectedRow, let destinationVC = segue.destination as? EntryDetailViewController else { return }
            let chosenEntry = EntryController.shared.entries[indexPath.row]
            destinationVC.entryLanding = chosenEntry
        }
    }
}

extension EntryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        EntryController.shared.entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        
        let entry = EntryController.shared.entries[indexPath.row]
        
        cell.textLabel?.text = entry.title
        cell.detailTextLabel?.text = entry.text
        
        updateViews()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = EntryController.shared.entries[indexPath.row]
            EntryController.shared.deleteEntry(entry: entry)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
