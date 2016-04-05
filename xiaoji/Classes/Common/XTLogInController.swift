//
//  XTLogInController.swift
//  xiaoji
//
//  Created by xiaotei's on 16/4/5.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit
import ReactiveCocoa
import PKHUD

let isLogInKey = "UserIsLogIn"

class XTLogInController: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        logInButton.enabled = false
        userNameTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isValidUserName(value:String) -> Bool{
        return value.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0
    }
    
    func isValidPassword(value:String) -> Bool{
        return value.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) >= 6
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var userName:String = userNameTextField.text!
        var password:String = passwordTextField.text!

        
        if textField.tag == 1000{
            userName += string
            if string == ""{
                let index = userName.endIndex.advancedBy(-1)
                userName = userName.substringToIndex(index)
            }
        }else {
           password += string
            if string == ""{
                let index = password.endIndex.advancedBy(-1)
                password = password.substringToIndex(index)
            }
        }
        
        self.logInButton.enabled = self.isValidUserName(userName) && self.isValidPassword(password)
        return true
    }
    
    
    @IBAction func LogInButtonClick(sender: AnyObject) {
        HUD.show(.Label("登陆中..."))
        weak var weakSelf = self
        XTSignInService.signInWithUserName(userNameTextField.text, passWord: passwordTextField.text) { (status:Bool) -> Void in
            if status == true{
                HUD.flash(.Label("登陆成功！"), delay: 1.5)
                weakSelf?.dismissViewControllerAnimated(true, completion: nil)
                let userDefaluts = NSUserDefaults.standardUserDefaults()
                userDefaluts.setBool(true, forKey: isLogInKey)
            }else{
                HUD.flash(.Label("账号或密码错误！"), delay: 1.5)
            }
        }
        
    }
    
}