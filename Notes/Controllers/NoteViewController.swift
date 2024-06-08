//
//  ViewController.swift
//  Notes
//
//  Created by Denis Abramov on 11.03.2021.
//

import UIKit

final class NoteViewController: UIViewController {
	
	// MARK: UI Elements
	
	@IBOutlet private var titleTextField: UITextField!
	@IBOutlet private var createTextView: UITextView!
	@IBOutlet private var saveButton: UIButton!
	
	// MARK: Properties
	
	private let creationTimeStamp: Int64 = Date().toSeconds()
	private(set) var changingNote: Note?
	
	var detailItem: Note? {
		didSet {
			configureDetailItem()
		}
	}
	
	// MARK: Life cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
		configureDetailItem()
	}
	
	func configureDetailItem() {
		guard let detail = detailItem else {
			return
		}
		
		if let topicLabel = titleTextField,
		   let textView = createTextView {
			topicLabel.text = detail.noteTitle
			textView.text = detail.noteText
			createTextView.textColor = .black
		}
	}
}

// MARK: - Actions

extension NoteViewController {
	
	@IBAction func titleChanged(_ sender: UITextField, forEvent event: UIEvent) {
		if self.changingNote != nil {
			saveButton.isEnabled = true
		} else {
			let titleIsEmpty = sender.text?.isEmpty ?? true
			let textViewIsEmpty = createTextView.text?.isEmpty ?? true
			saveButton.isEnabled = !(titleIsEmpty && textViewIsEmpty)
		}
	}
	
	@IBAction func saveButtonClicked(_ sender: UIButton, forEvent event: UIEvent) {
		if detailItem != nil {
			changingNote = detailItem
			changeItem()
		} else {
			addItem()
		}
		navigationController?.popViewController(animated: true)
	}
}

// MARK: - Methods

extension NoteViewController {
	func setChangingNote(changingNote: Note) {
		self.changingNote = changingNote
	}
}

// MARK: - Private Methods

private extension NoteViewController {
	func setup() {
		createTextView.delegate = self
		createTextView.text = "Введите текст заметки"
		createTextView.textColor = .lightGray

		if let changingNote = self.changingNote {
			createTextView.textColor = .black
			titleTextField.text = changingNote.noteTitle
			createTextView.text = changingNote.noteText
			saveButton.isEnabled = true
		}
	}
	
	func addItem() {
		let note = Note(title: titleTextField.text!,
						text: createTextView.text,
						timeStamp: creationTimeStamp)
		Storage.storage.addNote(added: note)
	}
	
	func changeItem() {
		if let changingNote = self.changingNote {
			Storage.storage.changeNote(changed: Note(
				id: changingNote.noteID,
				title: titleTextField.text!,
				text: createTextView.text,
				timeStamp: creationTimeStamp
			))
		} else {
			let alert = UIAlertController(
				title: "Unexpected error",
				message: "Can't change the note, unexpected error occurred. Try again later.",
				preferredStyle: .alert)
			
			alert.addAction(UIAlertAction(title: "Ok", style: .default) { (_) in
			})
			self.present(alert, animated: true)
		}
	}
}

// MARK: - Text View Delegate

extension NoteViewController: UITextViewDelegate {
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
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		if textView.textColor == .lightGray {
			textView.text = nil
			textView.textColor = .black
		}
	}
}
