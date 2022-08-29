//
//  Model.swift
//  MilestoneProjects19-21
//
//  Created by Filip Cernov on 29/08/2022.
//

import Foundation


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
