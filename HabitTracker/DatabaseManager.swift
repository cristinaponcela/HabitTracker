//
//  DatabaseManager.swift
//  HabitTracker
//
//  Created by Cristina Poncela on 30/10/24.
//

import GRDB
import Foundation

class DatabaseManager {
    static let shared = DatabaseManager()
    var dbQueue: DatabaseQueue?

    private init() {
        setupDatabase()
    }

    private func setupDatabase() {
        do {
            let fileManager = FileManager.default
            let folderURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let dbURL = folderURL.appendingPathComponent("HabitTracker.sqlite")
            dbQueue = try DatabaseQueue(path: dbURL.path)
            
            try dbQueue?.write { db in
                try db.create(table: "user", ifNotExists: true) { t in
                    t.column("id", .integer).primaryKey()
                    t.column("username", .text).unique().notNull()
                    t.column("password", .text).notNull()
                }
            }
        } catch {
            print("Failed to set up database: \(error)")
        }
    }
}
