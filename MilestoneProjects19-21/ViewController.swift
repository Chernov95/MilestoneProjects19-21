//
//  ViewController.swift
//  MilestoneProjects19-21
//
//  Created by Filip Cernov on 27/08/2022.
//

import UIKit

class Notes: Codable {
    var notes: [Note]
    init (notes: [Note]) {
        self.notes = notes
    }
}

class Note: Codable {
    var title: String
    var text: String
    init(title: String, text: String) {
        self.title = title
        self.text = text
    }
}

class NotesTableViewController: UIViewController {
    
    var notes = [Note]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadJSON()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showNote", sender: self)
    }
    

    @IBAction func addNewNote(_ sender: UIButton) {
        let note = Note(title: "New note", text: "")
        notes.append(note)
        let requestBody = Notes(notes: notes)
        let jsonString = convertObjectIntoJSONString(requestBody: requestBody)
        saveJSONData(jsonString)
        tableView.reloadData()
    }
    
    func convertObjectIntoJSONString(requestBody : Notes) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let result = try encoder.encode(requestBody)
            if let jsonString = String(data: result, encoding: .utf8) {
                // JSON STRING
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
            let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                             in: .userDomainMask).first {
            let pathWithFileName = documentDirectory.appendingPathComponent("notes")
            do {
                try jsonData.write(to: pathWithFileName)
            } catch {
                // handle error
            }
        }
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

