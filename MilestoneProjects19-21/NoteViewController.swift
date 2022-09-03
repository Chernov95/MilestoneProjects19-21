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
    
    
    @IBOutlet var note: UITextView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        note.delegate = self
        note.text = selectedText
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
    }
    
    @objc func share() {
        guard let text = note.text else { return }
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    @IBAction func deleteNote(_ sender: UIBarButtonItem) {
        let notificationName = Notification.Name("DeleteNote")
        let noteData: [String: Any] = ["selectedIndexPathRow": selectedIndexPathRow as Any]
        notificationCenter.post(name: notificationName, object: nil, userInfo: noteData)
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func addNewNote(_ sender: UIBarButtonItem) {
        let notificationName = Notification.Name("CreateNewNote")
        navigationController?.popToRootViewController(animated: true)
        notificationCenter.post(name: notificationName, object: nil, userInfo: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let notificationName = Notification.Name("saveEditingChanges")
        let textData: [String : Any] = ["selectedIndexPathRow" : selectedIndexPathRow as Any, "text":note.text as Any]
        notificationCenter.post(name: notificationName, object: nil, userInfo: textData)
    }

    

}
