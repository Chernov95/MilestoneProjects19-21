//
//  NoteViewController.swift
//  MilestoneProjects19-21
//
//  Created by Filip Cernov on 27/08/2022.
//

import UIKit

class NoteViewController: UIViewController, UITextViewDelegate {
    
    let notificationCenter = NotificationCenter.default
    var deletionIsRequired = false
    var newNoteIsRequested = false
    var selectedIndexPathRow: Int?
    var selectedText: String?
    
    
    @IBOutlet var note: UITextView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        note.delegate = self
        note.text = selectedText
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(compose))
    }
    
    @objc func compose() {
        guard let text = note.text else { return }
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        guard let selectedIndexPathRow = selectedIndexPathRow else { return }
        let noteData:[String: Any] = ["selectedIndexPathRow": selectedIndexPathRow, "deletetionIsRequired" : deletionIsRequired, "newNoteIsRequested" : newNoteIsRequested]
        let notificationName = Notification.Name("SaveChanges")
        notificationCenter.post(name: notificationName, object: nil, userInfo: noteData)
    }
    
    @IBAction func deleteNote(_ sender: UIBarButtonItem) {
        deletionIsRequired = true
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func addNewNote(_ sender: UIBarButtonItem) {
        newNoteIsRequested = true
        navigationController?.popToRootViewController(animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let notificationName = Notification.Name("saveEditingChanges")
        let textData: [String : Any] = ["selectedIndexPathRow" : selectedIndexPathRow as Any, "text":note.text as Any]
        notificationCenter.post(name: notificationName, object: nil, userInfo: textData)
    }

    

}
