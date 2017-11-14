//
//  CollectionViewCell.swift
//  Reader
//
//  Created by мак on 30.07.17.
//  Copyright © 2017 мак. All rights reserved.
//

import UIKit

protocol CollectionCellDelegate: class {
    
    func delete(cell: CollectionViewCell)
    
}

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var deleteButton: UIVisualEffectView!
    
    weak var delegate: CollectionCellDelegate?
    
    var isEditing: Bool = false {
        didSet{
            deleteButton.isHidden = !isEditing
        }
    }
    
    

    @IBAction func deleteButtonDidTap(_ sender: Any) {
        
        
        
        
        
        delegate?.delete(cell: self)
        
        
        
    }
   

    
    
    
       
    

   
    
    
    
    
    }
