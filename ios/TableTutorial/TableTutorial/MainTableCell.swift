//
//  MainTableCell.swift
//  TableTutorial
//
//  Created by CARSON LI on 2019-05-15.
//  Copyright © 2019 WDT Coding. All rights reserved.
//

import UIKit

class MainTableCell : UITableViewCell {
    
    //Our custom table cell will only have an image and label
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var downloadTask : URLSessionDataTask!
    
    //Table Cells are a bit tricky, this method is called every time the actual cell is being reused (to prevent new ones from being created)
    //In our case, we want to cancel the current download task (so the old picture doesn't show), and then also clear the image to a default one
    override func prepareForReuse() {
        super.prepareForReuse()

        if self.downloadTask != nil{
            self.downloadTask.cancel()
        }
        
        self.displayImageView.image = UIImage.init(named: "notAvailable")
    }
    
    var userItem = Dictionary<String,Any>(){
        didSet {
            //keep the debugging statement here, it's good to see what the cell actually received when something is going wrong.
            //this is the only method that is called when the cell is properly passed the user dictionary that it needs
            //to display information
            
            //debugPrint(userItem);
            
            //don't nest the statements below together, you will want the cell to update if they have a login, but no avatar, and vice versa
            if let userName = userItem["login"] as? String{
                self.nameLabel.text = "@" + userName
            }
            
            if let avatarURL = userItem["avatar_url"] as? String{
                self.downloadImage(imageURL: avatarURL)
            }
        }
    }
    
    //the spirit of this download code is the same as the one defined in ViewController,
    //just in this case, we're trying to show the avatar picture instead, which is trivial
    //because there is a constructor to show that for the UIImage
    private func downloadImage(imageURL: String!){
        
        let myURLRequest = URLRequest.init(url: URL(string: imageURL)!);
        self.downloadTask = URLSession.shared.dataTask(with: myURLRequest as URLRequest) { (data, response, error) in
            //there was some error, let's just print it out and deal with it
            if let e = error {
                print("Could not download image: \(e)")
            } else {
                //successfully downloaded image, convert the data and put in an UIImage so that we can show it properly
                if response != nil {
                    //need to do this on the main thread, since the download happens on the background thread
                    DispatchQueue.main.async {
                        if let imageData = data {
                            let image = UIImage(data: imageData)
                            self.displayImageView.image = image
                        } else {
                            debugPrint("For some reason this image came back nil")
                        }
                    }
                } else {
                    debugPrint("No response code")
                }
            }
        }
        self.downloadTask.resume()
    }
}
