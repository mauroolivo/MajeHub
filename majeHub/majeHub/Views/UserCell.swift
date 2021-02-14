//
//  UserCell.swift
//  majeHub
//
//  Created by Mauro Olivo on 13/02/21.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet var cellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    var onReuse: () -> Void = {}

    override func prepareForReuse() {
      super.prepareForReuse()
      onReuse()
      cellImageView.image = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

        func configure(_ user: User) {
            lblName.text = user.login
        }
}
