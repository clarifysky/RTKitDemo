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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "textFieldTest"
        self.textFieldTest.delegate = self
        
        RTPrint.shareInstance().prt("[TextFieldViewController] viewDidLoad:")
        RTPrint.shareInstance().prt("__frame: \(self.view.frame)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {       
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

extension TextFieldViewController: UITextFieldDelegate {

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        RTPrint.shareInstance().prt("string: " + string)
        RTPrint.shareInstance().prt("range: \(range)")
        RTPrint.shareInstance().prt("toRange: \(range.toRange(textField.text!))")
        RTPrint.shareInstance().prt("textFromTextField: \(textField.text)")
        let testStr = textField.text!.stringByReplacingCharactersInRange(range.toRange(textField.text!), withString: string)
        RTPrint.shareInstance().prt(testStr + ", length: \(testStr.characters.count)")
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        RTPrint.shareInstance().prt("you pressed the return button")
        return true
    }
}
