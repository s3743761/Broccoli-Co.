//
//  ViewController.swift
//  Broccoli & Co.
//
//  Created by Prabhav Mehra on 15/10/21.
//

import UIKit
import PopupDialog
import SCLAlertView
import Alamofire

class ViewController: UIViewController {

    let screenSize: CGRect = UIScreen.main.bounds

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
        detailTextField.text = "The service is in closed beta and Broccoli & Co. only want to grant beta access to the service to people who have requested an invite"
        detailTextField.font = UIFont.systemFont(ofSize: 18)
        detailTextField.textAlignment = .center
        detailTextField.translatesAutoresizingMaskIntoConstraints = false
        detailTextField.isEditable = false
        detailTextField.isScrollEnabled = false
        return detailTextField
    }()
    
    let subscribeButtonView: UIButton = {
        let subscribeButton = UIButton()
        subscribeButton.setTitle("Request Invite", for: .normal)
        subscribeButton.backgroundColor = .tintColor
        subscribeButton.translatesAutoresizingMaskIntoConstraints = false
        subscribeButton.addTarget(self, action: #selector(formModal), for: .touchUpInside)
        return subscribeButton
    }()
    
    let defaults = UserDefaults.standard
    

    override func viewDidAppear(_ animated: Bool) {
        let isInvited = defaults.string(forKey: "isInvited")
        if isInvited == nil {
            viewDidLoad()
        }
        else if isInvited! == "Invited" {
            let newViewController = CancelViewController()
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
        view.addSubview(subscribeButtonView)
        
        setUpLayout()
        
    }
    
    private func successAlert(){
        let alertController = UIAlertController(title: "Success",
                                                       message: "Everything went OK",
                                                       preferredStyle: .alert)


        alertController.addAction(UIAlertAction(title: "Close", style: .default,
            handler: {(alert: UIAlertAction!) in
         
            let newViewController = CongratulationsViewController()
            let navController = UINavigationController(rootViewController: newViewController)
            navController.modalPresentationStyle = .fullScreen
            
            self.present(navController, animated: true, completion: nil)
            
            
        }))

        self.present(alertController, animated: true, completion: nil)
    }
    
    private func badRequest(){
        let alertController = UIAlertController(title: "Error",
                                                       message: "User Already Exists",
                                                       preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Close", style: .default,
            handler: {(alert: UIAlertAction!) in
    
            self.formModal()
            
        }))

        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @objc func formModal() {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false,
            showCircularIcon: false,
            shouldAutoDismiss: false
        )

        
        let alert = SCLAlertView(appearance: appearance)

      
        let subview = UIView(frame: CGRect(x: 0,y: 0,width: 216,height: 200))
        let x = (subview.frame.width - 180) / 2
        
        let nameTextField = UITextField(frame: CGRect(x: x,y: 10,width: 180,height: 35))
        nameTextField.layer.borderColor = UIColor.black.cgColor
        nameTextField.layer.borderWidth = 1.5
        nameTextField.layer.cornerRadius = 5
        nameTextField.placeholder = "Name"
        nameTextField.textAlignment = NSTextAlignment.center
        nameTextField.clearButtonMode = .whileEditing

        
        let emailTextField = UITextField(frame: CGRect(x: x,y: nameTextField.frame.maxY + 15,width: 180,height: 35))
        emailTextField.layer.borderColor = UIColor.black.cgColor
        emailTextField.layer.borderWidth = 1.5
        emailTextField.layer.cornerRadius = 5
        emailTextField.placeholder = "Email"
        emailTextField.textAlignment = NSTextAlignment.center
        emailTextField.clearButtonMode = .whileEditing
        
        let confirmEmailTextField = UITextField(frame: CGRect(x: x,y: emailTextField.frame.maxY + 15,width: 180,height: 35))
        confirmEmailTextField.layer.borderColor = UIColor.black.cgColor
        confirmEmailTextField.layer.borderWidth = 1.5
        confirmEmailTextField.layer.cornerRadius = 5
        confirmEmailTextField.placeholder = "Confirm Email"
        confirmEmailTextField.textAlignment = NSTextAlignment.center
        confirmEmailTextField.clearButtonMode = .whileEditing


        let errorLabel = UILabel(frame: CGRect(x: x,y: confirmEmailTextField.frame.maxY + 10,width: 180,height: 35))
        errorLabel.textColor = .red
        errorLabel.numberOfLines = 0
        errorLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        errorLabel.textAlignment = .center
        
        subview.addSubview(nameTextField)
        subview.addSubview(emailTextField)
        subview.addSubview(confirmEmailTextField)
        subview.addSubview(errorLabel)
        
      
        alert.customSubview = subview
        
        alert.addButton("Submit") {
            if nameTextField.text == "" || emailTextField.text == "" || confirmEmailTextField.text == "" {

                errorLabel.text = "Please fill in all details"
            }
            else if nameTextField.text!.count < 3 {
                errorLabel.text = "Name not long enough"
            }

            else if self.isValidEmail(emailTextField.text!) == false{
                errorLabel.text = "Email format incorrect"
            }
            else if emailTextField.text! != confirmEmailTextField.text!{
                errorLabel.text = "Email does not match"
            }

            else {
                alert.hideView()
                let _: () = self.submitForm(name: nameTextField, email: emailTextField)
            }
        }

        alert.showSuccess("", subTitle: "This is a clean alert without Icon!")
        

    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        print(emailPred.evaluate(with: email))
        return emailPred.evaluate(with: email)
    }
    
    private func submitForm(name: UITextField , email: UITextField) {
        let session = URLSession.shared
        let url = "https://us-central1-blinkapp-684c1.cloudfunctions.net/fakeAuth"
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        var params :[String: Any]?
        params = ["name" : name.text!, "email" : email.text!]
        

        do{
           
            request.httpBody = try JSONSerialization.data(withJSONObject: params!, options: JSONSerialization.WritingOptions())
            let task = session.dataTask(with: request as URLRequest as URLRequest, completionHandler: {(data, response, error) in
                if let response = response {
                    let nsHTTPResponse = response as! HTTPURLResponse
                    let statusCode = nsHTTPResponse.statusCode
                    
                }
                if let error = error {
                    print ("\(error)")
                }
                if let data = data {
                   
                    do{
                        _ = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
                       
                        DispatchQueue.main.async {
                            self.badRequest()
                        }
                    }catch {
                      
                        
                        self.defaults.set("Invited", forKey: "isInvited")
                        DispatchQueue.main.async {
                            self.successAlert()
                        }
                       
                    }

                }
                
            })
            
            task.resume()

            
        }catch _ {
            print ("Oops something happened buddy")
        }

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

        subscribeButtonView.topAnchor.constraint(equalTo: headingTextView.bottomAnchor,  constant: 120).isActive = true
        subscribeButtonView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subscribeButtonView.widthAnchor.constraint(equalToConstant: 300 ).isActive = true
        subscribeButtonView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

}

