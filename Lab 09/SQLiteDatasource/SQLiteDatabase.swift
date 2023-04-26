//
//  SQLiteDatabase.swift
//  Lab 09
//
//  Created by Lê Duy Tân on 11/04/2023.
//

import Foundation
import SQLite

class SQLiteDatabase {
    static let sharedInstance = SQLiteDatabase()
    var database: Connection?
    
    private init() {
        //Create connection
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let fileUrl = documentDirectory.appendingPathComponent("Contact list").appendingPathExtension("sqlite3")
            database = try Connection(fileUrl.path)
        } catch {
            print("Creating connection to database")
        }
    }
    
    //Creating table
    func createTable() {
        SQLiteCommands.createTable()
    }
}
