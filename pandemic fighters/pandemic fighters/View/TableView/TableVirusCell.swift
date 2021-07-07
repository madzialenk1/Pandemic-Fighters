//
//  TableViewCell.swift
//  pandemic fighters
//
//  Created by Magdalena  Pękacka on 07/06/2020.
//  Copyright © 2020 Magdalena  Pękacka. All rights reserved.
//

import UIKit

class TableVirusCell: UITableViewCell {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
