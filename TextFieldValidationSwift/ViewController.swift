//
//  ViewController.swift
//  TextFieldValidationSwift
//
//  Created by CallumHill on 29/11/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var passwordError: UILabel!
    @IBOutlet weak var phoneError: UILabel!
    
    @IBOutlet weak var submitButton: UIButton!
    
    var activeField: UITextField!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        resetForm()
        
        emailTF.delegate = self
        passwordTF.delegate = self
        phoneTF.delegate = self
        
        let center:NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func resetForm(){
        submitButton.isEnabled = false
        
        emailError.isHidden = false
        phoneError.isHidden = false
        passwordError.isHidden = false
        
        emailError.text = "Required"
        phoneError.text = "Required"
        passwordError.text = "Required"
        
        emailTF.text = ""
        passwordTF.text = ""
        phoneTF.text = ""
    }
    
    @IBAction func didend(_ sender: Any) {
        self.view.endEditing(true)
        
    }
    
    @IBAction func emailChanged(_ sender: Any){
        if let email = emailTF.text{
            if let errorMessage = invalidEmail(email){
                emailError.text = errorMessage
                emailError.isHidden = false
            }
            else{
                emailError.isHidden = true
            }
        }
        
        checkForValidForm()
    }
    
    func invalidEmail(_ value: String) -> String?{
        let reqularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        if !predicate.evaluate(with: value)
        {
            return "Invalid Email Address"
        }
        
        return nil
    }
    
    @IBAction func passwordChanged(_ sender: Any){
        if let password = passwordTF.text{
            if let errorMessage = invalidPassword(password){
                passwordError.text = errorMessage
                passwordError.isHidden = false
            }
            else{
                passwordError.isHidden = true
            }
        }
        
        checkForValidForm()
    }
    
    func invalidPassword(_ value: String) -> String?{
        if value.count < 8
        {
            return "Password must be at least 8 characters"
        }
        if containsDigit(value)
        {
            return "Password must contain at least 1 digit"
        }
        if containsLowerCase(value)
        {
            return "Password must contain at least 1 lowercase character"
        }
        if containsUpperCase(value)
        {
            return "Password must contain at least 1 uppercase character"
        }
        return nil
    }
    
    func containsDigit(_ value: String) -> Bool{
        let reqularExpression = ".*[0-9]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return !predicate.evaluate(with: value)
    }
    
    func containsLowerCase(_ value: String) -> Bool{
        let reqularExpression = ".*[a-z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return !predicate.evaluate(with: value)
    }
    
    func containsUpperCase(_ value: String) -> Bool{
        let reqularExpression = ".*[A-Z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return !predicate.evaluate(with: value)
    }
    
    @IBAction func phoneChanged(_ sender: Any) {
  
    
        if let phoneNumber = phoneTF.text{
            if let errorMessage = invalidPhoneNumber(phoneNumber){
                phoneError.text = errorMessage
                phoneError.isHidden = false
            }
            else{
                phoneError.isHidden = true
            }
        }
        checkForValidForm()
    }
    
    func invalidPhoneNumber(_ value: String) -> String?{
        let set = CharacterSet(charactersIn: value)
        if !CharacterSet.decimalDigits.isSuperset(of: set){
            
            return ""
        }
        
        if value.count != 10{
            return "Phone Number must be 10 Digits in Length"
        }
        return nil
    }
    
    func checkForValidForm(){
        if emailError.isHidden && passwordError.isHidden && phoneError.isHidden{
            submitButton.isEnabled = true
        }
        else{
            submitButton.isEnabled = false
        }
    }
        
        @objc    func keyboardDidShow(notification: Notification){
            let info: NSDictionary = notification.userInfo! as NSDictionary
            let keyboardsize = (info[UIResponder.keyboardFrameEndUserInfoKey] as!
                                NSValue).cgRectValue
            let keyboardY = self.view.frame.height - keyboardsize.height
            let editingTextFieldY = activeField.convert(activeField.bounds, to:self.view).minY
            if self.view.frame.minY>=0{
                if editingTextFieldY>keyboardY-20{
                    UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                        self.view.frame = CGRect(x: 0, y: self.view
                            .frame.origin.y-(editingTextFieldY-(keyboardY-50)), width: self.view.bounds.width, height: self.view.bounds.height)
                    }, completion: nil)
                }
            }
        }
        
        @objc    func keyboardHidden(notification: Notification){
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            }, completion: nil)
        }
    
    
    @IBAction func submitAction(_ sender: Any){
        resetForm()
    }
    
}

extension ViewController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.emailTF:
            self.passwordTF.becomeFirstResponder()
        case self.passwordTF:
            self.phoneTF.becomeFirstResponder()
        default:
            self.phoneTF.resignFirstResponder()
        }
    }
}
