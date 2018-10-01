//
//  InformationController.swift
//  KLMDemo
//
//  Created by Atul Kumar on 9/21/18.
//  Copyright © 2018 Atul Kumar. All rights reserved.
//

import Foundation
import UIKit

class InformationController:UIViewController {
    // UI Outles
    @IBOutlet var tableView:UITableView?
    @IBOutlet var versionLabel:UILabel?
    
    fileprivate let cellIdentifier =  "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.register(UINib(nibName: "InformationCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        if let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            // String concatenation
            versionLabel?.text =   Constants.versionText  + versionNumber + Constants.dotText
        }
    }
}
extension InformationController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.informationCellCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier:cellIdentifier) as? InformationCell
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier) as? InformationCell
        }
        switch indexPath.row {
        case 0:
            cell?.cellTextLabel?.text = Constants.aboutKLMText
        case 1:
            cell?.cellTextLabel?.text = Constants.historyKLMText
        case 2:
            cell?.cellTextLabel?.text = Constants.contactKLMText
        case 3:
            cell?.cellTextLabel?.text = Constants.shareYourFeedbackText
        default:
            break
        }
        return cell ?? UITableViewCell()
    }
}


