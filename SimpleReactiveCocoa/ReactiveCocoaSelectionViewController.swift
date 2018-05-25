//
//  ReactiveCocoaSelectionViewController.swift
//  SimpleReactiveCocoa
//
//  Created by Michael on 22/5/2018.
//  Copyright © 2018 Michael. All rights reserved.
//

import UIKit

class ReactiveCocoaSelectionViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupViews()
        
    }
    
    fileprivate func setupViews() {
        
        title = "Reactive Cocoa Examples"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }

}



// MARK: - UITableViewDataSource

extension ReactiveCocoaSelectionViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.accessoryType = .disclosureIndicator
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Reactive Login"
            break
        case 1:
            cell.textLabel?.text = "Login"
            break
        case 2:
            cell.textLabel?.text = "Reactive Quote Of The Day"
            break
        case 3:
            cell.textLabel?.text = "Quote Of The Day"
        default:
            break
        }
        
        return cell
        
    }
    
}

extension ReactiveCocoaSelectionViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "toReactiveLogin", sender: nil)
            break
        case 1:
            performSegue(withIdentifier: "toLogin", sender: nil)
            break
        case 2:
            performSegue(withIdentifier: "toReactiveQOTD", sender: nil)
            break
        case 3:
            performSegue(withIdentifier: "toQOTD", sender: nil)
            break
        default:
            break
        }
        
        
    }
    
    
}
