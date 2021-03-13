//
//  ViewController.swift
//  Notes
//
//  Created by Denis Abramov on 11.03.2021.
//

import UIKit

class CreateViewController: UIViewController {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var createTextView: UITextView!
    @IBOutlet var saveButton: UIButton!
    
    private(set) var changingNote: Note?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setChangingNote(changingNote: Note) {
        self.changingNote = changingNote
    }
}
