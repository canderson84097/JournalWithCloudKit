//
//  EntryController.swift
//  JournalWithCloudKit
//
//  Created by Chris Anderson on 12/9/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import Foundation
import CloudKit

class EntryController {
    
    static let shared = EntryController()
    var entries: [Entry] = []
    let publicDB = CKContainer.default().publicCloudDatabase
    
    func updateEntry(entry: Entry, title: String, text: String) {
        entry.title = title
        entry.text = text
    }
    
    func deleteEntry(entry: Entry) {
        entries.removeFirst()
    }
    
    func saveEntry(with title: String, text: String, completion: @escaping (Bool) -> Void) {
        
        let entry = Entry(title: title, text: text)
        let record = CKRecord(entry: entry)
        publicDB.save(record) { (record, error) in
            
            if let error = error {
                print(error, error.localizedDescription)
                return completion(false)
            }
            
            guard let record = record, let entry = Entry(ckRecord: record) else { return completion(false) }
            self.entries.insert(entry, at: 0)
            print("Successfully saved Entry.")
            return completion(true)
        }
    }
    
    func fetchEntries(completion: @escaping (Bool) -> Void) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: EntryStrings.recordTypeKey, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            
            if let error = error {
                print(error, error.localizedDescription)
                return completion(false)
            }
            
            guard let records = records else { return completion(false) }
            let entries = records.compactMap { record in
                Entry(ckRecord: record)
            }
            
            self.entries = entries
            completion(true)
        }
    }
}
