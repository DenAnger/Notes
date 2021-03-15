//
//  DetailViewController.swift
//  Notes
//
//  Created by Denis Abramov on 12.03.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var noteTextView: UITextView!
    
    var detailItem: Note? {
        didSet {
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "changeNote" else { return }
        let changeNoteViewController = segue.destination as! CreateViewController
        if let detail = detailItem {
            changeNoteViewController.setChangingNote(changingNote: detail)
        }
    }
    
    // MARK: - Methods
    
    func configureView() {
        guard let detail = detailItem else { return }
        if let topicLabel = titleLabel,
           let textView = noteTextView {
            topicLabel.text = detail.noteTitle
            textView.text = detail.noteText
        }
    }
}
