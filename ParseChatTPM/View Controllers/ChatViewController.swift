//
//  ChatViewController.swift
//  ParseChatTPM
//
//  Created by Pranaya Adhikari on 8/12/18.
//  Copyright © 2018 Pranaya Adhikari. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    var messagePosts: [PFObject] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Auto size row height based on cell autolayout constraints
        tableView.rowHeight = UITableViewAutomaticDimension
        // Provide an estimated row height. Used for calculating scroll indicator
        tableView.estimatedRowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
        
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogOut(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        // Cell work
        cell.messages = messagePosts[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.messagePosts.count
    }
    
    
    @objc func onTimer() {
        // code to be run periodically
        let query = PFQuery(className: "Message")
        query.whereKeyExists("text").includeKey("user")
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts {
                // do something with the array of object returned by the call
                self.messagePosts = posts
                self.tableView.reloadData()
                
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        onTimer()
        // Tell the refreshControl to stop spinning
        refreshControl.endRefreshing()
    }
    
    
    
    @IBAction func onSend(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = self.messageField.text ?? ""
        chatMessage["user"] = PFUser.current()
        chatMessage.saveInBackground { (success, error) in
            if success{
                print("The message was saved!")
                self.messageField.text = ""
            }else if let error = error{
                print("Problem saving message: \(error.localizedDescription)")
            }
            
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
