//
//  PreviewViewController.swift
//  MemeMeV2
//
//  Created by Dr GJK Marais on 2016/10/19.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    @IBOutlet weak var imagePreview: UIImageView!
    var meme: MemeStruct?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imagePreview!.image = meme?.memeImage
        self.tabBarController?.tabBar.isHidden = true
}
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
