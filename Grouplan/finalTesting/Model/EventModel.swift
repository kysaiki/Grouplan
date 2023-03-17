//
//  EventModel.swift
//  finalTesting
//
//  Created by Kyler Saiki on 12/7/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import GoogleSignIn
import GoogleSignInSwift

//Event Model is a singleton used to store events from firebase
class EventModel {
    @Published var list = [Event]()
    @Published var selectedList = [Event]()
    var entries : [TableID] = []
    var rVal = false
    var user : String = ""
    var s : [String:Any] = [:]
    var curColor : String = ""
    var curCode : String = ""
    var curCreator : String = ""
    var curDesc : String = ""
    var curName : String = ""
    var curPeople : Int = 2
    var curOther : Bool = false
    var curScheduler : Bool = false
    var curLocations : Bool = false
    var curPeopleList : [String] = []
    public static let sharedInstance = EventModel()
    
    init() {
        loadData()
    }
    
    //set user to google user
    func setUser(u: String) {
        self.user = u
    }
    
    //load user data from firebase
    func loadData() {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let eventsFilePath = documentsUrl.appendingPathComponent("eventData.plist")

        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        
        if url.appendingPathComponent("eventData.plist") != nil {
            let decoder = PropertyListDecoder()
            do {
                let data = try Data(contentsOf: eventsFilePath)
                let events = try decoder.decode(Array<TableID>.self, from: data)
                self.entries = events
            } catch {
            }
        } else {
            do {
                getData()
                for ev in list {
                    entries.append(TableID(eventName: ev.eventName, eventID: ev.eventID))
                }
            }
        }
        removeDuplicates()
        save()
    }
    
    //delete a firebase document
    func deleteDocument(name: String, id: String) {
        let db = Firestore.firestore()
        db.collection("events").document((name + "-" + id)).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    //update a firebase entry
    func updateEntry(name: String, id: String, creator: String, color: String, description: String, peopleNumber: Int) {
        let db = Firestore.firestore()
        db.collection("events").document((creator + "-" + id)).updateData(["name":name, "id":id, "creator":creator, "color":color, "description":description, "people-num":peopleNumber]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }}
    }
    
    //remove duplicate firebase entries
    func removeDuplicates() {
        var result = [TableID]()
        for value in entries {
            if (!result.contains(value)) {
                result.append(value)
            }
        }
        entries = result
    }
    
    //add a new firebase entry
    func addData(name: String, id: String, creator: String, color: String, description: String, peopleNumber: Int, otherInfo: Bool, locations: Bool, scheduler: Bool) {
        print(self.user)
        let dict : [String: Any] = ["name":name, "id":id, "creator":creator, "color":color, "description":description, "people-num":peopleNumber, "locations":locations, "scheduler": scheduler, "other-info":otherInfo]
        let db = Firestore.firestore()
        db.collection("events").document((creator + "-" + id)).setData(dict)
    }
    
    //get firebase entries
    func getData() {
        let db = Firestore.firestore()
        let query = db.collection("events").whereField("creator", isEqualTo: self.user)
    
        query.getDocuments() { (snapshot, error) in
            if let err = error {
                print("Error getting documents: \(err)");
            }
            DispatchQueue.main.async {
                for document in snapshot!.documents {
                    let info = document.data()
                    self.list.append(Event(eventName: info["name"] as! String, eventID: info["id"] as! String, eventCreator: info["creator"] as! String, eventColor: info["color"] as! String, eventDescription: info["description"] as! String, peopleNumber: info["people-num"] as! Int, otherInfo: info["other-info"] as! Bool, locations: info["locations"] as! Bool, scheduler: info["scheduler"] as! Bool))
                }
            }
        }
        return
    }
    
    //check if ID is in the firebase
    func isIDInList(id : String) -> Bool {
        self.rVal = false
        let db = Firestore.firestore()
        let query = db.collection("events").whereField("id", isEqualTo: id)
        
        query.getDocuments() { (snapshot, error) in
            if let err = error {
                print("Error getting documents: \(err)");
            }
            for document in snapshot!.documents {
                if (document.data()["id"] as! String == id) {
                    self.rVal = true
                    return
                }
            }
        }
        return self.rVal
    }
    
    //find event in firebase using ID
    func getEventFromID(id: String) {
        let db = Firestore.firestore()
        let query = db.collection("events").whereField("id", isEqualTo: id)
        query.getDocuments() { (snapshot, error) in
            if let err = error {
                print("Error getting documents: \(err)");
            }
            DispatchQueue.main.async {
                print(snapshot!.documents)
                for document in snapshot!.documents {
                    print("D:", document.data())
                    self.s = document.data()
                    self.curCode = self.s["id"] as! String
                    self.curName = self.s["name"] as! String
                    self.curDesc =  self.s["description"] as! String
                    self.curColor = self.s["color"] as! String
                    self.curCreator = self.s["creator"] as! String
                    self.curPeople = self.s["people-num"] as! Int
                    self.curOther = self.s["other-info"] as! Bool
                    self.curScheduler = self.s["scheduler"] as! Bool
                    self.curLocations = self.s["locations"] as! Bool
                }
            }
        }
        return
    }

    //save events to persistent storage
    func save() {
        let manager = FileManager.default
        _ = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let eventsFilePath = documentsUrl.appendingPathComponent("eventData.plist")
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.entries)
            try data.write(to: eventsFilePath)
        } catch {
            print("Error")
        }
    }
}
