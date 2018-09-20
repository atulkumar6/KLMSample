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
    @IBOutlet weak var imgVwHome: UIImageView?
    @IBOutlet weak var lblTag: UILabel?
    @IBOutlet weak var imgvwFav: UIImageView?
    // NibLifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
