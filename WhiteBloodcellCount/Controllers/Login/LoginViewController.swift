//
//  LoginViewController.swift
//  WhiteBloodcellCount
//
//  Created by Tom Riddle on 11/6/20.
//

import UIKit
import Parse
class LoginViewController: UIViewController {

  @IBOutlet weak var usernameField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
  @IBAction func onSignIn(_ sender: Any) {
    if let username = usernameField.text, let password = passwordField.text {
      if isEmptyField(username) || isEmptyField(password) {
        self.displayFieldEmptyError()
      }
      else {
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
          if let error = error {
            print("Log in ERROR \(error.localizedDescription)")
            self.displayError(error: error, "login")
          }
          else if let user = user {
            print("Log in successfully")
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
          }
        }
      }
    }
    else {
      print("Log in ERROR username and password cannot be empty")
      self.displayFieldEmptyError()
    }
  }
  
  @IBAction func onSignUp(_ sender: Any) {
    if let username = usernameField.text, let password = passwordField.text {
      if isEmptyField(username) || isEmptyField(password) {
        self.displayFieldEmptyError()
      }
      else {
        let user = PFUser()
        
        user.username = username
        user.password = password
        
        user.signUpInBackground { (success, error) in
          if let error = error{
            print("Sign up Error: \(error.localizedDescription)")
            self.displayError(error: error, "signup")
          } else {
            print("Sign up successfully")
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
          }
        }
      }
    }
  }
  
  func isEmptyField(_ field: String) -> Bool{
    return field == ""
  }
  
  func displayFieldEmptyError() {
    let title = "Error login"
    let message = "Username and password cannot be empty"
    //render error
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default)
    alertController.addAction(OKAction)
    present(alertController, animated: true, completion: nil)
  }
  
  func displayError(error: Error, _ performAction: String) {
    //prepare message
    let title = "Error \(performAction)"
    let message = "Something when wrong while \(performAction): \(error.localizedDescription)"
    //render error
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default)
    alertController.addAction(OKAction)
    present(alertController, animated: true, completion: nil)
  }
}
