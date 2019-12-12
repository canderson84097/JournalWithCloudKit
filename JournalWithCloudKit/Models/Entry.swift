//
//  Entry.swift
//  JournalWithCloudKit
//
//  Created by Chris Anderson on 12/9/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import Foundation
import CloudKit

class Entry {
    var title: String
    var text: String
    let timeStamp: Date
    
    init(title: String, text: String, timeStamp: Date = Date()) {
        self.title  = title
        self.text = text
        self.timeStamp = timeStamp
    }
}

extension Entry {
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[EntryStrings.titleKey] as? String, let text = ckRecord[EntryStrings.textKey] as? String, let timeStamp = ckRecord[EntryStrings.timeStampKey] as? Date else { return nil }
        
        self.init(title: title, text: text, timeStamp: timeStamp)
    }
}

extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: EntryStrings.recordTypeKey)
        setValue(entry.title, forKey: EntryStrings.titleKey)
        setValue(entry.text, forKey: EntryStrings.textKey)
        setValue(entry.timeStamp, forKey: EntryStrings.timeStampKey)
        
    }
}

enum EntryStrings {
    static let recordTypeKey = "Entry"
    fileprivate static let titleKey = "title"
    fileprivate static let textKey = "text"
    fileprivate static let timeStampKey = "timeStamp"
}
