//
//  Card.swift
//  IF26_Card_iOS
//
//  Created by yuetong on 31/12/2018.
//  Copyright © 2018 if26. All rights reserved.
//

import Foundation
import UIKit

class Card: UIViewController {
    

    @IBOutlet weak var typeimageview: UIImageView!
    
    @IBOutlet weak var codeimageview: UIImageView!
    
    @IBOutlet weak var codenum: UILabel!
    
    @IBOutlet weak var backbtn: UIBarButtonItem!
    @IBOutlet weak var comment: UITextView!
    
    var typept:Data?
    var codept:Data?
    var cm:String = ""
    var codenumber:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.typeimageview.image = UIImage(data: self.typept!)
        self.codeimageview.image = UIImage(data: self.codept!)
        self.codenum.text! = self.codenumber

    }
}
