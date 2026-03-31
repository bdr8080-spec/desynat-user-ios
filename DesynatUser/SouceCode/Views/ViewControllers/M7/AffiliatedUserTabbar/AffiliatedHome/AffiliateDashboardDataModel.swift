//
//  AffiliateDashboardDataModel.swift
//  DesynatUser
//
//  Created by Chandra Prakash on 31/03/26.
//

import Foundation
// MARK: - AffiliateDashboardDataModel
struct AffiliateDashboardDataModel: Codable {
    var totalProducts, totalOrders: Int?
    var totalRevenue, totalEarning: String?
    var totalOngoing, totalCompleted, totalCancelled, totalReturned: Int?

    enum CodingKeys: String, CodingKey {
        case totalProducts = "total_products"
        case totalOrders = "total_orders"
        case totalRevenue = "total_revenue"
        case totalEarning = "total_earning"
        case totalOngoing = "total_ongoing"
        case totalCompleted = "total_completed"
        case totalCancelled = "total_cancelled"
        case totalReturned = "total_returned"
    }
    
    init(totalProducts: Int? = nil, totalOrders: Int? = nil, totalRevenue: String? = nil, totalEarning: String? = nil, totalOngoing: Int? = nil, totalCompleted: Int? = nil, totalCancelled: Int? = nil, totalReturned: Int? = nil) {
        self.totalProducts = totalProducts
        self.totalOrders = totalOrders
        self.totalRevenue = totalRevenue
        self.totalEarning = totalEarning
        self.totalOngoing = totalOngoing
        self.totalCompleted = totalCompleted
        self.totalCancelled = totalCancelled
        self.totalReturned = totalReturned
    }
}
