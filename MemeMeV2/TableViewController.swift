//
//  TableViewController.swift
//  MemeMeV2
//
//  Created by Dr GJK Marais on 2016/10/19.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Properties
    @IBOutlet weak var memeTable: UITableView!
    var memes: [MemeStruct] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    //Refreshes table on editor cancel
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.memeTable!.reloadData()
    }
    
    //Push preview VC
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemePreview") as! PreviewViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        let meme = self.memes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topText + " " + meme.bottomText
        cell.imageView?.image = meme.memeImage
        
        return cell
    }

}
