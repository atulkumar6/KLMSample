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
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
//        var newFrame = layoutAttributes.frame
//        newFrame.size.width = CGFloat(ceilf(Float(size.width)))
//        newFrame.size.height = CGFloat(ceilf(Float(size.height)))
//
//        layoutAttributes.frame = newFrame
//        return layoutAttributes
//    }
}
