//
//  collectionViewCell.swift
//  collectionview_xmixdrix
//
//  Created by admin on 3/4/16.
//  Copyright © 2016 il.ac.afeka. All rights reserved.
//

import UIKit
class CollectionViewCell: UICollectionViewCell{
   
    
    var isActive = false  //cards are active a long as not found
     var isFlipped = false //face down
    var cardPicture = ""
    
    @IBOutlet weak var cellLabel: UILabel!
    
    func initCard(picture: String)
    {
        isActive = true
        isFlipped=false
        cardPicture  = picture
    }
    
    
    func flipCard()
    {
        if(self.isFlipped)
        {self.hide()}
        else{self.show()}
    }
    
   
    func hide()
    {
        cellLabel.text = "?"
        isFlipped=false
    }
    
    func show()
    {
        cellLabel.text = cardPicture
        isFlipped = true
    }
}

