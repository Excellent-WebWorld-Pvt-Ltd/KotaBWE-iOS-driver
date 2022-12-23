//
//  ColumnCollectionViewCell.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 16/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

class TileImageCollectionViewCell: UICollectionViewCell {
    var view : UIView = {
        let image = UIView()
        return image
    }()
    var imageView : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
       return image
    }()
    
    var labelTitle : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(labelTitle)
        addSubview(view)
        view.addSubview(imageView)
        addVisualFormatConstraints(format: "V:|[v0][v1(30)]|", views: view,labelTitle)
        addVisualFormatConstraints(format: "H:|[v0]|", views: labelTitle)
        addVisualFormatConstraints(format: "H:|-20-[v0]-20-|", views: imageView)
        addVisualFormatConstraints(format: "V:|-20-[v0]-20-|", views: imageView)
        
       
        NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute:.centerX, multiplier: 1.0, constant:0.0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: imageView, attribute:.width, multiplier: 1.0, constant:0.0).isActive = true
        
      }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupImage(image: String,
               cornerRadius: CGFloat,
               backgroundColor: UIColor,
               shadowOpticity: Float,
               shadowColor: CGColor){
        
        imageView.image = UIImage(named: image)
        view.layer.cornerRadius = cornerRadius
        view.backgroundColor = backgroundColor
        view.layer.shadowOpacity = shadowOpticity
        view.layer.shadowColor = shadowColor
    }
    
    func setupTitle(title: String,
                    textColor: UIColor,
                    font: UIFont){
            labelTitle.text = title
            labelTitle.font = font
            labelTitle.textColor = textColor
    }
    
}
