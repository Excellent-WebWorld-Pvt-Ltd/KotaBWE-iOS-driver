//
//  ColumnCollectionViewCell.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 16/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

class ColumnCollectionViewCell: UICollectionViewCell {
    
    
    var imageView : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
       image.clipsToBounds = true
       return image
    }()
    
    var labelTitle : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "has not been implemented"
        label.textColor = .white
       
        
        return label
    }()
    let shadowView : UIView = {
        let view = UIView()
       
        return view
    }()
    func setupShadow(){
        layoutIfNeeded()
        shadowView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        shadowView.isOpaque = true
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.4
        shadowView.layer.shadowOffset = CGSize(width: 0, height: -4)
        shadowView.clipsToBounds = false
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImageView()
        
        backgroundColor = .clear
        
    }
    func setImageView(){
        addSubview(imageView)
        addVisualFormatConstraints(format: "V:|[v0]|", views: imageView)
        addVisualFormatConstraints(format: "H:|[v0]|", views: imageView)
        
    }
    func addTitleLabel(title : String){
        imageView.addSubview(shadowView)
        addVisualFormatConstraints(format: "V:[v0(35)]|", views: shadowView)
        addVisualFormatConstraints(format: "H:|[v0]|", views: shadowView)
        
        shadowView.addSubview(labelTitle)
        addVisualFormatConstraints(format: "V:[v0(32)]-2-|", views: labelTitle)
        addVisualFormatConstraints(format: "H:|-2-[v0]-2-|", views: labelTitle)
        setupShadow()
        labelTitle.text = title
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setBorder(width: CGFloat,
                         color: UIColor){
        imageView.layer.borderColor = color.cgColor
        imageView.layer.borderWidth = width
    }
    func setupImage(imageContentMode : UIImageView.ContentMode,
                    imageCornerRadius: CGFloat,
                    backgroundColor: UIColor){
        imageView.contentMode = imageContentMode
        imageView.backgroundColor = backgroundColor
            imageView.layer.cornerRadius = imageCornerRadius
            imageView.clipsToBounds = true
    }
    

   
    
}
