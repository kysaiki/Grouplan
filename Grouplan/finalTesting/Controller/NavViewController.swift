//
//  NavViewController.swift
//  finalTesting
//
//  Created by Kyler Saiki on 12/6/22.
//

import UIKit

class NavViewController: UINavigationController {

    //pass along data from the Navigation Controller --- not really necessary
    var fullName : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ActionsViewController
        destinationVC.fullName = self.fullName
    }
    

}
