//
//  CollumnView.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 16/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

class ColumnView: UIView {

    //-------------------------------------
    // MARK:- Can be Set
    //-------------------------------------
    
    var dataSource = [String]()
    
    var imageDataSource = false
    
    var imageArray = [UIImage]()
    
    var isPagingEnabled = true
    
    var imageBorderWidth : CGFloat = 0
    var imageBorderColor: UIColor = .clear
    var imageCornerRadius: CGFloat = 0.0
    var noOfColumn = 0
    var imageBackgroundColor: UIColor = UIColor(custom: .group)

    var collectionViewScrollDirection = UICollectionView.ScrollDirection.vertical
    
    var userIntraction = true {
        didSet{
            collectionView.isUserInteractionEnabled = userIntraction
        }
    }
    var collectionViewInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0){
        didSet{
            layout.cellInset = collectionViewInset
        }
    }
    
    var titleText = ""
     var imageContentMode = UIImageView.ContentMode.scaleToFill
    
    var keepCellInCenter = false{
        didSet{
            layout.cellInCenter = keepCellInCenter
        }
    }
    
    var cellInInfiniteLoop = false
    
    var didSelectItemAt: ((IndexPath) -> ())?
    var indexpathDidChange: ((_ previousIndexPath :IndexPath,_ indexPath: IndexPath) -> ())?
    
     var itemSize = CGSize(width: 100, height: 100)
    
    var spacing = CGFloat(1){
        didSet{
            layout.insetSpacing = spacing
        }
    }
    
     var previousIndexPath = IndexPath(item: 0, section: 0)
    
  
    var presentIndexPath = IndexPath(item: 0, section: 0){
        willSet{
            previousIndexPath = presentIndexPath
        }didSet{
            if presentIndexPath != previousIndexPath{
                if indexpathDidChange != nil { indexpathDidChange!(previousIndexPath, presentIndexPath)}
            }
        }
    }
    
    func scrollCollection(index: Int){
        collectionView.scrollToItem(at: IndexPath(item: index , section: 0), at: .centeredHorizontally, animated: false)
    }
    
    // //-------------------------------------
    // MARK:- private data
    //-------------------------------------
    let layout  = YourCollectionLayoutSubclass()
    func reloadData(){
        collectionView.reloadData()
    }
    lazy private var collectionView : UICollectionView = {
       
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        layout.scrollDirection = collectionViewScrollDirection
        
        collectionView.isPagingEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func draw(_ rect: CGRect) {
        customInitialiser()
        centerCell()
        if cellInInfiniteLoop  {
            scrollCollection(index: infiniteCount / 2)
        }
    }
    
    private var previousOffset: CGFloat = 0
    private var infiniteCount = 100000
    
    private func customInitialiser(){
        collectionView.register(ColumnCollectionViewCell.self, forCellWithReuseIdentifier: ColumnCollectionViewCell.identifier)
        addSubview(collectionView)
        

        addVisualFormatConstraints(format: "V:|[v0]|", views: collectionView)
        addVisualFormatConstraints(format: "H:|[v0]|", views: collectionView)
        
    }
    private func centerCell(){
        guard keepCellInCenter else {
            collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
            return
            
        }
        collectionView.contentInset = UIEdgeInsets.init(top: 0, left: (frame.width - itemSize.width) / 2, bottom: 0, right: (frame.width - itemSize.width) / 2)
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        self.layoutIfNeeded()
    }
    
}
extension ColumnView:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard !cellInInfiniteLoop else {
            return infiniteCount
        }
        return imageDataSource ? imageArray.count : dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColumnCollectionViewCell.identifier, for: indexPath) as! ColumnCollectionViewCell
        cell.setupImage(imageContentMode: imageContentMode,
                        imageCornerRadius:imageCornerRadius,
                        backgroundColor: imageBackgroundColor)
        
        if imageDataSource != true {
            UtilityClass.imageGet(url: NetworkEnvironment.baseImageURL + dataSource[indexPath.row], img: cell.imageView)
        }
        else {
            cell.imageView.image = imageDataSource ? imageArray[indexPath.item % imageArray.count] : UIImage(named: dataSource[indexPath.item % dataSource.count])
            
        }
       
//        let img = imageDataSource ? imageArray[indexPath.item % imageArray.count] : UIImage(named: dataSource[indexPath.item % dataSource.count])
//        if img == UIImage(named: "car-1") || img == UIImage(named: "car-2") || img == UIImage(named: "car-3") || img == UIImage(named: "car-4") {
//            cell.imageView.contentMode = .center
//        } else {
//            cell.imageView.contentMode = .scaleAspectFill
//        }
        
//        if imageBorderWidth != 0{
//            cell.setBorder(width: imageBorderWidth,
//                                 color: imageBorderColor)
//        }
//        if titleText != ""{
//            cell.addTitleLabel(title : titleText)
//        }
//        cell.backgroundColor = .clear
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if didSelectItemAt != nil { didSelectItemAt!(indexPath)}
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard noOfColumn != 0 else{ return layout.cellInset ?? collectionViewInset }
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth: CGFloat = itemSize.width
        let cellHeight: CGFloat = itemSize.height
        //      let cellSpacing: CGFloat = flowLayout.minimumInteritemSpacing
         let count = imageDataSource ? imageArray.count : dataSource.count
        let cellCount = CGFloat(count)
        var collectionWidth = collectionView.frame.size.width
        var collectionHeight = collectionView.frame.size.height
       
        if noOfColumn > count { noOfColumn = count}
        var floatColumn = CGFloat(noOfColumn)
        
        if #available(iOS 11.0, *) {
            collectionWidth -= collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right
            collectionHeight -= collectionView.safeAreaInsets.top + collectionView.safeAreaInsets.bottom
        }
        var totalWidth = cellWidth * floatColumn + spacing * (floatColumn )
        
        if totalWidth > collectionWidth{
            floatColumn = CGFloat(Int((collectionWidth - spacing) / (cellWidth + spacing)))
            totalWidth = cellWidth * floatColumn + spacing * (floatColumn )
        }
        let totalHeight = cellHeight * (cellCount / floatColumn) + spacing * ((cellCount / floatColumn ) )
        let edgeInsetWidth = ((collectionWidth - totalWidth) / 2) - spacing
        
        let edgeInsetHieght = ((collectionHeight - totalHeight) / 2) - spacing
        print(edgeInsetHieght, edgeInsetHieght)
        
        if  totalHeight > collectionHeight{
            return UIEdgeInsets(top: 16, left: edgeInsetWidth, bottom: flowLayout.sectionInset.bottom, right: edgeInsetWidth)
        }
        return UIEdgeInsets(top: edgeInsetHieght, left: edgeInsetWidth, bottom: edgeInsetHieght, right: edgeInsetWidth)
        
    }
   
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        presentIndexPath = indexPath
    }
    
}

class YourCollectionLayoutSubclass: UICollectionViewFlowLayout {
    var previousOffset : CGFloat = 0
    var currentPage : CGFloat = 0
    
    fileprivate var cellInset : UIEdgeInsets?
    fileprivate var insetSpacing : CGFloat = 1
    fileprivate var cellInCenter = false
    
    override public func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        let willtoNextX: CGFloat
        
        if proposedContentOffset.x <= 0 || collectionView.contentOffset == proposedContentOffset {
            willtoNextX = proposedContentOffset.x
        } else {
            let width = collectionView.bounds.size.width
            willtoNextX = collectionView.contentOffset.x + (velocity.x > 0 ?  width : -width)
        }
        
        let targetRect = CGRect(x: willtoNextX, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
        
        var offsetAdjustCoefficient = CGFloat.greatestFiniteMagnitude
        
        let horizontalOffset = proposedContentOffset.x + collectionView.contentInset.left
        
        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)
        
        layoutAttributesArray?.forEach({ (layoutAttributes) in
            let itemOffset = layoutAttributes.frame.origin.x
            if fabsf(Float(itemOffset - horizontalOffset)) < fabsf(Float(offsetAdjustCoefficient)) {
                offsetAdjustCoefficient = itemOffset - horizontalOffset
            }
        })
        if cellInset != nil{
             return CGPoint(x: proposedContentOffset.x + offsetAdjustCoefficient - cellInset!.left , y: proposedContentOffset.y)
        }
         return CGPoint(x: proposedContentOffset.x + offsetAdjustCoefficient, y: proposedContentOffset.y)
    }
}

// //-------------------------------------
// MARK:- Private
//-------------------------------------

