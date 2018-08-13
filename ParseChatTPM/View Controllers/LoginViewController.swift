//
//  LoginViewController.swift
//  ParseChatTPM
//
//  Created by Pranaya Adhikari on 8/12/18.
//  Copyright © 2018 Pranaya Adhikari. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        activityIndicator.startAnimating()
        let newUser = PFUser()
        let username = userNameField.text
        let password = passwordField.text
        if (username?.isEmpty)!{
            let title =  "Email Required"
            let message = "Please enter your email address"
            provideAlert(title: title, message: message)
        }else{
            newUser.username = username
        }
        
        if (password?.isEmpty)!{
            let title = "Password Required"
            let message =  "Please enter your password"
            provideAlert(title: title, message: message)
        }else{
            newUser.password = password
        }
        
        
        
        newUser.signUpInBackground { (success: Bool, error:Error?) in
            if let error = error{
                print(error.localizedDescription)
                let errorString = error.localizedDescription
                
                let alertController = UIAlertController(title: "Try again", message: errorString, preferredStyle: .alert)
                
                // add ok button
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: {
                    (action) in
                })
                alertController.addAction(okAction)
                self.activityIndicator.stopAnimating()
                // Show the errorString somewhere and let the user try again.
                self.present(alertController, animated: true)
                
            } else{
                print("User Signed Up successfully")
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    
    @IBAction func onLogin(_ sender: Any) {
        activityIndicator.startAnimating()
        let username = userNameField.text
        let password = passwordField.text
        
        if (username?.isEmpty)!{
            let title =  "Email Required"
            let message = "Please enter your email address"
            provideAlert(title: title, message: message)
        }
        if (password?.isEmpty)!{
            let title = "Password Required"
            let message =  "Please enter your password"
            provideAlert(title: title, message: message)
        }
        PFUser.logInWithUsername(inBackground: username!, password: password!) { (user: PFUser?, error: Error?) in
            if let  error = error{
                print("User log in failed: \(error.localizedDescription)")
                let errorString = error.localizedDescription
                
                let alertController = UIAlertController(title: "Try again", message: errorString, preferredStyle: .alert)
                
                // add ok button
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: {
                    (action) in
                })
                alertController.addAction(okAction)
                // Show the errorString somewhere and let the user try again.
                self.activityIndicator.stopAnimating()
                self.present(alertController, animated: true)
            }
            else{
                print("User logged in successfully")
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                
            }
        }
    }
    func provideAlert(title:String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        alertController.addAction(OKAction)
        self.activityIndicator.stopAnimating()
        present(alertController, animated: true)
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
