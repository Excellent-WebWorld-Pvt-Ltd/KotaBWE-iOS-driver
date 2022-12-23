//
//  MeterDisplayVC.swift
//  DSP Driver
//
//  Created by Harsh Dave on 28/10/21.
//  Copyright © 2021 baps. All rights reserved.
//

import UIKit


class MeterDisplayVC: BaseViewController {

    //MARK:- ==== Outlets ======
    @IBOutlet weak var lblTipFare: ThemeLabel!
    @IBOutlet weak var colStandard: UICollectionView!
    @IBOutlet weak var vwShadow: UIView!
    @IBOutlet weak var btnstart: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var vwTripTime: UIView!
    @IBOutlet weak var vwTripDistance: UIView!
    @IBOutlet weak var vwWaitingTime: UIView!
    @IBOutlet weak var lblWaitingTime: ThemeLabel!
    @IBOutlet weak var lblDistance: ThemeLabel!
    @IBOutlet weak var lblTime: ThemeLabel!
    @IBOutlet weak var lblDate: ThemeUnderlinedLabel!
    @IBOutlet weak var lblTripTime: ThemeLabel!
    @IBOutlet weak var lblSpecialCharge: ThemeUnderlinedLabel!

    //MARK:- ==== Variables ======
    var manager: MeterManager {
        MeterManager.shared
    }
    
    //MARK:- ===== View Controller Life Cycle ========
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        lblSpecialCharge.text = "0".toCurrencyString()
        dataSetup()
        colStandard.delegate = self
        colStandard.dataSource = self
        colStandard.reloadData()
        viewShadow()
        self.setupNavigation(.normal(title: "Meter", leftItem: .back))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refresh()
    }
    
    //MARK:- ==== View & DataSetup ====
    func viewShadow(){
        btnstart.underline()
        btnStop.underline()
        vwShadow.addShadow(to: [.top,.left],radius: 10.0)
        vwShadow.shadowColor = .black
        vwTripTime.addShadow(to: [.top,.left],radius: 10.0)
        vwTripTime.shadowColor = .black
        vwTripDistance.addShadow(to: [.top,.left],radius: 10.0)
        vwTripDistance.shadowColor = .black
        vwWaitingTime.addShadow(to: [.top,.left],radius: 10.0)
        vwWaitingTime.shadowColor = .black
    }
    
    //MARK:- ===== DataSetup =======
    func dataSetup(){
        let startedDateTime = Singleton.shared.meterInfo?.startedTime.timeStampToDate() ?? Date()
        lblDate.text = DateFormatHelper.fullDate.getDateString(from: startedDateTime)
        lblTime.text = DateFormatHelper.twelveHrTime.getDateString(from: startedDateTime)
    }
    
    @IBAction func btnActionEndTrip(_ sender: UIButton) {
        manager.webServiceCallEndMeter()
    }
    
    //MARK:- ===== Btn Action Start ======
    @IBAction func btnActionStart(_ sender: UIButton) {
        manager.startedWaitingMeterSetup()
        manager.startWaitingTimeMeter()
    }
    
    //MARK:- ===== Btn Action Stop =====
    @IBAction func btnActionStop(_ sender: UIButton) {
        manager.stopWaitingMeterSetup()
        manager.endWaitingTimeMeter()
    }
}

extension MeterDisplayVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:MeterColCell = colStandard.dequeueReusableCell(withReuseIdentifier: "MeterColCell", for: indexPath) as! MeterColCell
        cell.lblCarType.text = Singleton.shared.meterInfo?.name
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.colStandard.frame.width - 20, height: 61)//CGRect(x: 0, y: 0, width: , height: )
    }
    
    //MARK:- ===== Webservice Call End Trip ====
    
}

//MARK:- ==== Socket calls ========

extension MeterDisplayVC: MeterMangerDelegate {
    
    func refresh() {
        meterDidChangeTripFare()
        meterDidChangeTripTime()
        meterDidChangeTripDistance()
        meterDidChangeWaitingTime()
        meterChangeStartStopButtonStatus()
    }
    
    func meterDidChangeTripFare() {
        self.lblTipFare.text = manager.total.toCurrencyString()
    }
    
    func meterDidChangeTripTime() {
        self.lblTripTime.text = manager.formattedTripTime
    }
    
    func meterDidChangeTripDistance() {
        self.lblDistance.text = manager.formattedTripDistance
    }
    
    func meterDidChangeWaitingTime() {
        self.lblWaitingTime.text = manager.formattedWatingTime
    }
    
    func meterChangeStartStopButtonStatus() {
        btnstart.isEnabled = manager.isStartWaitingEnabled
        btnStop.isEnabled = manager.isEndWaitingEnabled
    }

    func meterPresentInvoiceView() {
        let trippaymentVc:EndMeterPaymentInfo = UIViewController.viewControllerInstance(storyBoard: .tripDetails)
        trippaymentVc.modalPresentationStyle = .overFullScreen
        trippaymentVc.strDistance = self.lblDistance.text ?? ""
        trippaymentVc.strTripTime = self.lblTripTime.text ?? ""
        trippaymentVc.strWaitingTime = self.lblWaitingTime.text ?? ""
        trippaymentVc.strTripFare = self.lblTipFare.text ?? ""
        trippaymentVc.endMeterClousure = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        self.present(trippaymentVc, animated: true, completion: nil)
    }
    
    func meterGetWaitingTimeText() -> String {
        self.lblWaitingTime.text ?? ""
    }
}
