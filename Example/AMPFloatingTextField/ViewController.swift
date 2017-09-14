//
//  ViewController.swift
//  AMPFloatingTextField
//
//  Created by ansujain123 on 09/13/2017.
//  Copyright (c) 2017 ansujain123. All rights reserved.
//

import UIKit
import AMPFloatingTextField

class ViewController: UIViewController, UITextFieldDelegate {
    

    let emailField = AMPFloatingTextField(frame: CGRect(x: 10, y: 50, width: 400 , height: 60))
    
    let lightGreyColor: UIColor = UIColor(red: 197 / 255, green: 205 / 255, blue: 205 / 255, alpha: 1.0)
    let darkGreyColor: UIColor = UIColor(red: 52 / 255, green: 42 / 255, blue: 61 / 255, alpha: 1.0)
    let overcastBlueColor: UIColor = UIColor(red: 0, green: 187 / 255, blue: 204 / 255, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        
        emailField.placeholder = NSLocalizedString(
            "Email",
            tableName: "AMPFloatingTextField",
            comment: "placeholder for Email field"
        )
        emailField.selectedTitle = NSLocalizedString(
            "Email",
            tableName: "AMPFloatingTextField",
            comment: "selected title for Email field"
        )
        emailField.title = NSLocalizedString(
            "Email",
            tableName: "AMPFloatingTextField",
            comment: "title for Email field"
        )
        self.view.addSubview(emailField)
        applySkyscannerTheme(textField: emailField)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func applySkyscannerTheme(textField: AMPFloatingTextField) {
        
        textField.tintColor = overcastBlueColor
        
        textField.textColor = darkGreyColor
        textField.lineColor = UIColor.red
        textField.activeBorderColor = UIColor.white
        textField.activeBackgroundColor = UIColor.purple
        
        textField.placeholderColor = UIColor.white
        
        textField.selectedTitleColor = darkGreyColor
        textField.selectedLineColor = UIColor.red
        
        // Set custom fonts for the title, placeholder and textfield labels
        textField.titleLabel.font = UIFont.systemFont(ofSize: 12)
        textField.placeholderFont = UIFont.systemFont(ofSize: 18)
        textField.font = UIFont.systemFont(ofSize: 18)

    }


}


extension ViewController {
    
    // MARK: - Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Validate the email field
        if textField == emailField {
            validateEmailField()
        }
        
        // When pressing return, move to the next field
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder! {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    @IBAction func validateEmailField() {
        validateEmailTextFieldWithText(email: emailField.text)
    }
    
    func validateEmailTextFieldWithText(email: String?) {
        guard let email = email else {
            emailField.errorMessage = nil
            return
        }
        
        if email.characters.isEmpty {
            emailField.errorMessage = nil
        } else if !validateEmail(email) {
            emailField.errorMessage = NSLocalizedString(
                "Email not valid",
                tableName: "AMPFloatingTextField",
                comment: " "
            )
        } else {
            emailField.errorMessage = nil
        }
    }
    
    // MARK: - validation
    
    func validateEmail(_ candidate: String) -> Bool {
        
        // NOTE: validating email addresses with regex is usually not the best idea.
        // This implementation is for demonstration purposes only and is not recommended for production use.
        // Regex source and more information here: http://emailregex.com
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }

}
