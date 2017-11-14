//
//  LevelBooksCell.swift
//  Reader
//
//  Created by мак on 10.08.17.
//  Copyright © 2017 мак. All rights reserved.
//

import UIKit

class LevelBooksCell: UITableViewCell {

   
    @IBOutlet var imageBook: UIImageView!
    @IBOutlet var textBook: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var downloadBlock: (() -> ())?
    
    @IBAction func downloadBook(_ sender: Any) {
        downloadBlock?()
        //тут будем вызывать наш блок, в контроллере надо передать значения самого блока который  он вызовет, блок у нас щас упустой его присваиваем в контроллере
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
