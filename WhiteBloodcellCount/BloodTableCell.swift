//
//  BloodTableCell.swift
//  WhiteBloodcellCount
//
//  Created by Tom Riddle on 10/31/20.
//

import UIKit

class BloodTableCell: UITableViewCell {

  @IBOutlet weak var imageLabel: UILabel!
  @IBOutlet weak var bloodImageView: UIImageView!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
