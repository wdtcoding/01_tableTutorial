//
//  ViewController.swift
//  TableTutorial
//
//  Created by CARSON LI on 2019-05-15.
//  Copyright © 2019 WDT Coding. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var reloadButton: UIButton!
    
    var users : [Any?] = [] //main data structure we're working with
    var downloadTask : URLSessionDataTask!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.retrieveUsers()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //we initilaized the user array in the beginning of our class, so this method is safe
        //when the table loads for the first time, users will be empty, so we'll just get an empty screen
        return users.count
    }
    
    //This table view function actually asks the question: "For each cell, what do you want me to show".
    //For our case we're going to create a new MainTableCell, and reuse it if possible, and then set
    //the user item for that row number, so that the correct image and label will show appropriately
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //For the table in question, grab the cell type we want to use, which we know is MainTableCell since we created a class for it
        //And then we'll cast it as that type
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableCell", for: indexPath) as! MainTableCell
        
        //For the current row, retrieve the user we want to show, which is from our array, and then set the userItem to the cell
        if let currentUser = self.users[indexPath.row] as? Dictionary<String,Any> {
            cell.userItem = currentUser
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //For this tutorial do nothing
    }
    
    //This manually calls retrieve users again, which makes it easier to debug
    //In case there's an issue with the github call
    @IBAction func reloadButtonPressed(_ sender: Any) {
        self.retrieveUsers()
    }
    
    //For the purpose of this exercise we will write this method directly in this class.  In general practice
    //we may have a DataManager type class that is a singleton to manage all data interaction.
    func retrieveUsers() {
        
        //This is the swift standard way to create a URL request of any sort GET/POST/DELETE
        //You can read more about it here: https://developer.apple.com/documentation/foundation/urlsession
        //We're going to store the session in the variable (in case we ever need to cancel it), and then we'll initiate calling
        //the URL defined in myURLRequest in order to retrieve the users.  For the purpose of this excercise we will ignore paging
        //and just stick to since=0.  But if we wanted to page you can read more about it below
        //https://developer.github.com/v3/users/#get-all-users
        
        let myURLRequest = URLRequest.init(url: URL(string: "https://api.github.com/users?since=0")!);
        
        self.downloadTask = URLSession.shared.dataTask(with: myURLRequest as URLRequest) { (data, response, error) in
            //something went wrong, we'll show a pop up, so the user will know to press the button and reload
            if let e = error {
                self.showMessageAlert(message: e.localizedDescription);
            } else {
                //successfully retrieved the data, we have to first convert what we have into an array of dictionaries
                //because we know we're getting back JSON, we use the following code below to parse and store it into
                //our data structure self.users.  When we're done we have to refresh the table, but we have to do that
                //on the main thread, since of this downloading / processing happens on the background.
                if response != nil {
                    do {
                        if let userData = data{
                            let dataResult = try JSONSerialization.jsonObject(with: userData, options: .mutableLeaves)
                            if let jsonResult = dataResult as? [Any?] {
                                self.users = jsonResult as [Any]
                                DispatchQueue.main.async {
                                    self.mainTableView.reloadData()
                                }
                            }
                        }
                    } catch {
                        debugPrint("Couldn't load the data file")
                    }
                    
                } else {
                    //never got a response back, so print out an error
                    self.showMessageAlert(message: "Request timed out, no response code")
                }
            }
        }
        
        //have to call resume, or else the task will never actually start
        self.downloadTask.resume()
    }
    
    //Helper to dismiss keyboard and show the appropriate message
    private func showMessageAlert(message: String!){
        let alert = UIAlertController(title: "Hey!", message: message + ". Press the reload button to try again.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
