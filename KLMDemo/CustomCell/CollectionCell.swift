//
//  CollectionCell.swift
//  KLMDemo
//
//  Created by Atul Kumar on 9/11/18.
//  Copyright © 2018 Atul Kumar. All rights reserved.
//

import Foundation
import UIKit

class CollectionCell:UICollectionViewCell {
    // Cell Objects
    @IBOutlet weak var homeImageView: UIImageView?
    @IBOutlet weak var tagLabel: UILabel?
    @IBOutlet weak var favoriteImageView: UIImageView?
    // NibLifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
