//
//  ViewController.swift
//  memeapp
//
//  Created by Khoa on 01/03/2024.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var memes = [Meme]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Reload data when the view is about to appear
        self.memes = appDelegate.memes
        self.tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CustomTableViewCell
        let villain = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.customTitleLabel?.text = villain.topText + " " + villain.bottomText
        
        cell.customImageView?.image = villain.memedImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

