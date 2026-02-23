//
//  AffiliatedProductsDataModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 23/02/26.
//

import Foundation

// MARK: - GenerateProductLink
struct GenerateProductLink: Codable {
    let affiliateID, productID: Int?
    let link: String?
    let updatedAt, createdAt: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case affiliateID = "affiliate_id"
        case productID = "product_id"
        case link
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}

// MARK: - AffiliatedProductsDataModel
struct AffiliatedProductsDataModel: Codable {
    let currentPage: Int?
    let data: [AffiliatedProductsList]?
    let firstPageURL: String?
    let from, lastPage: Int?
    let lastPageURL: String?
    let links: [Link]?
    let nextPageURL: String?
    let path: String?
    let perPage: Int?
    let prevPageURL: String?
    let to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case links
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
    }
}

// MARK: - AffiliatedProductsList
struct AffiliatedProductsList: Codable {
    let id: Int?
    let sellerID, storeID, categoryID, subcategoryID: String?
    let brandID: String?
    let otherEn, otherAr: String?
    let productNameEn, productNameAr, descriptionEn, descriptionAr: String?
    let minCardQuantity, maxCardQuantity, productReturn, returnDays: String?
    let productExchangable, exchangableDays, reviewRating, affiliatedProduct: String?
    let affiliatedCommission: String?
    let customizedProduct, readyToShip, cashOnDelivery: String?
    let uploadSizeChart: String?
    let productActiveStatus: Int?
    let createdAt, updatedAt: String?
    let brand: Brand?
    let category: Category?
    let subcategory: Brand?
    let productSpecifications: [ProductSpecification]?
    let productVariants: [ProductVariant]?
    let sellerDetails: SellerDetails?
    let store: Store?
//    let review: [JSONAny]?
    let averageRating: AverageRating?

    enum CodingKeys: String, CodingKey {
        case id
        case sellerID = "seller_id"
        case storeID = "store_id"
        case categoryID = "category_id"
        case subcategoryID = "subcategory_id"
        case brandID = "brand_id"
        case otherEn = "other_en"
        case otherAr = "other_ar"
        case productNameEn = "product_name_en"
        case productNameAr = "product_name_ar"
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case minCardQuantity = "min_card_quantity"
        case maxCardQuantity = "max_card_quantity"
        case productReturn = "product_return"
        case returnDays = "return_days"
        case productExchangable = "product_exchangable"
        case exchangableDays = "exchangable_days"
        case reviewRating = "review_rating"
        case affiliatedProduct = "affiliated_product"
        case affiliatedCommission = "affiliated_commission"
        case customizedProduct = "customized_product"
        case readyToShip = "ready_to_ship"
        case cashOnDelivery = "cash_on_delivery"
        case uploadSizeChart = "upload_size_chart"
        case productActiveStatus = "product_active_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case brand, category, subcategory
        case productSpecifications = "product_specifications"
        case productVariants = "product_variants"
        case sellerDetails = "seller_details"
        case store//, review
        case averageRating = "average_rating"
    }
}

// MARK: - AverageRating
struct AverageRating: Codable {
    let product, store: Int?
}
