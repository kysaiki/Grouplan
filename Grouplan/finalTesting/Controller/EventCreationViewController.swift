//
//  ViewController.swift
//  finalTesting
//
//  Created by Kyler Saiki on 12/5/22.
//

import UIKit
import GoogleSignInSwift
import GoogleSignIn

class EventCreationViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var colorSelector: UISegmentedControl!
    var eventCode = ""
    var name = ""
    var sectionAmount : Int = 1
    var colorSelected : String = "blue"
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
    
    @IBOutlet weak var enableScheduleHelper: UISwitch!
    @IBOutlet weak var enableLocationFinder: UISwitch!
    @IBOutlet weak var enableOtherInfo: UISwitch!
    @IBOutlet weak var eventDescription: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundGradientView: UIView!
    @IBOutlet weak var numberOfPeople: UILabel!
    @IBOutlet weak var peopleStepper: UIStepper!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var eventNameField: UITextField!
    @IBOutlet weak var eventDescriptionView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeBackgroundGradient(color: "b")
        self.eventDescriptionView.delegate = self
        self.eventNameField.delegate = self
        self.nextButton.isEnabled = false
        self.eventDescriptionView.becomeFirstResponder()
    }
    
    //enable the next button if the name field and text view are changed
    @IBAction func nameFieldEdited(_ sender: UITextField) {
        enableNextButton()
    }
    
    //enable the next button if the name field and text view are changed
    func textViewDidChange(_ textView: UITextView) {
        enableNextButton()
    }
    
    //enable the next button if the name field and text view are changed
    func enableNextButton() {
        self.nextButton.isEnabled = (eventDescriptionView.text!.count > 0 && eventNameField.text!.count > 0)
    }
    
    //end editing in text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    //dismiss keyboard when tapped outside
    @IBAction func tapOutside(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    //change people stepper integer and label
    @IBAction func changedPeopleStepper(_ sender: UIStepper) {
        self.numberOfPeople.text = String(Int(peopleStepper.value))
    }
    
    // change background color based on the segmentedIndex
    @IBAction func colorSelected(_ sender: Any) {
        if (colorSelector.selectedSegmentIndex == 0) {
            colorSelector.selectedSegmentTintColor = UIColor(red: 12/255, green: 163/255, blue: 255/255, alpha: 1)
            changeBackgroundGradient(color: "b")
        } else if (colorSelector.selectedSegmentIndex == 1) {
            colorSelector.selectedSegmentTintColor = UIColor(red: 159/255, green: 237/255, blue: 161/255, alpha: 1)
            changeBackgroundGradient(color: "g")
        } else if (colorSelector.selectedSegmentIndex == 2) {
            colorSelector.selectedSegmentTintColor = UIColor(red: 208/255, green: 145/255, blue: 146/255, alpha: 1)
            changeBackgroundGradient(color: "r")
        } else if (colorSelector.selectedSegmentIndex == 3) {
            colorSelector.selectedSegmentTintColor = UIColor(red: 248/255, green: 213/255, blue: 104/255, alpha: 1)
            changeBackgroundGradient(color: "o")
        } else if (colorSelector.selectedSegmentIndex == 4) {
            colorSelector.selectedSegmentTintColor = UIColor(red: 181/255, green: 137/255, blue: 214/255, alpha: 1)
            changeBackgroundGradient(color: "p")
        }
    }
    
    //change background gradient using an input string
    func changeBackgroundGradient(color : String) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        switch color {
        case "b":
            gradientColorLight = "Blue1"
            gradientColorDark = "Blue2"
            colorSelected = "blue"
            break
        case "r":
            gradientColorLight = "Red1"
            gradientColorDark = "Red2"
            colorSelected = "red"
            break
        case "g":
            gradientColorLight = "Green1"
            gradientColorDark = "Green2"
            colorSelected = "green"
            break
        case "o":
            gradientColorLight = "Orange1"
            gradientColorDark = "Orange2"
            colorSelected = "orange"
            break
        case "p":
            colorSelected = "purple"
            gradientColorLight = "Purple1"
            gradientColorDark = "Purple2"
            break
        default:
            colorSelected = "blue"
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
    
    //segue to the next view controller and order data
    @IBAction func nextButtonPressed(_ sender: Any) {
        self.name = eventNameField.text!
        eventCode = randomString(length: 6)
        EventModel.sharedInstance.addData(name: eventNameField.text!, id: eventCode, creator: GIDSignIn.sharedInstance.currentUser?.profile?.name ?? "test-events", color: self.colorSelected, description: eventDescription.text!, peopleNumber: Int(self.peopleStepper.value), otherInfo: self.enableOtherInfo.isOn, locations: self.enableLocationFinder.isOn, scheduler: self.enableScheduleHelper.isOn)
        EventModel.sharedInstance.entries.append(TableID(eventName: eventNameField.text!, eventID: eventCode))
        EventModel.sharedInstance.getEventFromID(id: eventCode)
        EventModel.sharedInstance.save()
    }
    
    //dismiss view controller and segue back
    @IBAction func backArrowPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //get a random ID for usage
    func randomString(length: Int) -> String {
      let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

