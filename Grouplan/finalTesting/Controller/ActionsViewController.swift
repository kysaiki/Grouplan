//
//  ActionsViewController.swift
//  finalTesting
//
//  Created by Kyler Saiki on 12/6/22.
//

import UIKit
import GoogleSignInSwift
import GoogleSignIn

class ActionsViewController: UIViewController {
    
    @IBOutlet weak var createEventButton: UIButton!
    @IBOutlet weak var viewEventsButton: UIButton!
    @IBOutlet weak var joinEventButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var backgroundGradientView: UIView!
    
    var gradientColorLight : String = "Blue1"
    var gradientColorDark : String = "Blue2"
    var fullName : String = ""
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
        self.changeBackgroundGradient(color : "b")
    }
    
    //display name and show options to user
    override func viewWillAppear(_ animated: Bool) {
        if ((GIDSignIn.sharedInstance.currentUser?.profile?.name) != nil) {
            fullName = "Welcome, " + ((GIDSignIn.sharedInstance.currentUser?.profile?.name)!)
            self.welcomeLabel.text = fullName
        } else {
            self.welcomeLabel.text = ""
        }
        
        DispatchQueue.main.async {
            if (GIDSignIn.sharedInstance.hasPreviousSignIn() || GIDSignIn.sharedInstance.currentUser?.profile?.name != nil) {
                self.createEventButton.isEnabled = true
                self.joinEventButton.isEnabled = true
                self.viewEventsButton.isEnabled = true
                self.signOutButton.titleLabel?.text = "Sign Out"
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //if signed in, change interface
    func signedInView() {
        self.createEventButton.isEnabled = true
        self.joinEventButton.isEnabled = true
        self.viewEventsButton.isEnabled = true
        self.signOutButton.titleLabel?.text = "Sign Out"
    }
    
    //change background gradient using a string input
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
    
    //Google Sign Out
    @IBAction func signOut(sender: Any) {
      GIDSignIn.sharedInstance.signOut()
        dismiss(animated: true, completion: nil)
        
    }
}
