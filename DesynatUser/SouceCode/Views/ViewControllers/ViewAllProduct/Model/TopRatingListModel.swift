//
//  TopRatingListModel.swift
//  DesynatUser
//
//  Created by Chandra Prakash on 27/07/26.
//

import Foundation

// MARK: - TopRatingListModel
struct TopRatingListModel: Codable {
    var allProduct: AllProductData?

    enum CodingKeys: String, CodingKey {
        case allProduct = "All_Product"
    }
}

// MARK: - AllProductData
struct AllProductData: Codable {
    var currentPage: Int?
    var data: [TopRatedDataModel]?
    var firstPageURL: String?
    var from: Int?
    var lastPage: Int?
    var lastPageURL: String?
    var links: [Link]?
    var nextPageURL: String?
    var path: String?
    var perPage: Int?
    var prevPageURL: String?
    var to: Int?
    var total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data = "data"
        case firstPageURL = "first_page_url"
        case from = "from"
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case links = "links"
        case nextPageURL = "next_page_url"
        case path = "path"
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to = "to"
        case total = "total"
    }
}

// MARK: - BestSellingListModel
struct BestSellingListModel: Codable {
    var allProduct: AllProductSelling?

    enum CodingKeys: String, CodingKey {
        case allProduct = "All_Product"
    }
}

// MARK: - AllProductSelling
struct AllProductSelling: Codable {
    var currentPage: Int?
    var data: [BestSellingProductsDataModel]?
    var firstPageURL: String?
    var from: Int?
    var lastPage: Int?
    var lastPageURL: String?
    var links: [Link]?
    var nextPageURL: String?
    var path: String?
    var perPage: Int?
    var prevPageURL: String?
    var to: Int?
    var total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data = "data"
        case firstPageURL = "first_page_url"
        case from = "from"
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case links = "links"
        case nextPageURL = "next_page_url"
        case path = "path"
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to = "to"
        case total = "total"
    }
}

