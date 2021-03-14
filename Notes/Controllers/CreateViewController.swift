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
    
    private let creationTimeStamp: Int64 = Date().toSeconds()
    private(set) var changingNote: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationView()
    }
    
    // MARK: - Actions
    
    @IBAction func titleChanged(_ sender: UITextField, forEvent event: UIEvent) {
        if self.changingNote != nil {
            saveButton.isEnabled = true
        } else {
            if sender.text?.isEmpty ?? true || createTextView.text?.isEmpty ?? true {
                saveButton.isEnabled = false
            } else {
                saveButton.isEnabled = true
            }
        }
    }
    
    @IBAction func saveButtonClicked(_ sender: UIButton, forEvent event: UIEvent) {
        if self.changingNote != nil {
            changeItem()
        } else {
            addItem()
        }
    }
    
    // MARK: - Methods
    
    func setChangingNote(changingNote: Note) {
        self.changingNote = changingNote
    }
    
    func configurationView() {
        createTextView.delegate = self
    }
    
    private func addItem() {
        let note = Note(title: titleTextField.text!,
                        text: createTextView.text,
                        timeStamp: creationTimeStamp)
        Storage.storage.addNote(added: note)
        performSegue(withIdentifier: "backToMain", sender: self)
    }
    
    private func changeItem() {
        if let changingNote = self.changingNote {
            Storage.storage.changeNote(changed: Note(
                id: changingNote.noteID,
                title: titleTextField.text!,
                text: createTextView.text,
                timeStamp: creationTimeStamp
            ))
            
            performSegue(withIdentifier: "backToMain", sender: self)
        } else {
            let alert = UIAlertController(
                title: "Unexpected error",
                message: "Can't change the note, unexpected error occurred. Try again later.",
                preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { (_) in
                self.performSegue(withIdentifier: "backToMain", sender: self)
            })
            self.present(alert, animated: true)
        }
    }
}

// MARK: - Text View Delegate

extension CreateViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if self.changingNote != nil {
            saveButton.isEnabled = true
        } else {
            if titleTextField.text?.isEmpty ?? true || textView.text?.isEmpty ?? true {
                saveButton.isEnabled = false
            } else {
                saveButton.isEnabled = true
            }
        }
    }
}
