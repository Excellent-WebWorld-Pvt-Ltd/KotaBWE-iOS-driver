//
//  TruckTypeResponceModel.swift
//  MTM Driver
//
//  Created by Dhananjay  on 20/01/23.
//  Copyright © 2023 baps. All rights reserved.
//

import Foundation
struct TruckTypeList: Codable {

    var status: Bool?
    var message: String?
    var data: [TruckType]?

    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([TruckType].self, forKey: .data)
    }

}

struct TruckType: Codable {

    var id: String?
    var name: String?
    var baseKm: String?
    var minimumFare: String?
    var baseCharge: String?
    var perKmCharge: String?
    var perMinuteCharge: String?
    var waitingTimePerMinCharge: String?
    var bookingFee: String?
    var driverCancellationFee: String?
    var customerCancellationFee: String?
    var freeCancallationTime: String?
    var extraCharge: String?
    var capacity: String?
    var commission: String?
    var image: String?
    var unselectImage: String?
    var sort: String?
    var description: String?
    var trash: String?
    var createdAt: String?
    var updatedAt: String?
    var base: String?
    var charge: String?
    var bulkMileRate: String?
    var status: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case baseKm = "base_km"
        case minimumFare = "minimum_fare"
        case baseCharge = "base_charge"
        case perKmCharge = "per_km_charge"
        case perMinuteCharge = "per_minute_charge"
        case waitingTimePerMinCharge = "waiting_time_per_min_charge"
        case bookingFee = "booking_fee"
        case driverCancellationFee = "driver_cancellation_fee"
        case customerCancellationFee = "customer_cancellation_fee"
        case freeCancallationTime = "free_cancallation_time"
        case extraCharge = "extra_charge"
        case capacity = "capacity"
        case commission = "commission"
        case image = "image"
        case unselectImage = "unselect_image"
        case sort = "sort"
        case description = "description"
        case trash = "trash"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case base = "base"
        case charge = "charge"
        case bulkMileRate = "bulk_mile_rate"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        baseKm = try values.decodeIfPresent(String.self, forKey: .baseKm)
        minimumFare = try values.decodeIfPresent(String.self, forKey: .minimumFare)
        baseCharge = try values.decodeIfPresent(String.self, forKey: .baseCharge)
        perKmCharge = try values.decodeIfPresent(String.self, forKey: .perKmCharge)
        perMinuteCharge = try values.decodeIfPresent(String.self, forKey: .perMinuteCharge)
        waitingTimePerMinCharge = try values.decodeIfPresent(String.self, forKey: .waitingTimePerMinCharge)
        bookingFee = try values.decodeIfPresent(String.self, forKey: .bookingFee)
        driverCancellationFee = try values.decodeIfPresent(String.self, forKey: .driverCancellationFee)
        customerCancellationFee = try values.decodeIfPresent(String.self, forKey: .customerCancellationFee)
        freeCancallationTime = try values.decodeIfPresent(String.self, forKey: .freeCancallationTime)
        extraCharge = try values.decodeIfPresent(String.self, forKey: .extraCharge)
        capacity = try values.decodeIfPresent(String.self, forKey: .capacity)
        commission = try values.decodeIfPresent(String.self, forKey: .commission)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        unselectImage = try values.decodeIfPresent(String.self, forKey: .unselectImage)
        sort = try values.decodeIfPresent(String.self, forKey: .sort)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        trash = try values.decodeIfPresent(String.self, forKey: .trash)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        base = try values.decodeIfPresent(String.self, forKey: .base)
        charge = try values.decodeIfPresent(String.self, forKey: .charge)
        bulkMileRate = try values.decodeIfPresent(String.self, forKey: .bulkMileRate)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }

}
