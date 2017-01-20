//
//  MyCollectionViewCell.swift
//  ExUICollectionView
//
//  Created by 林暐潔 on 2017/1/18.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    var imageView:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.red
        // 取得螢幕寬度
        let w = Double(UIScreen.main.bounds.size.width)
        
        // 建立一個 UIImageView
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: w/4, height: w/4))
        self.addSubview(imageView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
