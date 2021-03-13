//
//  NoteCell.swift
//  Notes
//
//  Created by Denis Abramov on 12.03.2021.
//

import UIKit

class NoteCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var noteTextLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    private(set) var noteTitle = ""
    private(set) var noteText = ""
    private(set) var noteDate = ""
}
