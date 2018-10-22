//
//  ViewController.swift
//  OnTheMap
//
//  Created by Royce Reynolds on 3/14/18.
//  Copyright © 2018 Royce Reynolds. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginPressed(_ sender: Any) {
        
        //performSegue(withIdentifier: "showTabVC", sender: self)
        
        guard let username = username.text, let password = password.text else{
            let alert = UIAlertController(title: "Username or Password empty", message: "Please enter both username and password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        
        
        UdacityClient.sharedInstance().createSession(username, password) { (success, error) in
            if success{
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "showTabVC", sender: self)
                }
            }else{
                print(error!)
                //print("LOGIN FAILED!")
            }
        }
    }
    
    @IBAction func facebookLoginPressed(_ sender: Any) {
    }
}

