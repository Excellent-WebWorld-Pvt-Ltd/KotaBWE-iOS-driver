//
//  UpdateVehicleInfoViewController.swift
//  Pappea Driver
//
//  Created by Apple on 10/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SSSpinnerButton
import SkyFloatingLabelTextField
import ActionSheetPicker_3_0

class UpdateVehicleInfoViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    
    //MARK:- ====== Outlets =========
    @IBOutlet weak var txtVehicleSubModel: SkyFloatingLabelTextField!
    @IBOutlet weak var btnSave: SSSpinnerButton!
    @IBOutlet weak var vehicleView: UIView!
//    let myCustomView: VehicleInfoView = .fromNib()
    var pickerViewManufYear = UIPickerView()
    var pickerViewVehicleName = UIPickerView()
    var pickerViewVehicleSubName = UIPickerView()
    @IBOutlet weak var txtVehiclePlateNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var txtVehicleModel: SkyFloatingLabelTextField!
    @IBOutlet weak var txtVehicleYearMenufacture: SkyFloatingLabelTextField!
    @IBOutlet weak var txtVehicleType: SkyFloatingLabelTextField!
    @IBOutlet weak var txtNoofPassenger: SkyFloatingLabelTextField!
    
    @IBOutlet weak var viewCarList: UIView!
    @IBOutlet var collectionView: ColumnView!
    
    @IBOutlet var textFields: [SkyFloatingLabelTextField]!
    var arrYearMenufacList = [String]()
    var arrVehicleTypeName = [String]()
    var arrVehicleTypeSubName = [String]()
    var vehicleUpdatedType = String()
    var vehicleSelectedManuID = String()
    var vehicleSelectedVehicleModelID = String()
    var vehicleSelectedSubModelID = String()
    var arrVehicleData = [VehicleData]()
    var parameterArray = RegistrationParameter.shared

    var imagesTypes : [(parameter: String,image: UIImage)] = [("car_left",#imageLiteral(resourceName: "car-1")),
                                                              ("car_right",#imageLiteral(resourceName: "car-2")),
                                                              ("car_front",#imageLiteral(resourceName: "car-3")),
                                                              ("car_back",#imageLiteral(resourceName: "car-4"))]
    
    var model:UpdateVehicleInfo = UpdateVehicleInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.isUserInteractionEnabled = false
        btnSave.isHidden = true

        setupColumnView()
        pickerViewManufYear = UIPickerView()
        
        pickerViewManufYear.dataSource = self
        pickerViewManufYear.delegate = self
        
        pickerViewVehicleName.dataSource = self
        pickerViewVehicleName.delegate = self
        
        pickerViewVehicleSubName.dataSource = self
        pickerViewVehicleSubName.delegate = self
        
        pickerViewManufYear.backgroundColor = UIColor.white
        pickerViewVehicleSubName.backgroundColor = UIColor.white
        
//        vehicleView.addSubview(myCustomView)
//        myCustomView.setupTextField()
        btnSave.submitButtonLayout(isDark : true)
         webserviceForVehicleMenufactureYearList()
        self.title = "Vehicle Option"
//        txtVehicleType.delegate = self
        
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        setupNavigationBarColor(navigationController)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (navigationController?.viewControllers.last is ProfileOptionsViewController) {
            let clubVC = navigationController?.viewControllers.last as? ProfileOptionsViewController
            clubVC?.isFromCheckinScreen = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if isMovingFromParent {
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.isTranslucent = true
        }
    }
   
    func setupColumnView() {
        
        collectionView.imageDataSource = true
        collectionView.imageArray = imagesTypes.map { $0.image }
        collectionView.imageCornerRadius = 5
        viewCarList.backgroundColor = .clear
        collectionView.spacing = 5
        collectionView.collectionViewScrollDirection = .vertical
        collectionView.imageContentMode = .center
        collectionView.imageBorderColor = .lightGray
        collectionView.imageBorderWidth = 1
        collectionView.noOfColumn = 2
        
        collectionView.imageBackgroundColor = .groupTableViewBackground
        collectionView.itemSize = CGSize(width: viewCarList.frame.width / CGFloat(2.2), height: collectionView.frame.height / CGFloat(2.2))
        
        collectionView.didSelectItemAt = {
            indexPath in
            self.didSelect(indexPath: indexPath)
        }
    }
    
    func didSelect(indexPath: IndexPath) {
//        if let vc = self.parentContainerViewController() as? RegistrationViewController {
            let imageVC : ImagePickerViewController = UIViewController.viewControllerInstance(storyBoard: .picker)
            imageVC.onDismiss = {
                self.imagesTypes[indexPath.item].image = imageVC.pickedImage
                self.uploadImages(image:imageVC.pickedImage, selected: indexPath.item)
//
                self.collectionView.imageContentMode = .scaleAspectFit
                
                self.collectionView.imageArray = self.imagesTypes.map { $0.image }
                self.collectionView.reloadData()
                imageVC.dismiss(animated: true)
            }
            self.present(imageVC, animated: true, completion: nil)
//            vc.present(imageVC, animated: true)
//        }
    }
    
    func getData() {
        
        do {
            let loginData = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile") // .set(object: loginModelDetails, forKey: "userProfile")
            let parameter = loginData?.responseObject.driverDocs
            let vehicleInfoData = loginData?.responseObject.vehicleInfo
            
            model.driver_id = parameter?.driverId ?? ""
            txtVehiclePlateNumber.text = vehicleInfoData?.first?.plateNumber
            txtVehicleModel.text = vehicleInfoData?.first?.vehicleTypeManufacturerName
            txtVehicleSubModel.text = vehicleInfoData?.first?.vehicleTypeModelName
            txtVehicleYearMenufacture.text = vehicleInfoData?.first?.yearOfManufacture
            vehicleSelectedVehicleModelID = vehicleInfoData?.first?.vehicleType ?? ""
            var arrSelectedName = [String]()
            for (item) in (vehicleInfoData?.first?.vehicleType.enumerated())!
            {
                print(item)
                let selectedID = ((Singleton.shared.vehicleListData?.data.filter({$0.id == "\(item.element)"}).first)?.name) ?? ""
                arrSelectedName.append(selectedID)
            }
            //            self.parameterArray.vehicle_type =
            self.vehicleUpdatedType = vehicleInfoData?.first?.vehicleTypeName ?? ""//arrSelectedName.first!
            txtVehicleType.text = self.vehicleUpdatedType
            txtNoofPassenger.text = vehicleInfoData?.first?.noOfPassenger


            self.vehicleSelectedManuID = vehicleInfoData?.first?.vehicleTypeManufacturerId ?? ""
            self.vehicleSelectedSubModelID = vehicleInfoData?.first?.id ?? ""

            let baseImage = NetworkEnvironment.imageBaseURL
            

            let left = baseImage + "\(vehicleInfoData?.first?.carLeft ?? "")"
            let right = baseImage + "\(vehicleInfoData?.first?.carRight ?? "")"
            let front = baseImage + "\(vehicleInfoData?.first?.carFront ?? "")"
            let back = baseImage + "\(vehicleInfoData?.first?.carBack ?? "")"

            parameterArray.car_left = left
            parameterArray.car_right = right
            parameterArray.car_front = front
            parameterArray.car_back = back
            
            DispatchQueue.global(qos: .background).async {
                
                guard let urlLeft = URL(string: left) else { return }
                let dataLeft = try? Data(contentsOf: urlLeft)
                
                guard let urlRight = URL(string: right) else { return }
                let dataRight = try? Data(contentsOf: urlRight)
                
                guard let urlFront = URL(string: front) else { return }
                let dataFront = try? Data(contentsOf: urlFront)
                
                guard let urlBack = URL(string: back) else { return }
                let dataBack = try? Data(contentsOf: urlBack)
                
                DispatchQueue.main.async {
                    if let imageData = dataLeft {
                        let image = UIImage(data: imageData)
                        
                        self.imagesTypes[0].image = image ?? #imageLiteral(resourceName: "car-1")
                        self.collectionView.imageContentMode = .scaleAspectFit
                        self.collectionView.imageArray = self.imagesTypes.map { $0.image }
                        self.collectionView.reloadData()
                    }
                }
                DispatchQueue.main.async {
                    if let imageData = dataRight {
                        let image = UIImage(data: imageData)
                        
                        self.imagesTypes[1].image = image ?? #imageLiteral(resourceName: "car-2")
                        self.collectionView.imageContentMode = .scaleAspectFit
                        self.collectionView.imageArray = self.imagesTypes.map { $0.image }
                        self.collectionView.reloadData()
                    }
                }
                
                DispatchQueue.main.async {
                    if let imageData = dataFront {
                        let image = UIImage(data: imageData)
                        
                        self.imagesTypes[2].image = image ?? #imageLiteral(resourceName: "car-3")
                        self.collectionView.imageContentMode = .scaleAspectFit
                        self.collectionView.imageArray = self.imagesTypes.map { $0.image }
                        self.collectionView.reloadData()
                    }
                }
                
                DispatchQueue.main.async {
                    if let imageData = dataBack {
                        let image = UIImage(data: imageData)
                        
                        self.imagesTypes[3].image = image ?? #imageLiteral(resourceName: "car-4")
                        self.collectionView.imageContentMode = .scaleAspectFit
                        self.collectionView.imageArray = self.imagesTypes.map { $0.image }
                        self.collectionView.reloadData()
                    }
                }
                
            }

            
        }
        catch {
            print(error.localizedDescription)
        }
        
        
    }
 
    @IBAction func brnSaveClicked(_ sender: Any) {
        
        if !validation().0 {
            AlertMessage.showMessageForError(validation().1)
        } else {
            print("Done")
            webserviceForVehicleInfo()
        }
    }
    
    //MARK:- ====== Validation ----
    func validation() -> (Bool, String) {
        
        for textField in textFields {
            if textField.text!.isBlank {
                return (false, "Please enter \(textField.placeholder?.lowercased() ?? "")")
            }
        }
        
        if self.imagesTypes.first?.image == UIImage(named: "car_left") {
            return (false, "Please upload left side of car image")
        } else if self.imagesTypes.first?.image == UIImage(named: "car_right") {
            return (false, "Please upload right side of car image")
        } else if self.imagesTypes.first?.image == UIImage(named: "car_front") {
            return (false, "Please upload front side of car image")
        } else if self.imagesTypes.first?.image == UIImage(named: "car_back") {
            return (false, "Please upload back side of car image")
        }
       
        return (true, "")
    }
    func openDatePicker(){
        
        arrYearMenufacList = Singleton.shared.menufacturingYearList
        
        txtVehicleYearMenufacture.inputView = pickerViewManufYear
        pickerViewManufYear.backgroundColor = UIColor.white

    }
    func openVehiclePicker(){
    }

    // ----------------------------------------------------
    // MARK: - Webservice Methods
    // ----------------------------------------------------
    
    func webserviceForVehicleInfo() {
        
        let updateVehicleInfoData : UpdateVehicleInfo = UpdateVehicleInfo()
    
        do {
            let loginData = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile")
            let parameter = loginData?.responseObject.driverDocs
            updateVehicleInfoData.driver_id = parameter?.driverId ?? ""
        } catch {
            print(error.localizedDescription)
            return
        }
        
        updateVehicleInfoData.no_of_passenger = txtNoofPassenger.text!
        updateVehicleInfoData.plate_number = txtVehiclePlateNumber.text!
        updateVehicleInfoData.vehicle_type_model_name = txtVehicleSubModel.text! //+ " " + txtVehicleSubModel.text!
        updateVehicleInfoData.vehicle_type_manufacturer_name = txtVehicleModel.text! //+ " " + txtVehicleSubModel.text!
        updateVehicleInfoData.vehicle_type = vehicleSelectedVehicleModelID//self.vehicleUpdatedType
        updateVehicleInfoData.year_of_manufacture = txtVehicleYearMenufacture.text!
        
        updateVehicleInfoData.vehicle_type_model_id = self.vehicleSelectedSubModelID
        updateVehicleInfoData.vehicle_type_manufacturer_id = self.vehicleSelectedManuID
        
        updateVehicleInfoData.car_left = parameterArray.car_left
        updateVehicleInfoData.car_right = parameterArray.car_right
        updateVehicleInfoData.car_front = parameterArray.car_front
        updateVehicleInfoData.car_back = parameterArray.car_back

        Loader.showHUD(with: self.view)


        UserWebserviceSubclass.updateVehicleInfo(transferMoneyModel: updateVehicleInfoData, imageParamName: imagesTypes.map{$0.parameter}) { (response, status) in
            Loader.hideHUD()

            if status {
                
                let loginModelDetails = LoginModel.init(fromJson: response)
                do {
                    try UserDefaults.standard.set(object: loginModelDetails, forKey: "userProfile")
                    UserDefaults.standard.synchronize()
                } catch {
                    AlertMessage.showMessageForError(error.localizedDescription)
                }
            } else {
                AlertMessage.showMessageForError(response["message"].arrayValue.first?.stringValue ?? response["message"].stringValue)
            }
        }
    }
    
    func webserviceForVehicleMenufactureYearList()
    {
//        Loader.showHUD(with: Helper.currentWindow)
        UserWebserviceSubclass.vehicleTypeModelList(strType: ["" : ""]) { (response, status) in
//            Loader.hideHUD()
            if status
            {
                print(response)
                
                let vehicleListRes = VehicleListModel.init(fromJson: response)
                Singleton.shared.menufacturingYearList = vehicleListRes.yearList
                
                print(vehicleListRes.yearList)
                
//                arrYearMenufacList = vehicleListRes.yearList
                self.arrVehicleData = vehicleListRes.data
                
                print(self.arrVehicleData)
                
                self.arrVehicleTypeName = vehicleListRes.data.map({$0.manufacturerName})
                let strSelectName = self.arrVehicleTypeName[0]
                let tempDic = (self.arrVehicleData.filter({$0.manufacturerName == strSelectName}).first)
                self.arrVehicleTypeSubName = (tempDic!).vehicleModel.map({$0.vehicleTypeModelName})
            }
            else
            {
                print(response)
            }
        }
        
    }
    //-------------------------------------------------------------
    // MARK: - PicketView Methods
    //-------------------------------------------------------------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView == pickerViewVehicleName
        {
            return arrVehicleTypeName.count
        }
            else if pickerView == pickerViewVehicleSubName
        {
                return arrVehicleTypeSubName.count
        }
        else
        {
        return arrYearMenufacList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView == pickerViewVehicleName
        {
            return arrVehicleTypeName[row]
        }
            else if pickerView == pickerViewVehicleSubName
        {
            return arrVehicleTypeSubName[row]
        }
        else
        {
            return arrYearMenufacList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if pickerView == pickerViewVehicleName
        {
            let strSelectName = arrVehicleTypeName[row]
            let tempDic = (arrVehicleData.filter({$0.manufacturerName == strSelectName}).first)
            txtVehicleModel.text = "\(strSelectName)"

            txtVehicleSubModel.text = ""
            txtVehicleType.text = ""
            arrVehicleTypeSubName = (tempDic!).vehicleModel.map({$0.vehicleTypeModelName})
            //arrVehicleTypeSubName
        }
            else if pickerView == pickerViewVehicleSubName
        {
            let strSelectSubName = arrVehicleTypeSubName[row]
            txtVehicleSubModel.text = "\(strSelectSubName)"
            let temp = (arrVehicleData.filter({$0.manufacturerName == txtVehicleModel.text!}).first)?.vehicleModel
                    
            let newData = temp?.filter({$0.vehicleTypeModelName == strSelectSubName})
            
            self.vehicleSelectedManuID = newData?.first?.vehicleTypeManufacturerId ?? ""
            self.vehicleSelectedSubModelID = newData?.first?.id ?? ""
            self.txtVehicleType.text = newData?.first?.vehicleTypeName
            self.vehicleUpdatedType =  newData?.first!.vehicleTypeId ?? ""
            
            
        }
        else
        {
            let strSelectYear = arrYearMenufacList[row]
            txtVehicleYearMenufacture.text = "\(strSelectYear)"
        }
        
    }
    
}

extension UpdateVehicleInfoViewController: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        switch textField
        {
        case txtVehicleYearMenufacture:
            openDatePicker()
            return true

        case txtVehicleType:
            openVehiclePicker()
            return false
        case txtVehicleSubModel:
            
            if txtVehicleModel.text == ""
            {
                AlertMessage.showMessageForError("Please select vehicle model")
                return false
            }
            else
            {
            txtVehicleSubModel.inputView = pickerViewVehicleSubName
            return true
            }
            
        case txtVehicleModel:
            
            txtVehicleModel.inputView = pickerViewVehicleName
            pickerViewVehicleName.backgroundColor = UIColor.white
            return true
        default:
            return true
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txtNoofPassenger
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
}


extension UpdateVehicleInfoViewController{
    func uploadImages(image: UIImage, selected index: Int)
    {
        Loader.showHUD(with: self.view)

        WebService.shared.postDataWithImage(api: .docUpload, parameter: [:],  image: image, imageParamName: "image"){ json,status in
            Loader.hideHUD()
            if status{
                let urlString = json["url"].stringValue
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
            }
        }
    }
}
