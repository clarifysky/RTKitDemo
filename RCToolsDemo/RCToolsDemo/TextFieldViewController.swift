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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "textFieldTest"
        self.textFieldTest.delegate = self
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
}
