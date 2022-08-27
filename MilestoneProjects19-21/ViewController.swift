//
//  ViewController.swift
//  MilestoneProjects19-21
//
//  Created by Filip Cernov on 27/08/2022.
//

import UIKit

class Notes {
    var notes = [Note]()
}

class Note {
    var title = String()
    var text = String()
}

class NotesTableViewController: UIViewController {
    
    var notes = [Note]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func addNewNote(_ sender: UIButton) {
        let note = Note()
        note.title = "New note"
        note.text = ""
        notes.append(note)
        tableView.reloadData()
    }
    

}

extension NotesTableViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "note", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].title
        return cell
    }

}

