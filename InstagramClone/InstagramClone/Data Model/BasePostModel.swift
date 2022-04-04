//
//  BasePostModel.swift
//  InstagramClone
//
//  Created by Jaspinder Singh on 11/03/22.
//  Copyright © 2020 Jaspinder Singh. All rights reserved.
//

import Foundation
import ObjectMapper

class UserPostData: BaseData {
    var email = ""
    var password = ""
    var username = ""
    
    init(email: String,password: String,username:String) {
        super.init()
        self.email = email
        self.password = password
        self.username = username
    }
    
    required init?(map: Map) {
        super.init(map: map)
//        fatalError("init(map:) has not been implemented")
    }
    

    override func mapping(map: Map) {
        super.mapping(map: map)

        email <- map["email"]
        password <- map["password"]
        username <- map["username"]
        
    }
    
    
}


class LoginPostData {
    var email = ""
    var password = ""
    
    init(email: String,password:String) {
        self.email = email
        self.password = password
    }
}
