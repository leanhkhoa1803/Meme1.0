//
//  CollectionViewController.swift
//  memeapp
//
//  Created by Khoa on 08/03/2024.
//

import Foundation
import UIKit

class CollectionViewController : UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UINavigationBarDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes = [Meme]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Reload data when the view is about to appear
        self.memes = appDelegate.memes
        self.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        let width = (collectionView.bounds.width - (10.0 * (space - 1))) / space
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        // Access UserDefaults
        let userDefaults = UserDefaults.standard
        
        // Retrieve the encoded data from UserDefaults
        if let savedData = userDefaults.data(forKey: "memes") {
            // Decode the data into an array of Meme objects
            let decoder = JSONDecoder()
            if let decodedMemes = try? decoder.decode([Meme].self, from: savedData) {
                // Use the decodedMemes array
                self.memes = decodedMemes
                
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let villain = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.villainImageView?.image = villain.memedImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
