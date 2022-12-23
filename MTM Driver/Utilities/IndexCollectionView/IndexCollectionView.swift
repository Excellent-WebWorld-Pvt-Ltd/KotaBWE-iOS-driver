//
//  NumberCollectionView.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 15/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

class IndexCollectionView: UIView{

    var selectedIndex = 1{
        didSet{
            collectionView.reloadData()
        }
    }
    
    var textColor = UIColor.white
    var selectedTextColor = UIColor.white
    
    var indexBgColor = UIColor.black
    var selectedBgColor = UIColor.orange
    var count = 0
    var isCircle = true
    
    var userIntraction = true {
        didSet{
            collectionView.isUserInteractionEnabled = userIntraction
        }
    }
    var didSelectItemAt: ((IndexPath) -> ())?
    
    
    lazy private var collectionView : UICollectionView = {
        let layout  = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        layout.scrollDirection = .horizontal
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    override func draw(_ rect: CGRect) {
        backgroundColor = .clear
        customInitialiser()
      }
    
    private func customInitialiser(){
        collectionView.register(IndexCollectionViewCell.self, forCellWithReuseIdentifier: IndexCollectionViewCell.identifier)
        collectionView.frame = bounds
        addSubview(collectionView)
       
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
         backgroundColor = .clear
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
    }
  
   
}
extension IndexCollectionView:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IndexCollectionViewCell.identifier, for: indexPath) as! IndexCollectionViewCell
       
        cell.setup(index: indexPath.item,
                   selectedIndex : selectedIndex,
                   count: count,
                   isCircle : isCircle,
                   textColor: textColor,
                   selectedTextColor :selectedTextColor,
                   backgroundColor:indexBgColor,
                    selectedBgColor:selectedBgColor)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (bounds.width - 20) / CGFloat(count), height: bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        if didSelectItemAt != nil { didSelectItemAt!(indexPath)}
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout,
            let dataSourceCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: section),
            dataSourceCount > 0 else {
                return .zero
        }
        let cellCount =  CGFloat(dataSourceCount)
        let cellWidth = (bounds.width - 20) / CGFloat(count)
        var insets = flowLayout.sectionInset
        let totalCellWidth = (cellWidth * cellCount)
        let contentWidth = collectionView.bounds.size.width - collectionView.contentInset.left - collectionView.contentInset.right
        
        
        guard totalCellWidth < contentWidth else {
            return insets
        }
        // Calculate the right amount of padding to center the cells.
        let padding = (contentWidth - totalCellWidth ) / 2.0
        let lastLineWidthPadding = (cellWidth - bounds.height) / 2
        insets.left = padding + lastLineWidthPadding
        insets.right = padding - lastLineWidthPadding
        return insets
    }
    
}
