//
//  MenuButtonTableViewCell.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 5/19/16.
//  Copyright © 2016 rexcao. All rights reserved.
//

import UIKit

class MenuButtonTableViewCell: UITableViewCell {

    var menuButton: MenuButton?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.attachButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func attachButton() {
        self.menuButton = MenuButton()
        self.menuButton?.setTitle("测试", forState: .Normal)
        self.menuButton?.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.menuButton?.sizeToFit()
        self.menuButton?.setOrigin(CGPointMake(10, RTMath.centerPos(self.height, length: self.menuButton!.height)))
        self.addSubview(self.menuButton!)
    }

}
