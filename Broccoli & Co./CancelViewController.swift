//
//  CancelViewController.swift
//  Broccoli & Co.
//
//  Created by Prabhav Mehra on 15/10/21.
//

import UIKit
import SCLAlertView

class CancelViewController: UIViewController {

    let headingTextView: UITextView = {
        let headingTextField = UITextView()
        headingTextField.text = "Broccoli & Co."
        headingTextField.font = UIFont.boldSystemFont(ofSize: 20)
        headingTextField.textAlignment = .center
        headingTextField.translatesAutoresizingMaskIntoConstraints = false
        headingTextField.isEditable = false
        headingTextField.isScrollEnabled = false
        
        return headingTextField
    }()
    
    let detailTextView: UITextView = {
        let detailTextField = UITextView()
        detailTextField.text = "Congratulations! You are already invited"
        detailTextField.font = UIFont.systemFont(ofSize: 20)
        detailTextField.textAlignment = .center
        detailTextField.translatesAutoresizingMaskIntoConstraints = false
        detailTextField.isEditable = false
        detailTextField.isScrollEnabled = false
        
        return detailTextField
    }()
    
    let cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel Invite", for: .normal)
        cancelButton.backgroundColor = .tintColor
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelAlert), for: .touchUpInside)
       
        return cancelButton
    }()
    
    let defaults = UserDefaults.standard
    
    override func viewDidAppear(_ animated: Bool) {
        let isInvited = defaults.string(forKey: "isInvited")
        if isInvited! == "notInvited" {
            let newViewController = ViewController()
            let navController = UINavigationController(rootViewController: newViewController)
            navController.modalPresentationStyle = .fullScreen
            
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(headingTextView)
        view.addSubview(detailTextView)
        view.addSubview(cancelButton)
        
        setUpLayout()
    }
    
    @objc func cancelAlert() {
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false
        )

        
        let alert = SCLAlertView(appearance: appearance)

        
        alert.addButton("Cancel") {
            
            
            self.defaults.set("notInvited", forKey: "isInvited")
            let newViewController = CancelCongratsViewController()
            let navController = UINavigationController(rootViewController: newViewController)
            navController.modalPresentationStyle = .fullScreen
            
            self.present(navController, animated: true, completion: nil)
        }

        alert.showWarning("Cancel Invite", subTitle: "Are you sure you want to cancel the invite")
        

    }
    
    private func setUpLayout(){
        headingTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headingTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
        headingTextView.widthAnchor.constraint(equalToConstant: 300 ).isActive = true
        headingTextView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        detailTextView.topAnchor.constraint(equalTo: headingTextView.bottomAnchor, constant: 20).isActive = true
        detailTextView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        detailTextView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        detailTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

        cancelButton.topAnchor.constraint(equalTo: headingTextView.bottomAnchor,  constant: 80).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 300 ).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

}
