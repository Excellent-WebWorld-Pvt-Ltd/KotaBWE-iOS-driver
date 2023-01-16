//
//  WeeklyUpdateCollectionCell.swift
//  Danfo_Driver
//
//  Created by Kinjal on 13/04/21.
//

import UIKit


class WeeklyUpdateCollectionCell: UICollectionViewCell {
    
    //MARK:- ==== Outlets ======
    @IBOutlet var lblDays: [ThemeLabel]!
    @IBOutlet weak var ViewContainerBase: UIView!
    @IBOutlet weak var segmentContrl: UISegmentedControl!
    @IBOutlet weak var lblRides: ThemeLabel!
    @IBOutlet weak var lblTimes: ThemeLabel!
    @IBOutlet weak var lblTips: ThemeLabel!
    @IBOutlet weak var lblTotal: ThemeLabel!
    @IBOutlet weak var lblDate: ThemeLabel!
    @IBOutlet weak var conHeightOfChart: NSLayoutConstraint!
    @IBOutlet weak var ViewbarChart: TutorialChartView!
    @IBOutlet weak var conHeightOfBarChart: NSLayoutConstraint!
    
    
    //MARK:- ===== Variables =======
    var anchorView: UIView?
    var days: [String]!
    lazy var myTipView: CustomMarkerView = CustomMarkerView.fromNib()
    var nextBtnClick:(()->())?
    var previousBtnClick:(()->())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myTipView.frame.size = CGSize(width: 60, height: 20)
        segmentContrl.tintColor = UIColor.red
        ViewbarChart.onTapBar = { [unowned self] (view,Value) in
            self.setAnhorToBar(view, value: Value)
        }
    }
    
    private func setAnhorToBar(_ view: UIView , value : Double) {
        anchorView?.removeFromSuperview()
        let frame = view.convert(view.bounds, to: contentView)
        myTipView.lblTitle.text = "\(value)".toCurrencyString()
        myTipView.frame.origin.x = frame.origin.x - 12
        myTipView.frame.origin.y = frame.origin.y - (myTipView.frame.height + 2)
        contentView.addSubview(myTipView)
        anchorView = myTipView
    }
    
    //MARK:- === Previous btn Click =====
    @IBAction func btnActionPrevious(_ sender: UIButton) {
        anchorView?.removeFromSuperview()
       // previousBtnClick?()
        
    }
    
    //MARK:- === Next btn Click =====
    @IBAction func btnActionNext(_ sender: UIButton) {
        anchorView?.removeFromSuperview()
      //  nextBtnClick?()
    }
    
    
    func dataSetup(dataPoints:[Double]){
        
           ViewbarChart.setData(dataPoints)
    }
}
    

