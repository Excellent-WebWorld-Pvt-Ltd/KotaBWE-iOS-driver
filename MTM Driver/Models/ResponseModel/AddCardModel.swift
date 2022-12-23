//
//  AddCardModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 18, 2019

import Foundation
import SwiftyJSON


class AddCardModel : Codable
{

    var cards : [CardsList]!
    var message : String!
    var status : Bool!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        cards = [CardsList]()
        let cardsArray = json["cards"].arrayValue
        for cardsJson in cardsArray{
            let value = CardsList(fromJson: cardsJson)
            cards.append(value)
        }
        message = json["message"].stringValue
        status = json["status"].boolValue
	}
    init() {
        
    }
	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if cards != nil{
        var dictionaryElements = [[String:Any]]()
        for cardsElement in cards {
        	dictionaryElements.append(cardsElement.toDictionary())
        }
        dictionary["cards"] = dictionaryElements
        }
        if message != nil{
        	dictionary["message"] = message
        }
        if status != nil{
        	dictionary["status"] = status
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		cards = aDecoder.decodeObject(forKey: "cards") as? [CardsList]
		message = aDecoder.decodeObject(forKey: "message") as? String
		status = aDecoder.decodeObject(forKey: "status") as? Bool
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if cards != nil{
			aCoder.encode(cards, forKey: "cards")
		}
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
class CardsList : Codable
{
    
    var cardHolderName : String!
    var cardNo : String!
    var cardType : String!
    var expDateMonth : String!
    var expDateYear : String!
    var formatedCardNo : String!
    var id : String!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        cardHolderName = json["card_holder_name"].stringValue
        cardNo = json["card_no"].stringValue
        cardType = json["card_type"].stringValue
        expDateMonth = json["exp_date_month"].stringValue
        expDateYear = json["exp_date_year"].stringValue
        formatedCardNo = json["formated_card_no"].stringValue
        id = json["id"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if cardHolderName != nil{
            dictionary["card_holder_name"] = cardHolderName
        }
        if cardNo != nil{
            dictionary["card_no"] = cardNo
        }
        if cardType != nil{
            dictionary["card_type"] = cardType
        }
        if expDateMonth != nil{
            dictionary["exp_date_month"] = expDateMonth
        }
        if expDateYear != nil{
            dictionary["exp_date_year"] = expDateYear
        }
        if formatedCardNo != nil{
            dictionary["formated_card_no"] = formatedCardNo
        }
        if id != nil{
            dictionary["id"] = id
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        cardHolderName = aDecoder.decodeObject(forKey: "card_holder_name") as? String
        cardNo = aDecoder.decodeObject(forKey: "card_no") as? String
        cardType = aDecoder.decodeObject(forKey: "card_type") as? String
        expDateMonth = aDecoder.decodeObject(forKey: "exp_date_month") as? String
        expDateYear = aDecoder.decodeObject(forKey: "exp_date_year") as? String
        formatedCardNo = aDecoder.decodeObject(forKey: "formated_card_no") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if cardHolderName != nil{
            aCoder.encode(cardHolderName, forKey: "card_holder_name")
        }
        if cardNo != nil{
            aCoder.encode(cardNo, forKey: "card_no")
        }
        if cardType != nil{
            aCoder.encode(cardType, forKey: "card_type")
        }
        if expDateMonth != nil{
            aCoder.encode(expDateMonth, forKey: "exp_date_month")
        }
        if expDateYear != nil{
            aCoder.encode(expDateYear, forKey: "exp_date_year")
        }
        if formatedCardNo != nil{
            aCoder.encode(formatedCardNo, forKey: "formated_card_no")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        
    }
    
}
