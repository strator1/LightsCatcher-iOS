//
//  ConnectionStateManager.swift
//  sammelAmpel
//
//  Created by Patrick Valenta on 17.05.17.
//  Copyright © 2017 Patrick Valenta. All rights reserved.
//

import Foundation
import Firebase

enum ConnectionState {
    case online
    case offline
}

protocol FIRPersistenceConnectionStateDelegate {
    func executedOfflineWriteOperation()
    func connectionState(didChangeTo: ConnectionState)
}

class ConnectionStateManager {
    
    var connectionStateDelegate: FIRPersistenceConnectionStateDelegate?

    var isConnectedToInternet = true {
        didSet {
            self.connectionState = isConnectedToInternet ? ConnectionState.online : ConnectionState.offline
            self.connectionStateDelegate?.connectionState(didChangeTo: self.connectionState)
        }
    }
    
    var connectionState: ConnectionState = .online
    
    private init() {

    }
    
    static var shared: ConnectionStateManager = {
        return ConnectionStateManager()
    }()
    
    func initConnectionStateListener() {
        let connectedRef = FIRDatabase.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool {
                self.isConnectedToInternet = connected
            } else {
                self.isConnectedToInternet = false
            }
        })
    }
    
}
