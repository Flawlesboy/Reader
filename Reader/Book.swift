//
//  Books.swift
//  Reader
//
//  Created by мак on 03.08.17.
//  Copyright © 2017 мак. All rights reserved.
//

import UIKit
import Parse

class Book {
    var name: String
    var image: UIImage
    var level: String
    var describe: String
    var bookFile: PFFile
    
    
    init(name: String, image: UIImage, level: String, describe: String, bookFile: PFFile) {
        self.name = name
        self.image = image
        self.level = level
        self.describe = describe
        self.bookFile = bookFile
    }
}


