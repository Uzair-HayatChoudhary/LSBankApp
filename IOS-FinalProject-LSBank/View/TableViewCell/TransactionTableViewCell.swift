//
//  TransactionTableViewCell.swift
//  IOS-FinalProject-LSBank
//
//  Created by english on 2021-11-25.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblAccountFolder: UILabel!
    @IBOutlet weak var imgType: UIImageView!
    @IBOutlet weak var lblDateTime: UILabel!
    
    
    static let identfier = "TransactionTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identfier, bundle: nil)
    } // func nib()
    
    func setCellContent(accountHolder : String, dateTime : String, amount : Double, credit : Bool, message : String){
        
        if credit == true {
            lblAccountFolder.text = "FROM \(accountHolder.uppercased()) "
            imgType.image = UIImage(systemName: "arrow.down")
            imgType.tintColor = .systemGreen
        }else{
            lblAccountFolder.text = "TO \(accountHolder.uppercased()) "
            imgType.image = UIImage(systemName: "arrow.up")
            imgType.tintColor = UIColor.systemRed
        }
        
        lblDateTime.text = dateTime
        lblAmount.text = amount.formatAsCurrency()
        lblMessage.text = message
        
        if message.count == 0 {
            lblMessage.isHidden = true
        }else{
            lblMessage.isHidden = false
        }
        
    } // func setCellContent
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    } // func setSelected
    
}// end class
