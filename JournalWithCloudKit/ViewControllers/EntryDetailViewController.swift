//
//  EntryDetailViewController.swift
//  JournalWithCloudKit
//
//  Created by Chris Anderson on 12/9/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var textTextView: UITextView!
    
    // MARK: - Properties
    var entryLanding: Entry? {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty, let text = textTextView.text, !text.isEmpty else { return }
        if let entry = entryLanding {
            EntryController.shared.updateEntry(entry: entry, title: title, text: text)
            navigationController?.popViewController(animated: true)
        } else {
            EntryController.shared.saveEntry(with: title, text: text) { (_) in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        titleTextField.text = ""
        textTextView.text = ""
    }
    
    // MARK: - Custom Methods
    
    func updateViews() {
        if let entry = entryLanding {
            loadViewIfNeeded()
            titleTextField.text = entry.title
            textTextView.text = entry.text
        }
    }
    
}
