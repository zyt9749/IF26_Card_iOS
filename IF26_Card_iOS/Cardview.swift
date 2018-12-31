//
//  Cardview.swift
//  IF26_Card_iOS
//
//  Created by yuetong on 21/12/2018.
//  Copyright © 2018 if26. All rights reserved.
//

import Foundation
import UIKit
import SQLite

class Cardview: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    
    @IBOutlet weak var addcard: UIBarButtonItem!
    var database: Connection!
    let users_table = Table("users")
    private let ATTRIBUT_NUMBER = Expression<String>("cardnumber")
    private let ATTRIBUT_CODEPHOTO = Expression<Data>("codephoto")
    private let ATTRIBUT_TYPEPHOTO = Expression<Data>("typephoto")
    private let ATTRIBUT_COMMENT = Expression<String>("comment")
    private let ATTRIBUT_TYPENAME = Expression<String>("typename")
    
    var tableExist = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        let base = try! Connection("\(path)/db.sqlite3")
        self.database = base;
         print ("--> viewDidLoad fin")
        self.createTable()
        
        let dataC = UIImage(named: "carrefour.png")!
        let imgDataC =  dataC.pngData()!
        let dataD = UIImage(named: "darty.png")!
        let imgDataD =  dataD.pngData()!
        let dataF = UIImage(named: "fnac.png")!
        let imgDataF =  dataF.pngData()!
        let dataS = UIImage(named: "sephora.png")!
        let imgDataS =  dataS.pngData()!

        //let imagelist: [UIImage] =
        self.insertData(_cardnumber: "8765790", _codephoto: imgDataC, _typephoto: imgDataC, _comment: "XXX", _typename: "Carrefour")
        self.insertData(_cardnumber: "7890054", _codephoto: imgDataD, _typephoto: imgDataD, _comment: "AAA", _typename: "Darty")
        self.insertData(_cardnumber: "8532246", _codephoto: imgDataF, _typephoto: imgDataF, _comment: "BBB", _typename: "Fnac")
        self.insertData(_cardnumber: "6764339", _codephoto: imgDataS, _typephoto: imgDataS, _comment: "CCC", _typename: "Sephora")
        collectionview.dataSource = self
        
    }
    func createTable() {
        if !self.tableExist {
            self.tableExist = true;
            let dropTable = self.users_table.drop(ifExists: true)
            
            let createTable = self.users_table.create {
                table in
                table.column(self.ATTRIBUT_NUMBER, primaryKey: true)
                table.column(self.ATTRIBUT_CODEPHOTO)
                table.column(self.ATTRIBUT_TYPEPHOTO)
                table.column(self.ATTRIBUT_COMMENT)
                table.column(self.ATTRIBUT_TYPENAME)
            }
                
                do {// Exécution du drop et du create
                    try self.database.run(dropTable)
                    try self.database.run(createTable)
                    print ("Table users est créée")}
                catch {
                    print (error)
                }
            }
    }
    
    func insertData(_cardnumber: String, _codephoto: Data, _typephoto: Data, _comment: String, _typename: String){
        
        let insert = self.users_table.insert(self.ATTRIBUT_NUMBER <- _cardnumber, self.ATTRIBUT_CODEPHOTO <- _codephoto, self.ATTRIBUT_TYPEPHOTO <- _typephoto, self.ATTRIBUT_COMMENT <- _comment, self.ATTRIBUT_TYPENAME <- _typename)
        
        do {
            try self.database.run(insert)
        } catch {
            print(error)
        }
    }
    
        
            
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "mycell", for: indexPath)
        do {
            let users = try self.database.prepare(self.users_table)
            var imagedatalist: [Data] = []
            for user in users {
                imagedatalist.append(user[ATTRIBUT_TYPEPHOTO])
            }
            var imagelist: [UIImage] = []
            for data in imagedatalist {
                let img = UIImage(data: data)
                imagelist.append(img!)
            }
            let imgview = cell.viewWithTag(1) as! UIImageView
            imgview.image = imagelist[indexPath.row]
        }
        catch {
            print("--> selectUSers est en erreur")
        }
      return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AddCardActivity{
            //let AddCard = segue.destination as! AddCardActivity
            
        }
        
    }
    
    
    
}
