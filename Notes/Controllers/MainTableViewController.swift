//
//  MainTableViewController.swift
//  Notes
//
//  Created by Denis Abramov on 12.03.2021.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        configurateCoreData()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(insertNewObject(_:)))
         navigationItem.rightBarButtonItem = addButton
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return Storage.storage.count()
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell",
                                                 for: indexPath) as! NoteCell

        if let object = Storage.storage.readNote(at: indexPath.row) {
            cell.titleLabel!.text = object.noteTitle
            cell.noteTextLabel!.text = object.noteText
            cell.dateLabel!.text = DateHelper.convertDate(
                date: Date.init(seconds: object.noteTimeStamp)
            )
        }
        return cell
    }

    override func tableView(_ tableView: UITableView,
                            canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Storage.storage.removeNote(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Table View delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // MARK: - Methods
    
    func configurateCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            let alert = UIAlertController(
                title: "Couldn't get app delegate",
                message: "Couldn't get app delegate, unexpected error occurred. Try again later",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        Storage.storage.setManagedContext(context: managedContext)
    }
    
    @objc func insertNewObject(_ sender: Any) {
        performSegue(withIdentifier: "createNote", sender: self)
    }
}
