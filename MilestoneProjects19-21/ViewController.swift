//
//  ViewController.swift
//  MilestoneProjects19-21
//
//  Created by Filip Cernov on 27/08/2022.
//

import UIKit



class NotesTableViewController: UIViewController {
    
    var notes = [Note]()
    var selectedIndexPathRow: Int?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadJSON()
        addingObserverSetup()
    }
    
    func addingObserverSetup() {
        let notificationCenter = NotificationCenter.default
        //Note Editing
        let notificaionNameForSavingEditingChanges = Notification.Name("saveEditingChanges")
        notificationCenter.addObserver(self, selector: #selector(saveEditingChangesToJSON(_:)), name: notificaionNameForSavingEditingChanges, object: nil)
        
        // New Note
        let notificationNameForCreatingNewNote = Notification.Name("CreateNewNote")
        notificationCenter.addObserver(self, selector: #selector(addNewNote(_:)), name: notificationNameForCreatingNewNote, object: nil)
        
        // Deletion
        let notificationNameForDeletingNote = Notification.Name("DeleteNote")
        notificationCenter.addObserver(self, selector: #selector(deleteNote(_:)), name: notificationNameForDeletingNote, object: nil)
    }
    
    @objc func saveEditingChangesToJSON(_ notification: NSNotification) {
        guard let indexPathRow = notification.userInfo?["selectedIndexPathRow"] as? Int else { return }
        guard let text = notification.userInfo?["text"] as? String else {return}
        notes[indexPathRow].text = text
        save()
    }
    
    @objc func addNewNote(_ notification: NSNotification? = nil) {
        let ac = UIAlertController(title: "Name you note", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak ac] _ in
            guard let nameOfTheNote = ac?.textFields?[0].text else {return}
            let note = Note(title: nameOfTheNote, text: "")
            self?.notes.append(note)
            DispatchQueue.global().async {
                self?.save()
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func deleteNote(_ notification: NSNotification) {
        guard let indexPathRow = notification.userInfo?["selectedIndexPathRow"] as? Int else { return }
        notes.remove(at: indexPathRow)
        tableView.deleteRows(at: [IndexPath(row: indexPathRow, section: 0)], with: .automatic)
        save()
    }

    @IBAction func addNewNoteTapped(_ sender: Any) {
        addNewNote(nil)
    }
    
}

extension NotesTableViewController {
    
    func save() {
        let requestBody = Notes(notes: notes)
        let jsonString = convertObjectIntoJSONString(requestBody: requestBody)
        saveJSONData(jsonString)
    }
    
    func loadJSON() {
        DispatchQueue.global().async {
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                 in: .userDomainMask).first {
                let url = documentDirectory.appendingPathComponent("notes")
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(Notes.self, from: data)
                    self.notes = jsonData.notes
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print("error:\(error)")
                }
            }
        }
    }
    
    func convertObjectIntoJSONString(requestBody : Notes) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let result = try encoder.encode(requestBody)
            if let jsonString = String(data: result, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print("Your parsing sucks \(error)")
        }
        return nil
    }
    
    func saveJSONData(_ jsonString: String?) {
        guard let jsonString = jsonString else { return }
        if let jsonData = jsonString.data(using: .utf8),
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let pathWithFileName = documentDirectory.appendingPathComponent("notes")
            do {
                try jsonData.write(to: pathWithFileName)
            } catch {
                print("Failed to save JSON")
            }
        }
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPathRow = indexPath.row
        performSegue(withIdentifier: "showNote", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNote" {
            if let destinationVC =  segue.destination as? NoteViewController  {
                guard let selectedIndexPathRow = selectedIndexPathRow else { return }
                destinationVC.selectedIndexPathRow = selectedIndexPathRow
                destinationVC.selectedText = notes[selectedIndexPathRow].text
            }
        }
    }

}

