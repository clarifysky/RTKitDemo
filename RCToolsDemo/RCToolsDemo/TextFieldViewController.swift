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
        let testStr = textField.text.stringByReplacingCharactersInRange(range.toRange(textField.text), withString: string)
        println(testStr + ", length: \(count(testStr))")
        return true
    }
}


// Make String in swift can use stringByReplacingCharactersInRange
extension NSRange {
    func toRange(string: String) -> Range<String.Index> {
        let startIndex = advance(string.startIndex, self.location)
        let endIndex = advance(startIndex, self.length)
        return startIndex..<endIndex
    }
}
