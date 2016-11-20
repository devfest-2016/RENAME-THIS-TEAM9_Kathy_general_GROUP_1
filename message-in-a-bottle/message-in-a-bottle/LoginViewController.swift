//
//  LoginViewController.swift
//  message-in-a-bottle
//
//  Created by Benjamin Su on 11/19/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

struct LoginViewPosition {
    
    static let emailPosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.30)
    static let passwordPosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.40)
    static let firstnamePosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.40)
    static let lastnamePosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.40)
    
    static let loginPosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.55)
    static let newuserPosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.65)
    static let signupPosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.65)
    static let cancelPosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.65)
}

struct NewUserViewPosition {
    
    static let emailPosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.20)
    static let passwordPosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.28)
    static let firstnamePosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.36)
    static let lastnamePosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.44)
    
    static let loginPosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.55)
    static let newuserPosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.55)
    static let signupPosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.55)
    static let cancelPosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.65)
}

class LoginViewController: UIViewController {
    
    var appTitleLabel1: UILabel!
    var appTitleLabel2: UILabel!
    var appTitleLabel3: UILabel!
    
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var firstnameTextField: UITextField!
    var lastnameTextField: UITextField!
    
    var loginButton: UIButton!
    var newuserButton: UIButton!
    var signupButton: UIButton!
    var cancelButton: UIButton!

    var signupButtonState = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.themeBrightBlue
        loadViews()
        setPositions()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchLocation = touches.first?.location(in: self.view)
        
        if emailTextField.bounds.contains(touchLocation!) {
            emailTextField.becomeFirstResponder()
        } else if passwordTextField.bounds.contains(touchLocation!){
            passwordTextField.becomeFirstResponder()
        } else if firstnameTextField.bounds.contains(touchLocation!){
            firstnameTextField.becomeFirstResponder()
        } else if lastnameTextField.bounds.contains(touchLocation!){
            lastnameTextField.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
        }
        
        
    }
    
    func animateSignupEntry(view: UIView) {

        UIView.animate(withDuration: 0.25, animations: {
            view.center.y = self.view.center.y
        }) { (success) in
            print(success)
        }
    }

    func createAlertWith(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel, handler: nil))
        
        return alert
    }
    
}


extension LoginViewController {
    
    func loginButtonAction() {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        if email != "" && password != "" {
            FirebaseMethods.signInButton(email: email, password: password) { success in
                if success {
                    self.performSegue(withIdentifier: "landingSegue", sender: self)
                } else {
                    let alert = self.createAlertWith(title: "Couldn't Login", message: "Please Check Your Entries")
                    self.present(alert, animated: true, completion: { 
                        
                    })
                }
            }
        } else if email == "" && password != "" {
            let alert = self.createAlertWith(title: "Uh Oh", message: "You need an email.")
            self.present(alert, animated: true, completion: {
                
            })
        } else if password == "" && email != "" {
            let alert = self.createAlertWith(title: "Uh Oh", message: "You need a password.")
            self.present(alert, animated: true, completion: {
                
            })
        } else {
            let alert = self.createAlertWith(title: "Uh Oh", message: "You need to enter some info.")
            self.present(alert, animated: true, completion: {
                
            })
        }
    }
    
    func newuserButtonAction(_ sender: UIButton) {
        animateForSignup()
    }
    
    func signupButtonAction(_ sender: UIButton) {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let firstName = firstnameTextField.text else {return}
        guard let lastName = lastnameTextField.text else {return}
        
        if email != "" && password != "" && firstName != "" && lastName != "" {
            FirebaseMethods.signUpButton(email: email, password: password, firstName: firstName, lastName: lastName) { success in
                if success {
                    self.performSegue(withIdentifier: "landingSegue", sender: self)
                } else {
                    let alert = self.createAlertWith(title: "Couldn't Signup", message: "This email is already being used.")
                    self.present(alert, animated: true, completion: {
                        
                    })
                }
            }
        } else {
            let alert = self.createAlertWith(title: "Uh Oh", message: "Please fill in all the fields.")
            self.present(alert, animated: true, completion: {
                
            })
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "landingSegue" {
            let destinationNavController = segue.destination as! UINavigationController
            let targetController = destinationNavController.topViewController as! LandingViewController
        }
    }
    
    
    func cancelButtonAction(_ sender: UIButton) {
        
        animateForLogin()
 
    }
    
    
    
}


//MARK: -Animations
extension LoginViewController {
    
    func animateForSignup() {
        self.firstnameTextField.isHidden = false
        self.lastnameTextField.isHidden = false
        self.signupButton.isHidden = false
        self.cancelButton.isHidden = false
        self.newuserButton.isUserInteractionEnabled = false
        self.cancelButton.isUserInteractionEnabled = false
        UIView.animateKeyframes(withDuration: 0.2, delay: 0.0, options: [.allowUserInteraction, .calculationModeCubic], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1, animations: {
                self.emailTextField.center = NewUserViewPosition.emailPosition
                self.passwordTextField.center = NewUserViewPosition.passwordPosition
                self.firstnameTextField.center = NewUserViewPosition.firstnamePosition
                self.lastnameTextField.center = NewUserViewPosition.lastnamePosition
                
                self.loginButton.center = NewUserViewPosition.loginPosition
                self.newuserButton.center = NewUserViewPosition.newuserPosition
                self.signupButton.center = NewUserViewPosition.signupPosition
                self.cancelButton.center = NewUserViewPosition.cancelPosition
                
            })
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.33, animations: {
                self.emailTextField.transform = CGAffineTransform.init(scaleX: 1.1, y: 1)
                self.passwordTextField.transform = CGAffineTransform.init(scaleX: 1.1, y: 1)
                self.firstnameTextField.transform = CGAffineTransform.init(scaleX: 1.2, y: 1)
                self.lastnameTextField.transform = CGAffineTransform.init(scaleX: 1.2, y: 1)
                
                self.loginButton.transform = CGAffineTransform.init(scaleX: 1.1, y: 1)
                self.newuserButton.transform = CGAffineTransform.init(scaleX: 1.1, y: 1)
                self.signupButton.transform = CGAffineTransform.init(scaleX: 1.2, y: 1)
                self.cancelButton.transform = CGAffineTransform.init(scaleX: 1.2, y: 1)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.33, relativeDuration: 0.33, animations: {
                self.emailTextField.transform = CGAffineTransform.init(scaleX: 0.9, y: 1)
                self.passwordTextField.transform = CGAffineTransform.init(scaleX: 0.9, y: 1)
                self.firstnameTextField.transform = CGAffineTransform.init(scaleX: 0.8, y: 1)
                self.lastnameTextField.transform = CGAffineTransform.init(scaleX: 0.8, y: 1)
                
                self.loginButton.transform = CGAffineTransform.init(scaleX: 0.9, y: 1)
                self.newuserButton.transform = CGAffineTransform.init(scaleX: 0.9, y: 1)
                self.signupButton.transform = CGAffineTransform.init(scaleX: 0.8, y: 1)
                self.cancelButton.transform = CGAffineTransform.init(scaleX: 0.8, y: 1)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.66, relativeDuration: 0.33, animations: {
                self.emailTextField.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.passwordTextField.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.firstnameTextField.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.lastnameTextField.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                
                self.loginButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.newuserButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.signupButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.cancelButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            })
        }) { (success) in
            self.loginButton.isHidden = true
            self.newuserButton.isHidden = true
            self.newuserButton.isUserInteractionEnabled = true
            self.cancelButton.isUserInteractionEnabled = true
        }
        
    }
    
    func animateForLogin() {
        
        self.loginButton.isHidden = false
        self.newuserButton.isHidden = false
        self.newuserButton.isUserInteractionEnabled = false
        self.cancelButton.isUserInteractionEnabled = false
        UIView.animateKeyframes(withDuration: 0.2, delay: 0.0, options: [.allowUserInteraction, .calculationModeCubic], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1, animations: {
                self.emailTextField.center = LoginViewPosition.emailPosition
                self.passwordTextField.center = LoginViewPosition.passwordPosition
                self.firstnameTextField.center = LoginViewPosition.firstnamePosition
                self.lastnameTextField.center = LoginViewPosition.lastnamePosition
                
                self.loginButton.center = LoginViewPosition.loginPosition
                self.newuserButton.center = LoginViewPosition.newuserPosition
                self.signupButton.center = LoginViewPosition.signupPosition
                self.cancelButton.center = LoginViewPosition.cancelPosition
                
            })
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.33, animations: {
                self.emailTextField.transform = CGAffineTransform.init(scaleX: 0.9, y: 1)
                self.passwordTextField.transform = CGAffineTransform.init(scaleX: 0.9, y: 1)
                self.firstnameTextField.transform = CGAffineTransform.init(scaleX: 0.8, y: 1)
                self.lastnameTextField.transform = CGAffineTransform.init(scaleX: 0.8, y: 1)
                
                self.loginButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.newuserButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.signupButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.cancelButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.33, relativeDuration: 0.33, animations: {
                self.emailTextField.transform = CGAffineTransform.init(scaleX: 1.1, y: 1)
                self.passwordTextField.transform = CGAffineTransform.init(scaleX: 1.1, y: 1)
                self.firstnameTextField.transform = CGAffineTransform.init(scaleX: 1.2, y: 1)
                self.lastnameTextField.transform = CGAffineTransform.init(scaleX: 1.2, y: 1)
                
                self.loginButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.newuserButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.signupButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.cancelButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.66, relativeDuration: 0.33, animations: {
                self.emailTextField.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.passwordTextField.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.firstnameTextField.transform = CGAffineTransform.init(scaleX: 0, y: 1)
                self.lastnameTextField.transform = CGAffineTransform.init(scaleX: 0, y: 1)
                
                self.loginButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.newuserButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.signupButton.transform = CGAffineTransform.init(scaleX: 0, y: 1)
                self.cancelButton.transform = CGAffineTransform.init(scaleX: 0, y: 1)
            })
        }) { (success) in
            self.firstnameTextField.isHidden = true
            self.lastnameTextField.isHidden = true
            self.signupButton.isHidden = true
            self.cancelButton.isHidden = true
            self.newuserButton.isUserInteractionEnabled = true
            self.cancelButton.isUserInteractionEnabled = true
        }
        
    }
    
    
}




//MARK: -Setup buttons
extension LoginViewController {
    
    func setPositions() {
        emailTextField.center = LoginViewPosition.emailPosition
        passwordTextField.center = LoginViewPosition.passwordPosition
        firstnameTextField.center = LoginViewPosition.firstnamePosition
        lastnameTextField.center = LoginViewPosition.lastnamePosition
        
        firstnameTextField.transform = CGAffineTransform.init(scaleX: 0.0, y: 1)
        lastnameTextField.transform = CGAffineTransform.init(scaleX: 0.0, y: 1)
        firstnameTextField.isHidden = true
        lastnameTextField.isHidden = true
        
        loginButton.center = LoginViewPosition.loginPosition
        newuserButton.center = LoginViewPosition.newuserPosition
        signupButton.center = LoginViewPosition.signupPosition
        cancelButton.center = LoginViewPosition.cancelPosition
        
        signupButton.transform = CGAffineTransform.init(scaleX: 0.0, y: 1)
        cancelButton.transform = CGAffineTransform.init(scaleX: 0.0, y: 1)
        signupButton.isHidden = true
        cancelButton.isHidden = true
    }
    
    func loadViews() {
        
        let borderWidth: CGFloat = 2
        let borderColor = UIColor.themeDarkBlue.cgColor
        
        appTitleLabel1 = UILabel(frame: CGRect(x: self.view.frame.size.width * 0.25, y: self.view.frame.size.height * 0.02, width: self.view.frame.size.width * 0.5, height: self.view.frame.size.height * 0.05))
        appTitleLabel1.textColor = UIColor.black
        appTitleLabel1.text = "Message"
        appTitleLabel1.font = UIFont(name: "AvenirNext-Heavy", size: 20)
        appTitleLabel1.textAlignment = .center
        self.view.addSubview(appTitleLabel1)
        
        appTitleLabel2 = UILabel(frame: CGRect(x: self.view.frame.size.width * 0.25, y: self.view.frame.size.height * 0.07, width: self.view.frame.size.width * 0.5, height: self.view.frame.size.height * 0.04))
        appTitleLabel2.textColor = UIColor.black
        appTitleLabel2.text = "In A"
        appTitleLabel2.font = UIFont(name: "AvenirNext-Heavy", size: 12)
        appTitleLabel2.textAlignment = .center
        self.view.addSubview(appTitleLabel2)
        
        appTitleLabel3 = UILabel(frame: CGRect(x: self.view.frame.size.width * 0.25, y: self.view.frame.size.height * 0.11, width: self.view.frame.size.width * 0.5, height: self.view.frame.size.height * 0.05))
        appTitleLabel3.textColor = UIColor.black
        appTitleLabel3.text = "Bottle"
        appTitleLabel3.font = UIFont(name: "AvenirNext-Heavy", size: 20)
        appTitleLabel3.textAlignment = .center
        self.view.addSubview(appTitleLabel3)
        
        firstnameTextField = UITextField(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width * 0.6, height: self.view.frame.size.height * 0.06))
        firstnameTextField.layer.cornerRadius = 4
        firstnameTextField.layer.borderWidth = borderWidth
        firstnameTextField.layer.borderColor = borderColor
        firstnameTextField.autocorrectionType = .no
        firstnameTextField.backgroundColor = UIColor.themeTealBlue
        firstnameTextField.attributedPlaceholder = NSAttributedString(string: "Enter First Name")
        self.view.addSubview(firstnameTextField)
        
        lastnameTextField = UITextField(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width * 0.6, height: self.view.frame.size.height * 0.06))
        lastnameTextField.layer.cornerRadius = 4
        lastnameTextField.layer.borderWidth = borderWidth
        lastnameTextField.layer.borderColor = borderColor
        lastnameTextField.autocorrectionType = .no
        lastnameTextField.backgroundColor = UIColor.themeTealBlue
        lastnameTextField.attributedPlaceholder = NSAttributedString(string: "Enter Last Name")
        self.view.addSubview(lastnameTextField)
        
        emailTextField = UITextField(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width * 0.6, height: self.view.frame.size.height * 0.06))
        emailTextField.backgroundColor = UIColor.themeTealBlue
        emailTextField.layer.cornerRadius = 4
        emailTextField.layer.borderWidth = borderWidth
        emailTextField.layer.borderColor = borderColor
        emailTextField.autocorrectionType = .no
        emailTextField.autocapitalizationType = .none
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Enter email")
        self.view.addSubview(emailTextField)
        
        passwordTextField = UITextField(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width * 0.6, height: self.view.frame.size.height * 0.06))
        passwordTextField.layer.cornerRadius = 4
        passwordTextField.layer.borderWidth = borderWidth
        passwordTextField.layer.borderColor = borderColor
        passwordTextField.autocorrectionType = .no
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.backgroundColor = UIColor.themeTealBlue
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter password")
        self.view.addSubview(passwordTextField)
        
        
        loginButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width * 0.4, height: self.view.frame.size.height * 0.06))
        self.view.addSubview(loginButton)
        loginButton.layer.cornerRadius = 7
        loginButton.layer.borderWidth = borderWidth
        loginButton.layer.borderColor = borderColor
        loginButton.backgroundColor = UIColor.themeMedBlue
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(UIColor.black, for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
        
        newuserButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width * 0.4, height: self.view.frame.size.height * 0.06))
        self.view.addSubview(newuserButton)
        newuserButton.layer.cornerRadius = 7
        newuserButton.layer.borderWidth = borderWidth
        newuserButton.layer.borderColor = borderColor
        newuserButton.backgroundColor = UIColor.themeSand
        newuserButton.setTitle("New User", for: .normal)
        newuserButton.setTitleColor(UIColor.black, for: .normal)
        newuserButton.addTarget(self, action: #selector(newuserButtonAction), for: .touchUpInside)
        
        signupButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width * 0.4, height: self.view.frame.size.height * 0.06))
        self.view.addSubview(signupButton)
        signupButton.layer.cornerRadius = 7
        signupButton.layer.borderWidth = borderWidth
        signupButton.layer.borderColor = borderColor
        signupButton.backgroundColor = UIColor.themeSand
        signupButton.setTitle("Signup", for: .normal)
        signupButton.setTitleColor(UIColor.black, for: .normal)
        signupButton.addTarget(self, action: #selector(signupButtonAction), for: .touchUpInside)
        
        cancelButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width * 0.4, height: self.view.frame.size.height * 0.06))
        cancelButton.layer.cornerRadius = 7
        cancelButton.layer.borderWidth = borderWidth
        cancelButton.layer.borderColor = borderColor
        self.view.addSubview(cancelButton)
        cancelButton.backgroundColor = UIColor.themeDarkBlue
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        
    }
}




