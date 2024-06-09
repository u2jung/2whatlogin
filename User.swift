//
//  User.swift
//  2what
//
//  Created by 김유정 on 6/4/24.
//

import Foundation

class User{
    var email: String
    var age: Int
    var job: String
    var address: String
    var jender: String
    
    init(email: String, age: Int, job: String, address: String, jender: String){
        self.email = email
        self.age = age
        self.job = job
        self.address = address
        self.jender = jender
    }
}

class login{
    var email: String
    var password: String
    
    init(email: String, password: String){
        self.email = email
        self.password = password
    }
}

