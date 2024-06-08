//
//  Storage.swift
//  Notes
//
//  Created by Denis Abramov on 12.03.2021.
//

import CoreData

final class Storage {
	static let storage = Storage()
	
	private var indexID: [Int: UUID] = [:]
	private var currentIndex = 0
	
	private(set) var managedContext: NSManagedObjectContext
	private var managedContextHasBeenSet = false
	
	private init() {
		managedContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
	}
	
	func setManagedContext(context: NSManagedObjectContext) {
		self.managedContext = context
		self.managedContextHasBeenSet = true
		
		let notes = CoreDataHelper.readNotes(context: self.managedContext)
		currentIndex = CoreDataHelper.count
		
		for (index, note) in notes.enumerated() {
			indexID[index] = note.noteID
		}
	}
	
	func addNote(added: Note) {
		guard managedContextHasBeenSet else { return }
		indexID[currentIndex] = added.noteID
		CoreDataHelper.createNote(created: added, context: self.managedContext)
		currentIndex += 1
	}
	
	func changeNote(changed: Note) {
		guard managedContextHasBeenSet else { return }
		var changedIndex: Int?
		indexID.forEach { (index: Int, noteID: UUID) in
			guard noteID == changed.noteID else { return }
			changedIndex = index
			return
		}
		guard changedIndex != nil else { return }
		CoreDataHelper.changeNote(changed: changed, context: self.managedContext)
		return
	}
	
	func removeNote(at: Int) {
		guard managedContextHasBeenSet else { return }
		if at < 0 || at > currentIndex - 1 {
			return
		}
		
		let noteID = indexID[at]
		CoreDataHelper.deleteNote(deleted: noteID!, context: self.managedContext)
		
		if at < currentIndex - 1 {
			for index in at ... currentIndex - 2 {
				indexID[index] = indexID[index + 1]
			}
		}
		indexID.removeValue(forKey: currentIndex)
		currentIndex -= 1
	}
	
	func readNote(at: Int) -> Note? {
		if managedContextHasBeenSet {
			if at < 0 || at > currentIndex - 1 {
				return nil
			}
			
			let noteID = indexID[at]
			let noteRead: Note?
			noteRead = CoreDataHelper.readNote(read: noteID!,
											   context: self.managedContext)
			return noteRead
		}
		return nil
	}
	
	func count() -> Int {
		return CoreDataHelper.count
	}
}
