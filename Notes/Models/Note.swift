//
//  Note.swift
//  Notes
//
//  Created by Denis Abramov on 12.03.2021.
//

import Foundation

final class Note {
	private(set) var noteID: UUID
	private(set) var noteTitle: String
	private(set) var noteText: String
	private(set) var noteTimeStamp: Int64
	
	init(id: UUID, title: String, text: String, timeStamp: Int64) {
		self.noteID = id
		self.noteTitle = title
		self.noteText = text
		self.noteTimeStamp = timeStamp
	}
	
	init(title: String, text: String, timeStamp: Int64) {
		self.noteID = UUID()
		self.noteTitle = title
		self.noteText = text
		self.noteTimeStamp = timeStamp
	}
}
