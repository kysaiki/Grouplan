//
//  JoinEventViewController.swift
//  finalTesting
//
//  Created by Kyler Saiki on 12/6/22.
//

import UIKit
import GoogleSignInSwift
import GoogleSignIn

class JoinEventViewController: UIViewController, UITextFieldDelegate {
    var code : String = ""
    var id : String = ""
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
    
    @IBOutlet weak var backgroundGradientView: UIView!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var idTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeBackgroundGradient(color: "r")
        enterButton.tintColor = UIColor(red: 210/255, green: 46/255, blue: 123/255, alpha: 1)
        enterButton.isEnabled = false
    }
    
    //check if textfield length is 6, if so then enable join/enter button
    @IBAction func textFieldEdited(_ sender: UITextField) {
        if (idTextField.text?.count == 6) {
            self.enterButton.isEnabled = true
        } else {
            self.enterButton.isEnabled = false
        }
        
        if (idTextField.text!.count > 6) {
            idTextField.text = String(idTextField.text!.prefix(5))
        }
    }
    
    //change background view to gradient
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

    //dismiss vc and segue back
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //return text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    //join an event if the id is valid
    @IBAction func joinClicked(_ sender: UIButton) {
        EventModel.sharedInstance.getEventFromID(id: self.idTextField.text!)
        self.idTextField.text = ""
        self.enterButton.isEnabled = false
        performSegue(withIdentifier: "joined", sender: self)
    }
}
