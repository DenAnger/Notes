//
//  CoreDataHelper.swift
//  Notes
//
//  Created by Denis Abramov on 12.03.2021.
//

import Foundation
import CoreData

class CoreDataHelper {
    private(set) static var count = 0
    
    static func createNote(created: Note, context: NSManagedObjectContext) {
        let noteEntity = NSEntityDescription.entity(forEntityName: "NoteData",
                                                    in: context)!
        let newNote = NSManagedObject(entity: noteEntity, insertInto: context)
        
        newNote.setValue(created.noteID, forKey: "noteID")
        newNote.setValue(created.noteTitle, forKey: "noteTitle")
        newNote.setValue(created.noteText, forKey: "noteText")
        newNote.setValue(created.noteTimeStamp, forKey: "noteTimeStamp")
        
        do {
            try context.save()
            count += 1
        } catch let error as NSError {
            print("Don't save. \(error), \(error.userInfo)")
        }
    }
    
    static func changeNote(changed: Note, context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteData")
        let noteIDPredicate = NSPredicate(format: "noteID = %@",
                                          changed.noteID as CVarArg)
        fetchRequest.predicate = noteIDPredicate
        
        do {
            let fetchedNotes = try context.fetch(fetchRequest)
            let noteToBeChanged = fetchedNotes[0] as! NSManagedObject
            
            noteToBeChanged.setValue(changed.noteTitle, forKey: "noteTitle")
            noteToBeChanged.setValue(changed.noteText, forKey: "noteText")
            noteToBeChanged.setValue(changed.noteTimeStamp,
                                     forKey: "noteTimeStamp")
            
            try context.save()
        } catch let error as NSError {
            print("Couldn't change. \(error), \(error.userInfo)")
        }
    }
    
    static func deleteNote(delete: UUID, context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteData")
        let noteID = delete as CVarArg
        let noteIDPredicate = NSPredicate(format: "noteID = %@", noteID)
        fetchRequest.predicate = noteIDPredicate
        
        do {
            let fetchedNotes = try context.fetch(fetchRequest)
            let noteDelete = fetchedNotes[0] as! NSManagedObject
            context.delete(noteDelete)
            
            do {
                try context.save()
                self.count -= 1
            } catch let error as NSError {
                print("Couldn't save. \(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            print("Couldn't delete. \(error), \(error.userInfo)")
        }
    }
    
    static func readNote(read: UUID, context: NSManagedObjectContext) -> Note? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteData")
        let noteIDPredicate = NSPredicate(format: "noteID = %@",
                                          read as CVarArg)
        fetchRequest.predicate = noteIDPredicate
        
        do {
            let fetchedNotes = try context.fetch(fetchRequest)
            let noteRead = fetchedNotes[0] as! NSManagedObject
            return Note.init(
                id: noteRead.value(forKey: "noteID") as! UUID,
                title: noteRead.value(forKey: "noteTitle") as! String,
                text: noteRead.value(forKey: "noteText") as! String,
                timeStamp: noteRead.value(forKey: "noteTimeStamp") as! Int64
            )
        } catch let error as NSError {
            print("Couldn't read. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    static func readNotes(context: NSManagedObjectContext) -> [Note] {
        var returnedNotes = [Note]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteData")
        fetchRequest.predicate = nil
        
        do {
            let fetchedNotes = try context.fetch(fetchRequest)
            fetchedNotes.forEach { (fetchRequestResult) in
                let noteRead = fetchRequestResult as! NSManagedObject
                
                returnedNotes.append(Note.init(
                    id: noteRead.value(forKey: "noteID") as! UUID,
                    title: noteRead.value(forKey: "noteTitle") as! String,
                    text: noteRead.value(forKey: "noteText") as! String,
                    timeStamp: noteRead.value(forKey: "noteTimeStamp") as! Int64
                ))
            }
        } catch let error as NSError {
            print("Couldn't read. \(error), \(error.userInfo)")
        }
        self.count = returnedNotes.count
        return returnedNotes
    }
}
