//
//  CurrentSession.swift
//  InstagramClone
//
//  Created by Jaspinder Singh on 11/03/22.
//  Copyright © 2020 Jaspinder Singh. All rights reserved.
//

import Foundation

class CurrentSession {
    let Authorization = ""
    let KEY_LOCAL_DATA = "local"
    let KEY_PROFILE = "profile"
    let KEY_SESSION = "session"
    let key_Login = "login"
    let key_competition = "competition"
    let key_registerData = "register"
    let KEY_Token = "token"
    let Key_GameScore = "gameScore"
    let KEY_ClaimRewards = "claimrewards"
    var Key_leaderboard = "leaderboardResult"
    private static var i : CurrentSession!

    
    let dobFormatter = DateFormatter()
    var sessionId = "$2y$10$pt7cH/DseV9o5Nw/m3t8c.OWJ1Td2yoNFE1SwOlYOlE5ZCOiZTp3G"

    var profile : ProfileData!
    var userData: UserData!
    var loginData = LoginResponseData()
    var localData = LocalData()
    var token = ""
    var gameScore = ""
    var isLiking = false

    static func getI() -> CurrentSession {
        
        if i == nil {
            i = CurrentSession()
        }
        
        return i
    }
    
    init() {

        if let data = UserDefaults.standard.object(forKey: KEY_PROFILE) as? Data {
            let unarc = NSKeyedUnarchiver(forReadingWith: data)
            profile = unarc.decodeObject(forKey: "root") as! ProfileData
        }

        if let data = UserDefaults.standard.string(forKey: KEY_LOCAL_DATA){
            localData = LocalData(JSONString: data) ?? LocalData()
        }
        if let data = UserDefaults.standard.string(forKey: key_Login){
            loginData = LoginResponseData(JSONString: data) ?? LoginResponseData()
        }
      
        if let data = UserDefaults.standard.string(forKey: KEY_Token){
            token = data
        }
        if let data = UserDefaults.standard.string(forKey: Key_GameScore){
            gameScore = data
        }
     
        self.isLiking = UserDefaults.standard.bool(forKey: "isLiking")

        
        if profile == nil {
            profile = ProfileData()
        }
        
        sessionId = UserDefaults.standard.string(forKey: KEY_SESSION) ?? ""
        dobFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    func saveData() {
//        print(localData.toJSONString())
        let ud = UserDefaults.standard
        ud.set(NSKeyedArchiver.archivedData(withRootObject: profile), forKey: KEY_PROFILE)
        ud.set(sessionId, forKey: KEY_SESSION)
        ud.set(localData.toJSONString() ?? "", forKey: KEY_LOCAL_DATA)
        ud.set(loginData.toJSONString() ?? "", forKey: key_Login)
       
        ud.set(token, forKey: KEY_Token)
        ud.set(gameScore, forKey: Key_GameScore)
        ud.set(self.isLiking, forKey: "isLiking")
    }

    func isUserLoginIn() -> Bool {
        return !sessionId.isEmpty
    }

    func onLogout() {
        sessionId = ""
        profile = ProfileData()
        saveData()
    }
}
