//
//  MemeDetailViewController.swift
//  memeapp
//
//  Created by Khoa on 20/03/2024.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    // MARK: Properties
    
    var meme: Meme!
    
    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        
        self.imageView!.image = self.meme.memedImage
        self.label.text = self.meme.topText + " " + self.meme.bottomText
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = true
    }
}
