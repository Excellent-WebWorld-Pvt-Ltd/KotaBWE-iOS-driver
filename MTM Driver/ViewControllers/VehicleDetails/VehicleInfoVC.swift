//
//  VehicleInfoVC.swift
//  DSP Driver
//
//  Created by Admin on 10/11/21.
//  Copyright © 2021 baps. All rights reserved.
//

import UIKit
import Kingfisher
import SDWebImage

class VehicleInfoVC: BaseViewController {
    
    
    //MARK:- ====== Outlets =======
    @IBOutlet weak var txtVehicleColor: UITextField!
    @IBOutlet weak var lblVehicleManufactureType: UILabel!
    @IBOutlet weak var lblVehicleModel: UILabel!
    @IBOutlet weak var lblVehicleNumberOfPassenger: UILabel!
    @IBOutlet weak var lblVehicleManufactureYear: UILabel!
    @IBOutlet weak var lblVehicleType: UILabel!
    
    @IBOutlet weak var collimages: UICollectionView!
    @IBOutlet weak var txtVehicleNumber: UITextField!
    @IBOutlet var txtVehicleModel: UITextField!
    @IBOutlet var txtVehicleManufactureYear: UITextField!
    @IBOutlet weak var txtCarType: UITextField!
    @IBOutlet var txtNoOfPassenger: UITextField!
    @IBOutlet var txtCompanyName: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    
    
    //MARK:- ===== Variables ======
    let parameterArray = RegistrationParameter.shared
    var imagesTypes : [(parameter: String,image: UIImage)] = [("",#imageLiteral(resourceName: "car-1")),
                                                              ("",#imageLiteral(resourceName: "car-2")),
                                                              ("",#imageLiteral(resourceName: "car-3")),
                                                              ("",#imageLiteral(resourceName: "car-4"))]
    
    var pickerViewManufYear = UIPickerView()
    var pickerViewPassenger = UIPickerView()
    var pickerViewVehicleName = UIPickerView()
    var pickerViewComapanyName = UIPickerView()
    var pickerViewVehicleModel = UIPickerView()
    var arrVehicleModel = VehicleData()
    var isFromSetting = false
    var arrYearMenufacList = [String]()
    var arrVehicleTypeName = [String]()
    var arrCompanyName = [String]()
    var arrVehicleData = [VehicleData]()
    var vehicleUpdatedType = String()
    var vehicleSelectedManuID = String()
    var vehicleSelectedSubModelID = String()
    var defaultImage = [(parameter: String,image: UIImage)]()
    let arrayNoOfPassenger = [Int](1...25)

    
    //MARK:- ===== View Controller Life Cycle -======
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        self.setupNavigation(.normal(title: "Vehicle Document", leftItem: .back))
        
        pickerViewComapanyName.dataSource = self
        pickerViewComapanyName.delegate = self
        
        pickerViewManufYear.dataSource = self
        pickerViewManufYear.delegate = self
        
        pickerViewVehicleModel.dataSource = self
        pickerViewVehicleModel.delegate = self
        
        pickerViewPassenger.dataSource = self
        pickerViewPassenger.delegate = self
        
        webserviceForVehicleMenufactureYearList()
        
        assignDelegate()
        
    }
    
    
    //MARK:- ===== Navigation  =======
    func navigateToVC(){
        if parameterArray.shouldAutomaticallyMoveToPage(from: .vehicleInfo) {
            let vehicleDocVC = AppViewControllers.shared.vehicleDocs(isFromSettings: false)
            self.push(vehicleDocVC)
        }
    }
    
    //MARK:- ==== Btn Action Manufacture Type ====
    @IBAction func btnActionVehicleManufactureType(_ sender: UIButton) {
        
    }
    
    
    //MARK:- ==== Btn Action Vehicle Model ====
    @IBAction func btnActionVehicleModel(_ sender: UIButton) {
       
    }
    
    
    //MARK:- ==== Btn Action Vehicle Type ====
    @IBAction func btnActionVehicleType(_ sender: UIButton) {
    }
    
    
    //MARK:- ==== Btn Action  Type ====
    @IBAction func btnActionVehicleMAnufactureYear(_ sender: UIButton) {
        openDatePicker()
    }
    
    
    //MARK:- ==== Btn Action Manufacture Type ====
    @IBAction func btnActionNoofPassenger(_ sender: UIButton) {
        
    }
    
        func assignDelegate(){
            txtVehicleNumber.delegate = self
            txtVehicleModel.delegate = self
            txtVehicleManufactureYear.delegate = self
           // txtVehicleSubName.delegate = self
            txtCarType.delegate = self
            txtNoOfPassenger.delegate = self
            txtCompanyName.delegate = self
        }
   
    func setupTextField(){
        
        //  setupColumnView()
        defaultImage = imagesTypes
        if let profile = SessionManager.shared.registrationParameter {
            btnNext.setTitle("Next", for: .normal)
            
            // collectionview.imageDataSource = false
            print("----------------------------------------------------------")
            print("----------------------------------------------------------")
            print("SCREEN Vehicle Info ")
            print("----------------------------------------------------------")
            print("----------------------------------------------------------")
            print(parameterArray as Any)
            print("----------------------------------------------------------")
            print("----------------------------------------------------------")
            
            self.arrYearMenufacList = Singleton.shared.menufacturingYearList
            
            if Singleton.shared.vehicleData != nil {
                self.arrVehicleData = Singleton.shared.vehicleData
                self.arrCompanyName = Singleton.shared.vehicleData.map({$0.manufacturerName})
                print(self.arrCompanyName)
            }
            txtVehicleColor.text = profile.vehicle_color
            txtVehicleNumber.text = profile.plate_number
            txtVehicleManufactureYear.text = profile.year_of_manufacture
            txtCarType.text = profile.vehicleTypeString
            txtNoOfPassenger.text = profile.no_of_passenger
            txtCompanyName.text = profile.vehicle_type_manufacturer_name
            
            // ----------------------------------------------------------
            // ----------------------------------------------------------
            
            txtVehicleModel.text = profile.vehicle_type_model_name
            txtVehicleManufactureYear.text = profile.year_of_manufacture
            txtNoOfPassenger.text = profile.no_of_passenger
            txtVehicleNumber.text = profile.plate_number
            txtVehicleColor.text = profile.vehicle_color
            txtVehicleModel.text = profile.vehicle_type_model_name
            self.vehicleUpdatedType = profile.vehicle_type
            
            self.vehicleSelectedSubModelID = profile.vehicle_type_model_id
            self.vehicleSelectedManuID = profile.vehicle_type_manufacturer_id
            
            if vehicleSelectedManuID != "" {
                let tempDic = (arrVehicleData.filter({$0.manufacturerName == txtCompanyName.text}).first)
                arrVehicleModel = tempDic!
                
            }
            if profile.car_left != "" {
                imagesTypes[0].parameter = profile.car_left
            }
            if profile.car_right != "" {
                imagesTypes[1].parameter = profile.car_right
            }
            
            if profile.car_front != "" {
                imagesTypes[2].parameter = profile.car_front
            }
            
            if profile.car_right != ""{
                imagesTypes[3].parameter = profile.car_back
            }
            
        } else if let profile = SessionManager.shared.userProfile {
            
            let vehicleInfo = profile.responseObject.vehicleInfo[0]
            txtCarType.text = vehicleInfo.vehicleTypeName
            txtCompanyName.text = vehicleInfo.vehicleTypeManufacturerName
            txtVehicleModel.text = vehicleInfo.vehicleTypeModelName
            txtVehicleManufactureYear.text = vehicleInfo.yearOfManufacture
            txtNoOfPassenger.text = vehicleInfo.noOfPassenger
            txtVehicleNumber.text = vehicleInfo.plateNumber
            txtVehicleColor.text = vehicleInfo.vehicleColor
            self.vehicleUpdatedType = vehicleInfo.vehicleType ?? ""
            self.vehicleSelectedSubModelID = vehicleInfo.vehicleTypeModelId ?? ""
            self.vehicleSelectedManuID = vehicleInfo.vehicleTypeManufacturerId ?? ""
            if let imageStr = vehicleInfo.carLeft{
                imagesTypes[0].parameter = imageStr
            }
            if let imageStr = vehicleInfo.carRight{
                imagesTypes[1].parameter = imageStr
            }
            if let imageStr = vehicleInfo.carFront{
                imagesTypes[2].parameter = imageStr
            }
            if let imageStr = vehicleInfo.carBack {
                imagesTypes[3].parameter = imageStr
            }
        }
        self.collimages.reloadData()
    }
    
    
     func validationWithCompletion(_ completion: @escaping ((Bool) -> ())){
        
        let validationParameter :[(String?,String, ValidatiionType)] =
            
                                    [(txtVehicleNumber.text,vehicleNumberErrorString, .isEmpty),
                                     (txtCompanyName.text,companyNameErrorString, .isEmpty),
                                   (txtVehicleModel.text,vehicleModelErrorString, .isEmpty),
                                   (txtVehicleManufactureYear.text,manufactureYearErrorString, .isEmpty),
                                   (txtNoOfPassenger.text,noOfPassengerErrorString, .numeric)]
 
        
//        (txtCarType.text,carTypeErrorString, .isEmpty),
        guard Validator.validate(validationParameter) else {
            completion(false)
            return
        }
    
        var status = true
        
        
        if imagesTypes.first?.image == #imageLiteral(resourceName: "car-1") {
            AlertMessage.showMessageForError(vehicleLeftImageErrorString)
            status = false
            completion(false)
            return
        } else if imagesTypes[1].image == #imageLiteral(resourceName: "car-2") {
            AlertMessage.showMessageForError(vehicleRightImageErrorString)
            status = false
            completion(false)
            return
        } else if imagesTypes[2].image == #imageLiteral(resourceName: "car-3") {
            AlertMessage.showMessageForError(vehicleFrontImageErrorString)
            status = false
            completion(false)
            return
        } else if imagesTypes[3].image == #imageLiteral(resourceName: "car-4") {
            AlertMessage.showMessageForError(vehicleBackImageErrorString)
            status = false
            completion(false)
            return
        }
        if !status { completion(status); return }
        
        if !isFromSetting {
            parameterArray.vehicle_type_model_name = txtVehicleModel.text!
            parameterArray.year_of_manufacture = txtVehicleManufactureYear.text!
            parameterArray.no_of_passenger = txtNoOfPassenger.text!
            parameterArray.other_company_name = txtCompanyName.text!
            parameterArray.plate_number = txtVehicleNumber.text!
            parameterArray.vehicle_color = txtVehicleColor.text ?? ""
            parameterArray.vehicle_type_manufacturer_name = txtCompanyName.text!
            parameterArray.vehicle_type = self.vehicleUpdatedType
            
            parameterArray.vehicle_type_model_id = self.vehicleSelectedSubModelID
            parameterArray.vehicle_type_manufacturer_id = self.vehicleSelectedManuID
            parameterArray.setNextRegistrationIndex(from: .vehicleInfo)
            SessionManager.shared.registrationParameter = parameterArray
        }

        completion(true)
    }
    
    func webserviceForVehicleMenufactureYearList() {
        Loader.showHUD(with: view)
        WebServiceCalls.vehicleTypeModelList(strType: ["" : ""]) { (response, status) in
           Loader.hideHUD()
            if status
            {
                print(response)
                let vehicleListRes = VehicleListModel.init(fromJson: response)//init(fromJson: response)
                Singleton.shared.menufacturingYearList = vehicleListRes.yearList

                print(vehicleListRes.yearList)
                self.arrYearMenufacList = Singleton.shared.menufacturingYearList
              
                self.arrVehicleData = vehicleListRes.data
                Singleton.shared.vehicleData = vehicleListRes.data
                print(self.arrVehicleData)
                
                self.arrCompanyName = vehicleListRes.data.map({$0.manufacturerName})
                print(self.arrCompanyName)
                
               

//                self.arrVehicleTypeName = vehicleListRes.data.map({$0.manufacturerName})
//                let strSelectName = self.arrVehicleTypeName[0]
//                _ = (self.arrVehicleData.filter({$0.manufacturerName == strSelectName}).first)
//
////                self.arrVehicleTypeSubName = (tempDic!).vehicleModel //.map({$0.vehicleTypeName as! String})
            }
            else
            {
                print(response)
            }

            self.webserviceForVehicleList()
        }

    }

    func openDatePicker()
        {
    
            arrYearMenufacList = Singleton.shared.menufacturingYearList
            txtVehicleManufactureYear.inputView = pickerViewManufYear
    
        }
    
    func webserviceForVehicleList()
    {
//        Loader.showHUD(with: Helper.currentWindow)
        let param: [String: Any] = ["": ""]
        WebServiceCalls.VehicleTypeListApi(strType: param) { (json, status) in
//            Loader.hideHUD()
            if status {
                print(json)
                let VehicleListDetails = VehicleListResultModel.init(fromJson: json)
                Singleton.shared.vehicleListData = VehicleListDetails
                self.setupTextField()
                if !self.isFromSetting {
                    self.navigateToVC()
                }
            } else {
                AlertMessage.showMessageForError(json["message"].stringValue)
            }
        }
    }
    
    
    func webserviceForCompanyList() {
        let param: [String: Any] = ["": ""]
        WebServiceCalls.companyList(strType: param) { (json, status) in
            if status {
                print(json)
                let CompanyListDetails = CompanyListModel.init(fromJson: json)
                Singleton.shared.companyListData = CompanyListDetails
            }
            else
            {
                AlertMessage.showMessageForError(json["message"].stringValue)
            }
        }
    }
    
    //MARK- ===== Btn Action Next ======
    @IBAction func btnActionNext(_ sender: UIButton) {
        
        validationWithCompletion { status in
            if status {
                if self.isFromSetting {
                    self.webserviceForVehicleInfo()
                }
                else {
                    let vehicleDetailVC = AppViewControllers.shared.vehicleDocs(isFromSettings: false)
                    self.push(vehicleDetailVC)
                }
                
            }
        }
    }

}
    
    
extension VehicleInfoVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txtNoOfPassenger
        {
            let maxLength = 1
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString

            if newString.length <= maxLength
            {
                let aSet = NSCharacterSet(charactersIn:"12345678").inverted
                let compSepByCharInSet = string.components(separatedBy: aSet)
                let numberFiltered = compSepByCharInSet.joined(separator: "")
                return string == numberFiltered
            }
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtVehicleNumber {
            parameterArray.plate_number = txtVehicleNumber.text ?? ""
        } else if textField == txtVehicleColor {
            parameterArray.vehicle_color = textField.text ?? ""
        }
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        switch textField {
        case txtVehicleManufactureYear:
            openDatePicker()
            return true
            
        case txtCarType:
            return false

        case txtVehicleModel:
            self.view.endEditing(true)
            
            if txtCompanyName.text == "" {
                AlertMessage.showMessageForError("Please select Vehicle Manufacture")
                return false
            } else if arrVehicleModel.vehicleModel.isEmpty {
                AlertMessage.showMessageForError("Vehicle models not available!")
                return false
            } else {
                txtVehicleModel.inputView = pickerViewVehicleModel
                return true
            }
           
        case txtNoOfPassenger :
            self.view.endEditing(true)
            txtNoOfPassenger.inputView = pickerViewPassenger
            return true

        case txtCompanyName:
            self.view.endEditing(true)
            txtCompanyName.inputView = pickerViewComapanyName
            return true
        default:
            return true
        }
    }
}

extension VehicleInfoVC{
    func uploadImages(image: UIImage, selected index: Int)
    {
        Loader.showHUD(with: Helper.currentWindow)

        WebService.shared.postDataWithImage(api: .docUpload, parameter: [:],  image: image, imageParamName: "image"){ json,status in
            Loader.hideHUD()
            if status{
                let urlString = json["url"].stringValue
                self.imagesTypes[index].parameter = urlString
                if self.isFromSetting == false {
                    switch index{
                    case 0:
                        self.parameterArray.car_left = urlString
                    case 1:
                        self.parameterArray.car_right = urlString
                    case 2:
                        self.parameterArray.car_front = urlString
                    case 3:
                        self.parameterArray.car_back = urlString
                    default:
                        break
                    }
                    SessionManager.shared.registrationParameter = self.parameterArray
                }
                self.collimages.reloadData()
            }
        }
    }
}


extension VehicleInfoVC  : UIPickerViewDelegate,UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
//            if pickerView == pickerViewVehicleName
//            {
//                return arrVehicleTypeName.count
//            }
//            else
           if pickerView == pickerViewVehicleModel
            {
                return vehicleSelectedManuID != "" ? arrVehicleModel.vehicleModel.count : 0
            }
            else if pickerView == pickerViewComapanyName
            {
                return arrCompanyName.count
            }
            else if pickerView == pickerViewPassenger {
                return arrayNoOfPassenger.count
            }
            else
            {
                return arrYearMenufacList.count
            }
        }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
       {
//            if pickerView == pickerViewVehicleName
//            {
//                if txtVehicleSubName.text == "" {
//                    txtVehicleSubName.text = arrVehicleTypeName[row]
//
//
//                }
//                return arrVehicleTypeName[row]
//            }
//             if pickerView == pickerViewVehicleSubName
//            {
//                if txtVehicleModel.text == "" {
//
//                    txtVehicleModel.text = arrVehicleTypeSubName.vehicleModel[row].vehicleTypeModelName
//                    parameterArray.vehicle_type_model_name = arrVehicleTypeSubName.vehicleModel[row].vehicleTypeModelName
//                    parameterArray.vehicle_type_model_id = arrVehicleTypeSubName.vehicleModel[row].id
//                    parameterArray.vehicle_type = arrVehicleTypeSubName.vehicleModel[row].vehicleTypeId
//                    txtCarType.text = arrVehicleTypeSubName.vehicleModel[row].vehicleTypeName
//                }
//                return arrVehicleTypeSubName.vehicleModel[row].vehicleTypeModelName
//            }
             if pickerView == pickerViewComapanyName
            {
                if txtCompanyName.text == "" {
                    
                    let strSelectCompanyName = arrCompanyName[row] // vehicleTypeName
                    txtCompanyName.text = "\(strSelectCompanyName)"
                    let tempDic = (arrVehicleData.filter({$0.manufacturerName == strSelectCompanyName}).first)
                    arrVehicleModel = tempDic!
                    parameterArray.vehicle_type_manufacturer_name = strSelectCompanyName
                    parameterArray.vehicle_type_manufacturer_id = vehicleSelectedManuID
                    vehicleSelectedManuID = arrVehicleModel.id
                }
                
                return arrCompanyName[row]
            }
             else if pickerView == pickerViewVehicleModel {
                if txtVehicleModel.text == "" {
                    
                        txtVehicleModel.text = arrVehicleModel.vehicleModel[row].vehicleTypeModelName
                        parameterArray.vehicle_type_model_name = arrVehicleModel.vehicleModel[row].vehicleTypeModelName
                        parameterArray.vehicle_type_model_id = arrVehicleModel.vehicleModel[row].id
                        parameterArray.vehicle_type = arrVehicleModel.vehicleModel[row].vehicleTypeId
                        txtCarType.text = arrVehicleModel.vehicleModel[row].vehicleTypeName
                         parameterArray.vehicleTypeString = arrVehicleModel.vehicleModel[row].vehicleTypeName
                        vehicleSelectedSubModelID = arrVehicleModel.vehicleModel[row].id
                        vehicleUpdatedType = arrVehicleModel.vehicleModel[row].vehicleTypeId
                        parameterArray.vehicle_type = vehicleUpdatedType
                    
                    }
                    return arrVehicleModel.vehicleModel[row].vehicleTypeModelName
                }
             
            else if pickerView == pickerViewPassenger {
                if txtNoOfPassenger.text == "" {
                    txtNoOfPassenger.text = "\(arrayNoOfPassenger[row])"
                    parameterArray.no_of_passenger = txtNoOfPassenger.text ?? ""
                }
                return "\(arrayNoOfPassenger[row])"
            }
            else
            {
                if txtVehicleManufactureYear.text == "" {
                    txtVehicleManufactureYear.text = arrYearMenufacList[row]
                    parameterArray.year_of_manufacture = txtNoOfPassenger.text ?? ""
                }
                return arrYearMenufacList[row]
            }
        }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

            if pickerView == pickerViewVehicleName
            {
                let strSelectName = arrVehicleData[row].manufacturerName ?? "" // vc.arrVehicleTypeName[row]
                txtCarType.text = ""
                
                let tempDic = (arrVehicleData.filter({$0.manufacturerName == strSelectName}).first)
                arrVehicleModel = tempDic!
            
                parameterArray.vehicleTypeString = strSelectName
                
                
                // .vehicleModel.map({$0.vehicleTypeName as! String})
            }
            if pickerView == pickerViewComapanyName
            {
                let strSelectCompanyName = arrCompanyName[row] // vehicleTypeName
                txtCompanyName.text = "\(strSelectCompanyName)"
                txtCarType.text = ""
                txtVehicleModel.text = ""
                let tempDic = (arrVehicleData.filter({$0.manufacturerName == strSelectCompanyName}).first)
                arrVehicleModel = tempDic!
                vehicleSelectedManuID = arrVehicleModel.id
                parameterArray.vehicle_type_manufacturer_name = strSelectCompanyName
                parameterArray.vehicle_type_manufacturer_id = vehicleSelectedManuID

            }
             else if pickerView == pickerViewVehicleModel {
                
                let strSelectSubName = arrVehicleModel.vehicleModel[row].vehicleTypeModelName ?? ""
                 txtVehicleModel.text = "\(strSelectSubName)"
                parameterArray.vehicle_type_model_name = strSelectSubName
                parameterArray.vehicle_type_model_id = arrVehicleModel.vehicleModel[row].id ?? ""
                parameterArray.vehicleTypeString = arrVehicleModel.vehicleModel[row].vehicleTypeName ?? ""
                txtCarType.text = arrVehicleModel.vehicleModel[row].vehicleTypeName ?? ""
                vehicleSelectedSubModelID = arrVehicleModel.vehicleModel[row].id
                vehicleUpdatedType = arrVehicleModel.vehicleModel[row].vehicleTypeId
                parameterArray.vehicleTypeString = arrVehicleModel.vehicleModel[row].vehicleTypeName
                parameterArray.vehicle_type = vehicleUpdatedType

                
             }
            else if pickerView == pickerViewPassenger {
               
                txtNoOfPassenger.text = "\(arrayNoOfPassenger[row])"
                parameterArray.no_of_passenger = "\(arrayNoOfPassenger[row])"
                
            }
            else
            {
                let strSelectYear =  arrYearMenufacList[row]
                txtVehicleManufactureYear.text = "\(strSelectYear)"
                parameterArray.year_of_manufacture = strSelectYear
                
            }
        }

    
    // ----------------------------------------------------
    // MARK: - Webservice Methods
    // ----------------------------------------------------
    
    func webserviceForVehicleInfo() {
        
        let updateVehicleInfoData : UpdateVehicleInfo = UpdateVehicleInfo()
    
        let loginData = SessionManager.shared.userProfile
        let parameter = loginData?.responseObject.driverDocs
        updateVehicleInfoData.driver_id = parameter?.driver_id ?? ""
        updateVehicleInfoData.vehicle_color = txtVehicleColor.unwrappedText
        updateVehicleInfoData.no_of_passenger = txtNoOfPassenger.text!
        updateVehicleInfoData.plate_number = txtVehicleNumber.text!
        updateVehicleInfoData.vehicle_type_model_name = txtVehicleModel.text!
        updateVehicleInfoData.vehicle_type_manufacturer_name = txtCompanyName.text!
        updateVehicleInfoData.vehicle_type = vehicleUpdatedType
        updateVehicleInfoData.year_of_manufacture = txtVehicleManufactureYear.text!
        
        updateVehicleInfoData.vehicle_type_model_id = self.vehicleSelectedSubModelID
        updateVehicleInfoData.vehicle_type_manufacturer_id = self.vehicleSelectedManuID
        
        updateVehicleInfoData.car_left = imagesTypes[0].parameter
        updateVehicleInfoData.car_right = imagesTypes[1].parameter
        updateVehicleInfoData.car_front = imagesTypes[2].parameter
        updateVehicleInfoData.car_back = imagesTypes[3].parameter

        Loader.showHUD(with: self.view)


        WebServiceCalls.updateVehicleInfo(transferMoneyModel: updateVehicleInfoData, imageParamName: imagesTypes.map{$0.parameter}) { (response, status) in
            Loader.hideHUD()

            if status {
                
                let loginModelDetails = LoginModel.init(fromJson: response)
                SessionManager.shared.userProfile = loginModelDetails
                AlertMessage.showMessageForSuccess(loginModelDetails.message)
                NotificationCenter.postCustom(.updateOnlineStatus(false))
                self.navigationController?.popViewController(animated: true)
            } else {
                AlertMessage.showMessageForError(response["message"].arrayValue.first?.stringValue ?? response["message"].stringValue)
            }
        }
    }
    
    
    
    }



extension VehicleInfoVC : UICollectionViewDataSource , UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesTypes.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collimages.dequeueReusableCell(withReuseIdentifier: "ImgCollectionViewCell", for: indexPath) as! ImgCollectionViewCell
    
        if imagesTypes[indexPath.row].parameter != ""{
            print("\(NetworkEnvironment.baseImageURL + imagesTypes[indexPath.row].parameter)")
            cell.imgCar.layoutIfNeeded()
            let url = NetworkEnvironment.baseImageURL + imagesTypes[indexPath.row].parameter
            imagesTypes[indexPath.row].image = UIImage()
            UtilityClass.imageGet(url: url, img: cell.imgCar)
            
        }
        else {
            cell.imgCar.image = imagesTypes[indexPath.row].image
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.frame.width - 20) / 2
        return CGSize(width: width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ImagePickerViewController.open(from: self, allowEditing: false) { [unowned self] image in
            self.imagesTypes[indexPath.item].image = image
            self.uploadImages(image: image, selected: indexPath.item)
            self.collimages.reloadData()
        }
     }
   }
    

