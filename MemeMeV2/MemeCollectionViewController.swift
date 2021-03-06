//
//  MemeCollectionViewController.swift
//  MemeMeV2
//
//  Created by Dr GJK Marais on 2016/10/20.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    //MARK: Properties
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var memes: [MemeStruct] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 8.0
        let dimension = (min(view.frame.size.width, view.frame.size.height) - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView!.reloadData()
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
    
        cell.memeImage?.image = meme.memeImage
        
        return cell
    }
    
    //Segue to meme preview
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemePreview") as! PreviewViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
   
}
