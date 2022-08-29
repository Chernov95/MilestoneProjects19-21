//
//  NoteViewController.swift
//  MilestoneProjects19-21
//
//  Created by Filip Cernov on 27/08/2022.
//

import UIKit

class NoteViewController: UIViewController, UITextViewDelegate {
    
    let notificationCenter = NotificationCenter.default
    var selectedIndexPathRow: Int?
    var selectedText: String?
    var deletionIsRequired = "NO"
    
    
    @IBOutlet var note: UITextView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        note.delegate = self
        note.text = selectedText
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        guard let selectedIndexPathRow = selectedIndexPathRow else { return }
        let noteData:[String: String] = ["selectedIndexPathRow": String(selectedIndexPathRow), "note": note.text, "deletetionIsRequired" : deletionIsRequired]
        let notificationName = Notification.Name("SaveChanges")
        notificationCenter.post(name: notificationName, object: nil, userInfo: noteData)
    }
    
    @IBAction func deleteNote(_ sender: UIBarButtonItem) {
        deletionIsRequired = "YES"
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func addNewNote(_ sender: UIBarButtonItem) {
        print("New note has been added")
    }
    
    
}
