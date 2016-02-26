//
//  EWCMessageCell.swift
//  
//
//  Created by Rex Tsao on 2/26/16.
//
//

import UIKit

class EWCMessageCell: UITableViewCell {
    
    var imageViewAvatar: UIImageView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        self.backgroundColor = UIColor.clearColor()
        self.addSubview(self.imageViewAvatar!)
    }
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
