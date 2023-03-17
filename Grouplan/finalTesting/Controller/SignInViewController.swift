//
//  SignInViewController.swift
//  finalTesting
//
//  Created by Kyler Saiki on 12/6/22.
//

import UIKit
import GoogleSignInSwift
import GoogleSignIn

class SignInViewController: UIViewController {
    @IBOutlet weak var backgroundGradientView: UIView!
    var fullName : String = ""
    let signInConfig = GIDConfiguration(clientID: "792144453667-em4mgsrf3sqee0nis4q2gh0eo0q4vot3.apps.googleusercontent.com")
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
        self.changeBackgroundGradient(color: "b")
    }
    
    //if already signed in, move to next vc
    override func viewDidAppear(_ animated: Bool) {
        if (GIDSignIn.sharedInstance.hasPreviousSignIn()) {
            self.performSegue(withIdentifier: "signedIn", sender: self)
        }
    }
    
    
    //Google Sign in
    @IBAction func signIn(_ sender: UIButton) {
        if (GIDSignIn.sharedInstance.hasPreviousSignIn()) {
            return
        }
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            self.fullName = user.profile?.name ?? ""
        }
        self.performSegue(withIdentifier: "signedIn", sender: self)
    }
    
    
    //change background gradient using an input string
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

    //prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! NavViewController
        destinationVC.fullName = self.fullName
    }
}
