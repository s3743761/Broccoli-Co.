//
//  CongratulationsViewController.swift
//  Broccoli & Co.
//
//  Created by Prabhav Mehra on 15/10/21.
//

import UIKit
import SwiftConfettiView

class CongratulationsViewController: UIViewController {

   
    let headingTextView: UITextView = {
        let headingTextField = UITextView()
        headingTextField.text = "Congratulations"
        headingTextField.font = UIFont.boldSystemFont(ofSize: 25)
        headingTextField.textAlignment = .center
        headingTextField.translatesAutoresizingMaskIntoConstraints = false
        headingTextField.isEditable = false
        headingTextField.isScrollEnabled = false
        headingTextField.textColor = .black
        return headingTextField
    }()
    
    var confettiView: SwiftConfettiView!
    
    let closeButton: UIButton = {
        let borderAlpha : CGFloat = 0.7
        let cornerRadius : CGFloat = 5.0
        let closeButton = UIButton()
        closeButton.setTitle("Close", for: UIControl.State.normal)
        closeButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        closeButton.backgroundColor = UIColor.clear
        closeButton.layer.borderWidth = 1.0
        closeButton.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        closeButton.layer.cornerRadius = cornerRadius
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(cancelButton), for: .touchUpInside)
        
        return closeButton
    }()
     
    let gifImage: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.loadGif(name: "cartoon-eat")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print(view.bounds)
        confettiView = SwiftConfettiView(frame: view.bounds)

        confettiView.colors = [UIColor(red:0.95, green:0.40, blue:0.27, alpha:1.0),
                               UIColor(red:1.00, green:0.78, blue:0.36, alpha:1.0),
                               UIColor(red:0.48, green:0.78, blue:0.64, alpha:1.0),
                               UIColor(red:0.30, green:0.76, blue:0.85, alpha:1.0),
                               UIColor(red:0.58, green:0.39, blue:0.55, alpha:1.0)]

        
        confettiView.intensity = 1
        confettiView.type = .confetti
        
        view.backgroundColor = UIColor.white
        view.addSubview(headingTextView)
        view.addSubview(closeButton)
        view.addSubview(gifImage)
        view.addSubview(confettiView)
        
        let s = 4
        _ = Timer.scheduledTimer(timeInterval: TimeInterval(s), target: self,selector:#selector(stopConfetti), userInfo: nil, repeats: false)
        
        confettiView.startConfetti()
        setUpLayout()
        
    }
    
    @objc func stopConfetti() {
       confettiView.stopConfetti()
       view.willRemoveSubview(confettiView)
       confettiView.removeFromSuperview()
    }
    
    private func setUpLayout() {
        
        gifImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gifImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        gifImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        gifImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        headingTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headingTextView.topAnchor.constraint(equalTo: gifImage.bottomAnchor, constant: 100).isActive = true
        headingTextView.widthAnchor.constraint(equalToConstant: 300 ).isActive = true
        headingTextView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        closeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    @objc func cancelButton() {
        let newViewController = CancelViewController()
        
        let navController = UINavigationController(rootViewController: newViewController)
        navController.modalPresentationStyle = .fullScreen
        
        self.present(navController, animated: true, completion: nil)
    }

}
