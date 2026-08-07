//
//  FavouirtesDataModel.swift
//  DesynatUser
//
//  Created by fluper on 27/11/25.
//

import Foundation

// MARK: - FavoruitesDataModel
struct FavoruitesDataModel: Codable {
    let id: Int?
    let sellerID, storeID, categoryID, subcategoryID: String?
    let brandID: String?
    let otherEn, otherAr: String?
    let productNameEn, productNameAr, descriptionEn, descriptionAr: String?
    let minCardQuantity, maxCardQuantity, productReturn, returnDays: String?
    let productExchangable: String?
    let exchangableDays: String?
    let reviewRating, affiliatedProduct, customizedProduct, readyToShip: String?
    let cashOnDelivery: String?
    let uploadSizeChart: String?
    let productActiveStatus: Int?
    let productAvgRating: Double?
    let createdAt, updatedAt, userName: String?
    let category: Category?
    let subcategory, brand: Brand?
    let productSpecifications: [ProductSpecification]?
    let productVariants: [ProductVariant]?

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
        case customizedProduct = "customized_product"
        case readyToShip = "ready_to_ship"
        case cashOnDelivery = "cash_on_delivery"
        case uploadSizeChart = "upload_size_chart"
        case productActiveStatus = "product_active_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userName = "user_name"
        case category, subcategory, brand
        case productSpecifications = "product_specifications"
        case productVariants = "product_variants"
        case productAvgRating = "average_rating"
    }
}

// MARK: - Brand
//struct Brand: Codable {
//    let id: Int?
//    let nameEnglish, nameArabic: String?
//    let image: String?
//    let status: Int?
//    let createdAt, updatedAt: String?
//    let categoryID: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case nameEnglish = "name_english"
//        case nameArabic = "name_arabic"
//        case image, status
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case categoryID = "category_id"
//    }
//}

// MARK: - Category
//struct Category: Codable {
//    let id: Int?
//    let name, description: String?
//    let image: String?
//    let status: Int?
//    let colorCode, createdAt, updatedAt: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, description, image, status
//        case colorCode = "color_code"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}

// MARK: - ProductSpecification
//struct ProductSpecification: Codable {
//    let id: Int?
//    let productID, nameEn, featureEn, nameAr: String?
//    let featureAr, createdAt, updatedAt: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case productID = "product_id"
//        case nameEn = "name_en"
//        case featureEn = "feature_en"
//        case nameAr = "name_ar"
//        case featureAr = "feature_ar"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}

// MARK: - ProductVariant
//struct ProductVariant: Codable {
//    let id, productID: Int?
//    let variantImage: [String]?
//    let colorID, sizeID: String?
//    let bust, waist, hip, shoulder: String?
//    let sleeveLength, length: String?
//    let totalStock, sku: String?
//    let skuThresholdValue: String?
//    let actualPrice, discountType, discountValue, finalPrice: String?
//    let status, createdAt, updatedAt: String?
//    let color, size: Color?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case productID = "product_id"
//        case variantImage = "variant_image"
//        case colorID = "color_id"
//        case sizeID = "size_id"
//        case bust, waist, hip, shoulder
//        case sleeveLength = "sleeve_length"
//        case length
//        case totalStock = "total_stock"
//        case sku
//        case skuThresholdValue = "sku_threshold_value"
//        case actualPrice = "actual_price"
//        case discountType = "discount_type"
//        case discountValue = "discount_value"
//        case finalPrice = "final_price"
//        case status
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case color, size
//    }
//}

// MARK: - Color
//struct Color: Codable {
//    let id: Int?
//    let name, hexCode: String?
//    let createdAt, updatedAt: AtedAt?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name
//        case hexCode = "hex_code"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}
