//
//  EventListViewController.swift
//  finalTesting
//
//  Created by Kyler Saiki on 12/7/22.
//

import UIKit
import GoogleSignIn
import GoogleSignInSwift

class EventListViewController: UIViewController {

    var code = ""
    var info : [String:Any] = [:]
    var color : String = ""

    @IBOutlet weak var backgroundGradientView: UIView!
    @IBOutlet weak var tableView: UITableView!
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
        self.changeBackgroundGradient(color: "o")
        tableView.delegate = self
        tableView.dataSource = self
        EventModel.sharedInstance.loadData()
        EventModel.sharedInstance.save()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    //reload the table when refresh button clicked
    @IBAction func reloadTable(_ sender: UIButton) {
        EventModel.sharedInstance.loadData()
        sleep(1)
        self.tableView.reloadData()
    }
    
    //dismiss view controller and segue back
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
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
}


//uitableviewdelegate for custom table view of users events
extension EventListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.code = EventModel.sharedInstance.entries[indexPath.row].getID()
            EventModel.sharedInstance.getEventFromID(id: self.code)
        }
        
    }
    
    func handleMoveToTrash(name: String, id: String) {
        EventModel.sharedInstance.deleteDocument(name: name, id: id)
    }
}

//tableviewdatasource for custom table view of users events
extension EventListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventModel.sharedInstance.entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        //cell.text = ""
        cell.layer.borderWidth = 5.0
        cell.layer.cornerRadius = 10.0
        cell.textLabel?.font = UIFont(name: "Avenir Heavy", size: 18.0)
        
        cell.detailTextLabel?.text = "AAAAAA"
        cell.detailTextLabel?.font = UIFont(name: "Avenir Heavy", size: 18.0)
        
        cell.textLabel?.text = EventModel.sharedInstance.entries[indexPath.row].getName()
        cell.detailTextLabel?.text = EventModel.sharedInstance.entries[indexPath.row].getID()

        return cell
    }
}

