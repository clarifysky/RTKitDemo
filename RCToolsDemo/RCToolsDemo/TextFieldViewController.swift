//
//  TextFieldViewController.swift
//  
//
//  Created by Rex Tsao on 1/20/16.
//
//

import UIKit

class TextFieldViewController: UIViewController {

    @IBOutlet weak var textFieldTest: UITextField!
    private var textViewTest: UITextView?
    // How to get the height of keyboard?
    private var kOFFSET_FOR_KEYBOARD: CGFloat = 80
    var textFieldReturn: RCTextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "textFieldTest"
        self.textFieldTest.delegate = self
        
        self.textViewTest = UITextView(frame: CGRectMake(0, self.view.bounds.height - 40, 200, 40))
        self.textViewTest?.backgroundColor = UIColor.grayColor()
        self.textViewTest?.layer.borderColor = UIColor.redColor().CGColor
        self.textViewTest?.layer.borderWidth = 1.0
        self.textViewTest?.font = UIFont.systemFontOfSize(16)
        self.view.addSubview(self.textViewTest!)
        self.textViewTest!.delegate = self
        self.textViewTest!.returnKeyType = .Send
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "resignGesture:")
        self.view.addGestureRecognizer(tapGesture)
        
        self.textFieldTest.returnKeyType = UIReturnKeyType.Send
        
//        self.textFieldReturn = RCTextField(frame: CGRectMake(10, 150, 200, 40))
//        self.textFieldReturn?.doneTitle = "send"
//        self.textFieldReturn?.doneAction = {
//            println("You clicked send button in keyboard view")
//        }
//        self.textFieldReturn?.layer.borderColor = UIColor.greenColor().CGColor
//        self.textFieldReturn?.layer.borderWidth = 1.0
//        self.view.addSubview(self.textFieldReturn!)
        
        println("[TextFieldViewController] viewDidLoad:")
        println("__frame: \(self.view.frame)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {       
        super.viewWillAppear(animated)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardFrameWillChange:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    
    func resignGesture(recognizer: UITapGestureRecognizer) {
        if recognizer.view != self.textViewTest && self.textViewTest!.isFirstResponder() {
            self.textViewTest!.resignFirstResponder()
        }
    }
    
    
    func keyboardFrameWillChange(notification: NSNotification) {
        println("[TextFieldViewController] keyboardFrameWillChange:")
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.changeViewFrame(keyboardSize.height)
            }
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.kOFFSET_FOR_KEYBOARD = keyboardSize.height
            }
        }
        
        if self.view.frame.origin.y >= 0 {
            self.setViewMovedUp(true)
        } else if self.view.frame.origin.y < 0 {
            self.setViewMovedUp(false)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        println("[TextFieldViewController] keyboardWillHide:")
//        if self.view.frame.origin.y >= 0 {
//            self.setViewMovedUp(true)
//        } else if self.view.frame.origin.y < 0 {
//            self.setViewMovedUp(false)
//        }
        self.changeViewFrame(0)
    }
    
    
    private func changeViewFrame(height: CGFloat) {
        println("[TextFieldViewController] changeViewFrame:")
        println("__height: \(height)")
        self.view.frame = CGRectMake(self.view.frame.origin.x, 0 - height, self.view.frame.width, self.view.frame.height)
    }

    /// Method to move the view up/down whenever the keyboard is shown/dismissed
    /// http://stackoverflow.com/questions/1126726/how-to-make-a-uitextfield-move-up-when-keyboard-is-present?page=1&tab=votes#tab-top
    private func setViewMovedUp(movedUp: Bool) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        
        var rect = self.view.frame
        if movedUp {
            // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
            // 2. increase the size of the view so that the area behind the keyboard is covered up
            rect.origin.y -= self.kOFFSET_FOR_KEYBOARD
            rect.size.height += self.kOFFSET_FOR_KEYBOARD
        } else {
            // revert back to the normal state
            rect.origin.y += self.kOFFSET_FOR_KEYBOARD
            rect.size.height -= self.kOFFSET_FOR_KEYBOARD
        }
        self.view.frame = rect
        UIView.commitAnimations()
    }
}

extension TextFieldViewController: UITextFieldDelegate {
    // If you want to reset the height of UITextView dynamically: 
    // 1. You must set the upper limit of height for the UITextView. If you don't set the upper limit, the UITextView 
    //      will grow much high as it can, this may not be what you want.
    // 2. Calculate the height when it best fits its contents.
    // 3. Calculate the gap of old height and new height.
    // 4. Reset its frame.
    // IMPORTANT: Only when the new height is less than the upper limit you set, the frame of UITextView can be reset.
    func textViewDidChange(textView: UITextView) {
        println("[TextFieldViewController] textViewDidChange:")
        // Caculate the size which best fits the specified size.
        // This height is just the height of textView which best fits its content.
        var height = textView.sizeThatFits(CGSizeMake(self.textViewTest!.frame.width, CGFloat(MAXFLOAT))).height
        // Compare with the original height, if bigger than original value, use current height, otherwise, use original value
        height = height > 40 ? height : 40
        // Here i set the max height for textView is 80.
        if height <= 80 {
            // Get how much the textView grows at height dimission
            let heightDiff = height - self.textViewTest!.frame.height
            UIView.animateWithDuration(0.05, animations: {
                self.textViewTest?.frame = CGRectMake(self.textViewTest!.frame.origin.x, self.textViewTest!.frame.origin.y - heightDiff, self.textViewTest!.frame.width, height)
            })
        }
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        println("string: " + string)
        println("range: \(range)")
        println("toRange: \(range.toRange(textField.text))")
        println("textFromTextField: \(textField.text)")
        let testStr = textField.text.stringByReplacingCharactersInRange(range.toRange(textField.text), withString: string)
        println(testStr + ", length: \(count(testStr))")
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        println("you pressed the return button")
        return true
    }
}

extension TextFieldViewController: UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.isEqual(self.textViewTest) {
            // move the main view, so that the keyboard does not hide it.
            if self.view.frame.origin.y >= 0 {
                self.setViewMovedUp(true)
            }
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            println("You pressed return button")
            return false
        } else {
            return true
        }
    }
}
