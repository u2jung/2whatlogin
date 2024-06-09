//
//  DBManager.swift
//  db_test
//
//  Created by 김유정 on 6/5/24.
//

import Foundation
import SQLite3

class DBManager{
    init(){
        db = openDatabase()
        createUserTable()
    }
    
    let dataPath: String = "MyDB"
    var db: OpaquePointer?
    var path = "test_db.sqlite"
    // Create DB
    func openDatabase()->OpaquePointer?{
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dataPath)
        
        var db: OpaquePointer? = nil
        if sqlite3_open(filePath.path, &db) != SQLITE_OK{
            debugPrint("Cannot open DB.")
            return nil
        }
        else{
            print("DB successfully created.")
            return db
        }
    }
    
    // Create users table
    func createUserTable() {
        let createTableString = """
            CREATE TABLE IF NOT EXISTS User (
                email INTEGER PRIMARY KEY,
                password TEXT,
            );
        """

        var createTableStatement: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("User table is created successfully.")
            } else {
                print("User table creation failed.")
            }
        } else {
            print("User table creation failed.")
        }

        sqlite3_finalize(createTableStatement)
    }

    
    // Add new user with registration screen (name, email, password required.)
    // User should add his/her address later on Profile screen with updateUser method
    func insertUser(email: String, password: String) -> Bool{
        let users = getAllUsers()
        
        // Check user email is exist in User table or not
        for user in users{
            if user.email == email || user.password == password{
                return false
            }
        }
        
        let insertStatementString = "INSERT INTO User (email, password) VALUES (?, ?);"
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            //sqlite3_bind_int(insertStatement, 1, Int32(id))
            //sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 1, (email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (password as NSString).utf8String, -1, nil)
            //sqlite3_bind_text(insertStatement, 5, "", -1, nil) // assign empty value to address

            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("User is created successfully.")
                sqlite3_finalize(insertStatement)
                return true
            } else {
                print("Could not add.")
                return false
            }
        } else {
            print("INSERT statement is failed.")
            return false
        }
    }

    // Get all the users from User table
    func getAllUsers() -> [User] {
        let queryStatementString = "SELECT * FROM User;"
        var queryStatement: OpaquePointer? = nil
        var users : [User] = []
        if sqlite3_prepare_v2(db,  queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                //let id = sqlite3_column_int(queryStatement, 0)
                //let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let password = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                //let address = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                
                users.append(User(email: email, password: password))
                print("User Details:")
                print(" \(email) | \(password)")
            }
        } else {
            print("SELECT statement is failed.")
        }
        sqlite3_finalize(queryStatement)
        return users
    }
   
    // Get user from User table by Email
    func getUserbyEmail(email:String) -> [User] {
        let queryStatementString = "SELECT * FROM User WHERE email = ?;"
        var queryStatement: OpaquePointer? = nil
        var user : [User] = []
        
        if sqlite3_prepare_v2(db,  queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(queryStatement, 1, (email as NSString).utf8String, -1, nil)
            
            if sqlite3_step(queryStatement) == SQLITE_ROW {
               // let id = sqlite3_column_int(queryStatement, 0)
               // let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let password = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                //let address = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                
                user.append(User(email: email, password: password))
                print("User Details:")
                print("\(email) | \(password)")
            }
        } else {
            print("SELECT statement is failed.")
        }
        sqlite3_finalize(queryStatement)
        return user
    }

    // Update user on User table
    func updateUser(password: String, email: String) -> Bool{
        let updateStatementString = "UPDATE User SET password=? WHERE email=?;"
        var updateStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (password as NSString).utf8String, -1, nil)
            //sqlite3_bind_text(updateStatement, 2, (address as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 3, (email as NSString).utf8String, -1, nil)

            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("User updated successfully.")
                sqlite3_finalize(updateStatement)
                return true
            } else {
                print("Could not update.")
                return false
            }
        } else {
            print("UPDATE statement is failed.")
            return false
        }
    }
    
}
