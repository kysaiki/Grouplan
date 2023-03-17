//
//  TableID.swift
//  finalTesting
//
//  Created by Kyler Saiki on 12/7/22.
//

import Foundation

//tableID for persistent storage
struct TableID:Codable, Equatable {
    var eventName : String
    var eventID : String
    
    func getName() -> String {
        return self.eventName
    }
    func getID() -> String {
        return self.eventID
    }
}
