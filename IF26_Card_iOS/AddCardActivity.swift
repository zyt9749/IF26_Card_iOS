//
//  AddCardActivity.swift
//  IF26_Card_iOS
//
//  Created by yuetong on 31/12/2018.
//  Copyright © 2018 if26. All rights reserved.
//

import Foundation
import UIKit

class AddCardActivity: UITableViewController {
    
    let TypeList:[String] = [
    "Sephora",
    "Carrefour",
    "Monoprix",
    "Darty",
    "Franprix"]
    
    var mytypename:String = ""

    
    @IBOutlet var tableview: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

     //   self.navigationController?.isNavigationBarHidden = true

        
    }
    
    @IBAction func addCardType(_ sender: UIButton) {
        let btn = sender
        mytypename = btn.currentTitle!
        
    }
    
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return TypeList.count
    }
    
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "typecell",for: indexPath)
        let typebutton = cell.viewWithTag(2) as! UIButton
        typebutton.setTitle(TypeList[indexPath.row], for: .normal)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is ScanController {
            let Scanview = segue.destination as! ScanController
            Scanview.typename = self.mytypename

        }

    }
}
