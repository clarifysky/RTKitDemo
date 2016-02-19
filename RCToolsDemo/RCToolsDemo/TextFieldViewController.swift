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
    var textFieldReturn: RCTextField?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "textFieldTest"
        self.textFieldTest.delegate = self
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
