//
//  PayeeTableViewCell.swift
//  IOS-FinalProject-LSBank
//
//  Created by Daniel Carvalho on 14/11/21.
//

import UIKit

class PayeeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblFullName : UILabel!
    @IBOutlet weak var lblEmail : UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
