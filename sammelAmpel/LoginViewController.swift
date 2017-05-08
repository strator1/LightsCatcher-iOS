//
//  LoginViewController.swift
//  sammelAmpel
//
//  Created by Patrick Valenta on 04.04.17.
//  Copyright © 2017 Patrick Valenta. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
//        btn.backgroundColor = .black
        
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.setTitle("Registrieren", for: .normal)
//        btn.setTitleColor(.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.addTarget(self, action: #selector(loginRegisterButtonPressed), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var continueAnonymousButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        //        btn.backgroundColor = .black
        
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.setTitle("Ohne Registrierung fortfahren", for: .normal)
        //        btn.setTitleColor(.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.addTarget(self, action: #selector(continueAnonymousButtonPressed), for: .touchUpInside)
        
        return btn
    }()
    
    let titleLabel: UILabel = {
       let l = UILabel()
        l.textAlignment = .center
        l.font = .boldSystemFont(ofSize: 30)
        l.text = "🚦 LightsCatcher"
        l.adjustsFontSizeToFitWidth = true
        return l
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        tf.layer.masksToBounds = true
        
        return tf
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        
        return tf
    }()
    
    let textFieldSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let textFieldSeparatorView2: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let textFieldSeparatorView3: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Registrieren"])
        sc.selectedSegmentIndex = 1
//        sc.tintColor = .black
        sc.translatesAutoresizingMaskIntoConstraints = false
        
        sc.addTarget(self, action: #selector(loginRegisterScSelectionChanged), for: .valueChanged)
        
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        //        navigationController?.isNavigationBarHidden = true
        
        setupView()
        observeKeyboardNotifications()
    }
    
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func onKeyboardShow() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: -54, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
        
        addHideKeyboardTap()
    }
    
    func onKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    func loginRegisterScSelectionChanged() {
        let selectedIndex = loginRegisterSegmentedControl.selectedSegmentIndex
        let selectedIndexTitle = loginRegisterSegmentedControl.titleForSegment(at: selectedIndex)
        
        loginRegisterButton.setTitle(selectedIndexTitle, for: .normal)
        
        inputsContainerViewHeightAnchor?.constant = selectedIndex == 0 ? 100 : 150
        
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: selectedIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: selectedIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: selectedIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
        textFieldSeparatorView2.isHidden = selectedIndex == 0 ? true : false
    }
    
    func loginRegisterButtonPressed() {
        
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            loginUser()
        } else {
            registerUser()
        }
        
    }
    
    func registerUser() {
        if UserDefaults.isUserBanned() {
            //show dialog
            showUserBannedDialog()
            return
        }
        
        if (!validateTextFields(login: false)) {
            return
        }
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            // Do error handling and feedback to the user here
            return
        }
        
        showProgressIndicator()
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                self.showProgressError(withMessage: "Error")
                print(error)
                return
            }
            
            print("Registered successfully")
            
            guard let uid = user?.uid else {
                return
            }
            
            //Saving user to database
            let ref = FIRDatabase.database().reference(fromURL: "https://hsaampelapp.firebaseio.com/")
            let usersRef = ref.child("users").child(uid)
            
            let values = ["name": name, "email": email, "points": 0] as [String : Any]
            usersRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if err != nil {
                    self.showProgressError(withMessage: "Error")
                    print(err)
                    return
                }
                
                self.hideProgressIndictator(withDelay: 0)
                print("Saved user successfully into Firebase db")
                self.view.endEditing(true)
                self.dismiss(animated: true, completion: nil)
                
            })
        })
    }
    
    func continueAnonymousButtonPressed() {
        if UserDefaults.isUserBanned() {
            //show dialog
            showUserBannedDialog()
            return
        }
        
        showProgressIndicator()
        FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
            if error != nil {
                self.showProgressError(withMessage: "Error")
                print(error)
                return
            }
            
            self.hideProgressIndictator(withDelay: 0)
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func loginUser() {
        if UserDefaults.isUserBanned() {
            //show dialog
            showUserBannedDialog()
            return
        }
        
        if (!validateTextFields(login: true)) {
            return
        }
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            // Do error handling and feedback to the user here
            return
        }
        
        showProgressIndicator()
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                self.showProgressError(withMessage: "Error")
                print(error)
                return
            }
            
            self.hideProgressIndictator(withDelay: 0)
            print("Login successfully")
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
            
        })
    }
    
    func showProgressIndicator() {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        view.isUserInteractionEnabled = false
    }
    
    func showProgressError(withMessage: String) {
        SVProgressHUD.showError(withStatus: withMessage)
        hideProgressIndictator(withDelay: 1)
    }
    
    func hideProgressIndictator(withDelay: TimeInterval) {
        SVProgressHUD.dismiss(withDelay: withDelay)
        view.isUserInteractionEnabled = true
    }

    func showUserBannedDialog() {
        let alertDialog = UIAlertController(title: "Rote Ampel", message: "Wir mussten Dich leider aus dem Verkehr ziehen. Du hast zu viele unanständige Bilder hochgeladen, sorry. Bis zum nächsten mal vielleicht ;)", preferredStyle: .alert)
        alertDialog.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alertDialog, animated: true, completion: nil)
    }
    
    func validateTextFields(login: Bool) -> Bool {
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            showCompletInputDialog()
            return false
        }
        
        if !login && (nameTextField.text == "" || (passwordTextField.text?.characters.count)! < 6) {
            showCompletInputDialog()
            return false
        }
        
        return true
    }
    
    func showCompletInputDialog() {
        let alertController = UIAlertController(title: "Hinweis", message: "Bitte stelle sicher, dass alle Eingabefelder vollständig ausgefüllt sind.\n Passwortlänge soll mindestens 6 Stellen haben.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setupView() {
        view.addSubview(titleLabel)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(continueAnonymousButton)
        
        titleLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: view.frame.height / 4)
        
        setupInputsContainerView()
        
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 8).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        continueAnonymousButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        continueAnonymousButton.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 8).isActive = true
        continueAnonymousButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        continueAnonymousButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupInputsContainerView() {
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -24).isActive = true
        
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(textFieldSeparatorView2)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(textFieldSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        inputsContainerView.addSubview(textFieldSeparatorView3)
        
        nameTextField.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1, constant: -20).isActive = true
        
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        textFieldSeparatorView2.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        textFieldSeparatorView2.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        textFieldSeparatorView2.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -24).isActive = true
        textFieldSeparatorView2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        emailTextField.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1, constant: -20).isActive = true
        
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        textFieldSeparatorView.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        textFieldSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        textFieldSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -24).isActive = true
        textFieldSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passwordTextField.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1, constant: -20).isActive = true
        
        textFieldSeparatorView3.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        textFieldSeparatorView3.bottomAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        textFieldSeparatorView3.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -24).isActive = true
        textFieldSeparatorView3.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
}

