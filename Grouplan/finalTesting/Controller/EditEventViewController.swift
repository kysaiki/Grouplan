//
//  EditEventViewController.swift
//  finalTesting
//
//  Created by Kyler Saiki on 12/7/22.
//

import UIKit
import GoogleSignIn
import GoogleSignInSwift
import EventKit
import EventKitUI
import Contacts
import ContactsUI
import MessageUI

class EditEventViewController: UIViewController,UITextViewDelegate, EKEventEditViewDelegate, CNContactPickerDelegate, MFMessageComposeViewControllerDelegate {
    
    let eventStore = EKEventStore()
    
    @IBOutlet weak var userCellPhone: UITextField!
    @IBOutlet weak var recipientCellPhone: UITextField!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var backgroundGradientView: UIView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventCode: UILabel!
    @IBOutlet weak var eventCreator: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    
    var initialUpdate : Bool = false
    var peopleList : [String] = []
    var edited : Bool = false
    var info : [String:Any] = [:]
    var code: String = ""
    var name: String = ""
    var creator: String = ""
    var color: String = ""
    var desc: String = ""
    var people: Int = 2
    var date: Date = Date()
    var otherInfo: Bool = true
    var scheduler: Bool = true
    var locations: Bool = true
    var loaded: Bool = false
    var gradientColorLight : String = "Blue1"
    var gradientColorDark : String = "Blue2"
    var colorDict: [String: CGColor] = ["Blue1":UIColor(red: 12/255, green: 163/255, blue: 255/255, alpha: 1).cgColor,
                                       "Blue2":UIColor(red: 0/255, green: 122/255, blue: 254/255, alpha: 1).cgColor,
                                       "Green1":UIColor(red: 159/255, green: 237/255, blue: 161/255, alpha: 1).cgColor,
                                       "Green2":UIColor(red: 8/255, green: 187/255, blue: 108/255, alpha: 1).cgColor,
                                        "Red1":UIColor(red: 208/255, green: 145/255, blue: 146/255, alpha: 1).cgColor,
                                        "Red2":UIColor(red: 200/255, green: 36/255, blue: 113/255, alpha: 1).cgColor,
                                        "Orange1":UIColor(red: 248/255, green: 213/255, blue: 104/255, alpha: 1).cgColor,
                                        "Orange2":UIColor(red: 186/255, green: 120/255, blue: 45/255, alpha: 1).cgColor,
                                        "Purple1":UIColor(red: 181/255, green: 137/255, blue: 214/255, alpha: 1).cgColor,
                                        "Purple2":UIColor(red: 106/255, green: 45/255, blue: 186/255, alpha: 1).cgColor,]

    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.isEnabled = true
        EventModel.sharedInstance.setUser(u: GIDSignIn.sharedInstance.currentUser?.profile?.name ?? "test-events")
        EventModel.sharedInstance.getData()
        self.descTextView.delegate = self
        self.shareButton.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.updateView()
        }
    }
    
    //update the view and firebase whenever text is typed
    func textViewDidEndEditing(_ textView: UITextView) {
        updateView()
    }
    
    //dismiss view controller and segue back
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    //compose a text
    func displayMessageInterface() {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        if MFMessageComposeViewController.canSendText() {
            let controller = MFMessageComposeViewController()
            composeVC.recipients = [recipientCellPhone.text!]
            composeVC.body = EventModel.sharedInstance.curName + "is planning an event.  Download Grouplan and enter code: " + EventModel.sharedInstance.curCode + "to view the event."
            controller.messageComposeDelegate = self
            present(controller, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }
    
    //update the view and send updates to firebase
    func updateView() {
        DispatchQueue.main.async {
            self.backgroundGradientView.layer.zPosition -= 10
            EventModel.sharedInstance.entries.append(TableID(eventName: EventModel.sharedInstance.curName, eventID: EventModel.sharedInstance.curCode))
            EventModel.sharedInstance.removeDuplicates()
            EventModel.sharedInstance.save()
            self.changeBackgroundGradient(color: String(EventModel.sharedInstance.curColor.prefix(1)))
            self.eventName.text = EventModel.sharedInstance.curName
            self.eventCreator.text = EventModel.sharedInstance.curCreator
            self.eventCode.text = EventModel.sharedInstance.curCode
            if (!self.initialUpdate) {
                self.descTextView.text = EventModel.sharedInstance.curDesc
            }
            self.people = EventModel.sharedInstance.curPeople
            EventModel.sharedInstance.updateEntry(name: self.eventName.text!, id: self.eventCode.text!, creator: self.eventCreator.text!, color: self.color, description: self.descTextView.text, peopleNumber: self.people)
            self.initialUpdate = true
        }
    }
    
    //calendar dismiss
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //text field for the recipients phone number is finished editing
    @IBAction func recipientPhoneEdited(_ sender: UITextField) {
        if (recipientCellPhone.text!.count > 11) {
            recipientCellPhone.text = String(recipientCellPhone.text!.prefix(11))
        }
        if (userCellPhone.text!.count == 11 && recipientCellPhone.text!.count == 11) {
            shareButton.isEnabled = true
        }
    }
    
    //text field for the user's phone number is finished editing
    @IBAction func userPhoneEdited(_ sender: UITextField) {
        if (userCellPhone.text!.count > 11) {
            userCellPhone.text = String(recipientCellPhone.text!.prefix(11))
        }
        if (userCellPhone.text!.count == 11 && recipientCellPhone.text!.count == 11) {
            shareButton.isEnabled = true
        }
    }
    
    //add an event to your calendar using eventkit
    @IBAction func addToCalendar(_ sender: UIButton) {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .notDetermined:
            eventStore.requestAccess(to: .event) { granted, error in
                if granted {
                    print("Authorized")
                    self.presentEventVC()
                }
            }
        case .authorized:
            print("Authorized")
            self.presentEventVC()
        default:
            break
        }
    }
    
    
    //show the calendar view controller
    func presentEventVC() {
        let eventVC = EKEventEditViewController()
        eventVC.editViewDelegate = self
        eventVC.eventStore = EKEventStore()
        let event = EKEvent(eventStore: eventVC.eventStore)
        event.title = self.eventName.text
        event.startDate = Date()
        event.notes = self.descTextView.text
        eventVC.event = event
        self.present(eventVC, animated: true, completion: nil)
    }
    
    //change the background gradient using an input string
    func changeBackgroundGradient(color : String) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        switch color {
        case "b":
            gradientColorLight = "Blue1"
            gradientColorDark = "Blue2"
            break
        case "r":
            gradientColorLight = "Red1"
            gradientColorDark = "Red2"
            break
        case "g":
            gradientColorLight = "Green1"
            gradientColorDark = "Green2"
            break
        case "o":
            gradientColorLight = "Orange1"
            gradientColorDark = "Orange2"
            break
        case "p":
            gradientColorLight = "Purple1"
            gradientColorDark = "Purple2"
            break
        default:
            gradientColorLight = "Blue1"
            gradientColorDark = "Blue2"
            break
        }
        gradientLayer.colors = [colorDict[gradientColorLight]!, colorDict[gradientColorDark]!]
        gradientLayer.shouldRasterize = true
        backgroundGradientView.layer.addSublayer(gradientLayer)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        return
    }
    
    //end text editing when tapped outside
    @IBAction func tappedOutside(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    //end text view editing on return key click
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.view.endEditing(true)
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    //cases for composing a message
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        switch result {
        case .cancelled:
            print("Cancelled case")
        case .failed:
            print("failed case")
        case .sent:
            print("Sent case")
        default:
            break
        }
        controller.dismiss(animated: true)
    }
    
    //share button pressed
    @IBAction func sharePressed(_ sender: UIButton) {
        displayMessageInterface()
    }
}

////unused
//extension EditEventViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
//}
//
////unused
//extension EditEventViewController: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        1
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.people
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
//        //cell.text = ""
//        cell.textLabel?.font = UIFont(name: "Avenir Heavy", size: 18.0)
//        cell.textLabel?.text = "Add Person"
//        return cell
//    }
//}
