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
    private let kOFFSET_FOR_KEYBOARD: CGFloat = 216
    var textFieldReturn: RCTextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "textFieldTest"
        self.textFieldTest.delegate = self
        
        self.textViewTest = UITextView(frame: CGRectMake(0, self.view.bounds.height - 200, self.view.bounds.width, 200))
        self.textViewTest?.backgroundColor = UIColor.grayColor()
        self.view.addSubview(self.textViewTest!)
        self.textViewTest!.delegate = self
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func resignGesture(recognizer: UITapGestureRecognizer) {
        if recognizer.view != self.textViewTest && self.textViewTest!.isFirstResponder() {
            self.textViewTest!.resignFirstResponder()
        }
    }
    
    func keyboardWillShow() {
        if self.view.frame.origin.y >= 0 {
            self.setViewMovedUp(true)
        } else if self.view.frame.origin.y < 0 {
            self.setViewMovedUp(false)
        }
    }
    
    func keyboardWillHide() {
        if self.view.frame.origin.y >= 0 {
            self.setViewMovedUp(true)
        } else if self.view.frame.origin.y < 0 {
            self.setViewMovedUp(false)
        }
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
}
