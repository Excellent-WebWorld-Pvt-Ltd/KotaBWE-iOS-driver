//
//  EarningVC.swift
//  Danfo_Driver
//
//  Created by Kinjal on 12/04/21.
//

import UIKit

enum EarningType:String {
    case daily = "Daily"
    case weekly = "Weekly"
}

class EarningVC: BaseViewController {

    //MARK:- ======= Outlets ========
    @IBOutlet weak var conHeightOfCollection: NSLayoutConstraint!
    @IBOutlet weak var tblEarning: UITableView!
    @IBOutlet weak var colWeeklyUpdates: UICollectionView!
    @IBOutlet weak var btnWeekly: UnderlineTextButton!
    @IBOutlet weak var lblHistory: ThemeLabel!
    
    
    //MARK:- ==== Variables ======
    var currentDate = Date()
    var isShowGraph = false
    let seletedDate = String()
    var objEarning : RootEarning?
    var arrEarningHistory = [Earning]()
    let Todaydata = Date()
    let dateFormatter = DateFormatter()
    private var showNoDataCell = false
    var days = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
    var dictDays = [String:Any]()
    var task = ["0.0","0.0","0.0","0.0","0.0","0.0","0.0"]
    var weekDays : [(day: String, date: String , FullDateFormateString:String)] = []
    var earningType : EarningType = .daily {
        didSet {
            switch earningType {
            case .daily:
                conHeightOfCollection.constant = 220
                underLineBtnSetup(Type:.weekly)
                webserviceCallTotalEarning(Type: earningType.rawValue.lowercased(), FromDate: DateFormatHelper.digitDate.getDateString(from: Todaydata), ToDate: "")
            case .weekly :
                conHeightOfCollection.constant = 350
                underLineBtnSetup(Type: .daily)
                webserviceCallTotalEarning(Type: earningType.rawValue.lowercased(), FromDate: weekDays.first?.FullDateFormateString ?? "", ToDate: weekDays.last?.FullDateFormateString ?? "")
            }
        }
    }

    //MARK:- ===== View Controller Life cycle =======
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in self.days {
            dictDays[i] = 0.0
        }
        print(dictDays)
        earningType = .daily
        getWeekDays(FromDate:currentDate)
        tblEarning.registerNibCell(type: .noData)
        setupNavigation(.normal(title: "Earnings".localized, leftItem: .back, hasNotification: false))
        tblEarning.registerNibCell(type: .walletHistory)
        tblEarning.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblEarning.frame.size.width, height: 1))
    }
    
    //MARK:- Add Shimmer effect  ====
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        view.setTemplateWithSubviews(true, viewBackgroundColor: .lightGray)
      }
    
    //MARK:- ==== Stop Shimmer Effect ====
    func stopShimmer(){
       self.view.setTemplateWithSubviews(false)
    }
    
    //MARK:- ====== UnderLine button =====
    func underLineBtnSetup(Type:EarningType){
        let FormattedText = NSMutableAttributedString()
        FormattedText.bold14(Type.rawValue.localized)
        btnWeekly.setAttributedTitle(FormattedText, for: .normal)
    }
    
    func setLocalization(){
        self.lblHistory.text = "History".localized
    }
    
    //MARK:- ====== Btn Action weekly =======
    @IBAction func btnActionWeekly(_ sender: UIButton) {
        switch earningType {
        case .daily:
            earningType = .weekly
        case .weekly :
            earningType = .daily
        }
    }
    
    //MARK:- ======== Btn action withDraw ========
    @IBAction func btnActionWithDraw(_ sender: UIButton){
        
        let view = AddMoneyView(isfromWithDraw: true) { [unowned self] amount in
            print("Amount: ", amount)

            let withdrawSuccessVC : WithDrawSuccessfulVC  = UIViewController.viewControllerInstance(storyBoard: .payment)
             withdrawSuccessVC.userTappedOKClosure = { [unowned self] in
                self.dismiss(animated: true, completion: nil)
            }
            self.present(withdrawSuccessVC, animated: true, completion: nil)
        }
        let viewCtr = AppViewControllers.shared.bottomSheet(title: "Withdraw Money", view: view)
        self.present(viewCtr, animated: true)

    }
    
    func getWeekDays(FromDate : Date) {
        let dateInWeek = FromDate
        weekDays = []
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: dateInWeek)
        if let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: dateInWeek){
            let days = (weekdays.lowerBound+1 ..< weekdays.upperBound+1)
                .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: dateInWeek)}
            for day in days{
                print(day)
                let strDay = day.formattedDateStartWithDay?.convertDateString(inputFormat: .ddMMyyyy, outputFormat: .onlyNameOfDay) ?? ""
                self.weekDays.append((day: strDay, date: day.formattedDateStartWithDay ?? "nil", FullDateFormateString: day.formattedDigitDate ?? "nil"))
                print(weekDays)
                
            }
        }
    }
}

extension EarningVC : UICollectionViewDataSource , UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colWeeklyUpdates.dequeueReusableCell(withReuseIdentifier: "WeeklyUpdateCollectionCell", for: indexPath) as! WeeklyUpdateCollectionCell
//        cell.chartData()
        cell.days = days
        cell.conHeightOfChart.constant = self.earningType == .daily ? 0 : 100
        cell.segmentContrl.isHidden = self.earningType == .daily ? true : false
        cell.segmentContrl.frame.size.height = self.earningType == .daily ? 0 : 30

        for i in cell.lblDays {
            i.isHidden =  self.earningType == .daily ? true : false
        }
//
        if self.earningType == .weekly{
            DispatchQueue.main.async {
                cell.segmentContrl.isHidden = false
                cell.segmentContrl.layoutIfNeeded()
                cell.segmentContrl.frame.size.height = 30
            }

            cell.ViewbarChart.isHidden = false
            let arrOfDoubles = task.map { (value) -> Double in
                let newString = value.replacingOccurrences(of: ",", with: "")
                return Double(newString) ?? 0.0
            }
            cell.dataSetup(dataPoints:arrOfDoubles)
        }
        cell.nextBtnClick = { [unowned self] in
            switch self.earningType {
            case .daily:
                let date = self.currentDate.dayAfter
                if date < Date(){
                    self.currentDate = date
                    self.webserviceCallTotalEarning(Type: self.earningType.rawValue.lowercased(), FromDate: DateFormatHelper.digitDate.getDateString(from: self.currentDate), ToDate: "")
                }
            case .weekly:
                let nextWeekDate = self.weekDays.last?.FullDateFormateString
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = DateFormatHelper.digitDate.rawValue
                let DateDigit =  dateFormatter.date(from: nextWeekDate ?? "")
                //weekDays?.get(direction: .previous, dayName: .monday, considerToday: true)
                if DateDigit ?? Date() < Date(){
                    self.getWeekDays(FromDate:DateDigit ?? Date())
                    self.webserviceCallTotalEarning(Type: self.earningType.rawValue.lowercased(), FromDate: self.weekDays.first?.FullDateFormateString ?? "", ToDate: self.weekDays.last?.FullDateFormateString ?? "")
                }
            }
        }
        cell.previousBtnClick = { [unowned self] in
            switch self.earningType {
            case .daily:
                let date = self.currentDate.dayBefore
                self.currentDate = date
                self.webserviceCallTotalEarning(Type: self.earningType.rawValue.lowercased(), FromDate: DateFormatHelper.digitDate.getDateString(from: self.currentDate), ToDate: "")
            case.weekly :
                let nextWeekDate = self.weekDays.first?.FullDateFormateString
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = DateFormatHelper.digitDate.rawValue
                let DateDigit =  dateFormatter.date(from: nextWeekDate ?? "")
                let weekDays = DateDigit?.dayBeforeWeek
                self.getWeekDays(FromDate:weekDays ?? Date())
                self.webserviceCallTotalEarning(Type: self.earningType.rawValue.lowercased(), FromDate: self.weekDays.first?.FullDateFormateString ?? "", ToDate: self.weekDays.last?.FullDateFormateString ?? "")
            }
        }
        cell.lblTimes.text = objEarning?.totalTime.secondsToTimeFormat()
        cell.lblDate.text = objEarning?.currentDate
        cell.lblTips.text = "\(Currency) \(objEarning?.totalTips ?? "")"
        cell.lblRides.text = "\(objEarning?.totalBooking ?? 0)"
        cell.lblTotal.text = "\(Currency) \(objEarning?.totalPrice ?? "")"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:colWeeklyUpdates.frame.size.width, height: colWeeklyUpdates.frame.size.height)
    }
}

extension EarningVC : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showNoDataCell ? 1 : arrEarningHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  showNoDataCell {
            let cell: NoDataFoundTblCell = tableView.dequeueReusableCell(withType: .noData, for: indexPath)
            cell.setMessage("\("No earning history found".localized)!")
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellType.walletHistory.cellId, for: indexPath) as! WalletHistoryTableViewCell
            cell.amountLable.textColor = .themeSuccess
            cell.amountLable.text = "+" + (arrEarningHistory[indexPath.row].driverAmount.toCurrencyString())
            cell.timeLabel.text = arrEarningHistory[indexPath.row].dropoffTime
            cell.titleLabel.text = "ID #\(arrEarningHistory[indexPath.row].id ?? "0")  (\(arrEarningHistory[indexPath.row].paymentType ?? ""))"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return showNoDataCell ?  tblEarning.frame.size.height : UITableView.automaticDimension
    }
}

extension EarningVC {
    
    func webserviceCallTotalEarning(Type:String,FromDate:String,ToDate:String){
        Loader.showHUD(with: self.view)
        let reqmodel = EarningRequestModel()
        reqmodel.driver_id = Singleton.shared.userProfile?.responseObject.id ?? ""
        reqmodel.from_date = FromDate
        reqmodel.to_date = ToDate
        reqmodel.type = Type
        WebServiceCalls.totalEarningReport(reqmodel: reqmodel) { response, status in
            DispatchQueue.main.async {
                self.stopShimmer()
            }
            Loader.hideHUD()
            if status {
                if response["graph"].dictionary  != nil {
                    //self.conHeightOfCollection.constant = 320
                    self.isShowGraph = true
                    guard let dict = response["graph"].dictionaryObject else { return }
                    for (key,value) in dict {
                        for (dictKey,_) in self.dictDays {
                            if dictKey.lowercased() == key.lowercased(){
                                self.dictDays.updateValue(value, forKey: key)
                            }
                        }
                    }
                    for (key,value) in self.dictDays{
                        switch key {
                        case "Mon":
                            self.task[0] = "\(value)"
                        case "Tue":
                            self.task[1] = "\(value)"
                        case "Wed":
                            self.task[2] = "\(value)"
                        case "Thu":
                            self.task[3] = "\(value)"
                        case "Fri":
                            self.task[4] = "\(value)"
                        case "Sat":
                            self.task[5] = "\(value)"
                        case "Sun":
                            self.task[6] = "\(value)"
                        default:
                            break
                        }
                    }
                  }else {
                    self.isShowGraph = false
                      self.task = ["0.0","0.0","0.0","0.0","0.0","0.0","0.0"]
                }
                let objResponse = RootEarning(fromJson: response)
                print("GRAPH........................",objResponse.graph)
                self.objEarning = objResponse
                self.arrEarningHistory.removeAll()
                if objResponse.earnings.count != 0 {
                    self.arrEarningHistory = objResponse.earnings
                }
                self.showNoDataCell = self.arrEarningHistory.isEmpty
                self.tblEarning.reloadData()
                self.colWeeklyUpdates.reloadData()
            }
            else {
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }
}

extension Date {
  // weekday is in form 1...7
  enum WeekDay: Int {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
  }
  
  enum SearchDirection {
    case next
    case previous
    
    var calendarOptions: NSCalendar.Options {
      switch self {
      case .next:
        return .matchNextTime
      case .previous:
        return [.searchBackwards, .matchNextTime]
      }
    }
  }
  
  func get(direction: SearchDirection, dayName: WeekDay, considerToday consider: Bool = false) -> Date {
    
    let nextWeekDayIndex = dayName.rawValue
    let today = self
    let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
    
    if consider && calendar.component(.weekday, from: today as Date) == nextWeekDayIndex {
      return today
    }
    
    var nextDateComponent = DateComponents()
    nextDateComponent.weekday = nextWeekDayIndex
    
    let date = calendar.nextDate(after: today, matching: nextDateComponent, options: direction.calendarOptions)!
    print(date)
    return date
  }
  
}
