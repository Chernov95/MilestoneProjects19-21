//
//  NoteViewController.swift
//  MilestoneProjects19-21
//
//  Created by Filip Cernov on 27/08/2022.
//

import UIKit

class NoteViewController: UIViewController, UITextViewDelegate {
    
    var selectedIndexPathRow: Int?
    var selectedText: String?
    
    
    @IBOutlet var note: UITextView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        note.delegate = self
        note.text = selectedText
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        guard let selectedIndexPathRow = selectedIndexPathRow else { return }
        let noteData:[String: String] = ["selectedIndexPathRow": String(selectedIndexPathRow), "note": note.text]
        
        let notificationCenter = NotificationCenter.default
        let notificationName = Notification.Name("NotificationName")
        notificationCenter.post(name: notificationName, object: nil, userInfo: noteData)
    }
    

}
