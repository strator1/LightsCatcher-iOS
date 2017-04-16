//
//  UserInformation.swift
//  sammelAmpel
//
//  Created by Patrick Valenta on 05.04.17.
//  Copyright © 2017 Patrick Valenta. All rights reserved.
//

import Foundation
import Firebase

class UserInformation {
    
    var name: String?
    var email: String?
    var points: Int?
    
    private init() {
        self.name = "Anonymous"
    }
    
    static var shared: UserInformation = {
        return UserInformation()
    }()
    
    func setUser(dict: NSDictionary?) {
        guard let dict = dict else {
            self.name = nil
            self.email = nil
            self.points = nil
            
            return
        }
        
        self.name = dict["name"] as? String ?? ""
        self.email = dict["email"] as? String ?? ""
        self.points = dict["points"] as? Int ?? 0
        
        print("set")
    }
    
    func getUserDictionary(addToPoints: Int) -> [String: Any]? {
        guard let name = name, let email = email, let points = points else { return nil }
        
        self.points = self.points! + addToPoints
        
        var dict = [String: Any]()
        dict["name"] = name
        dict["email"] = email
        dict["points"] = points + addToPoints
        
        return dict
    }
    
    func getUid() -> String? {
        return FIRAuth.auth()?.currentUser?.uid
    }
    
    func logout(completionHandler: (Error?) -> Void) {
        do {
            try FIRAuth.auth()?.signOut()
            completionHandler(nil)
        } catch let logoutError {
            completionHandler(logoutError)
            print(logoutError)
        }
    }
    
    func isAnonymous() -> Bool {
        return isLoggedIn() ? (FIRAuth.auth()?.currentUser?.isAnonymous)! : false
    }
    
    func isLoggedIn() -> Bool {
        return FIRAuth.auth()?.currentUser?.uid != nil
    }
    
    
}

