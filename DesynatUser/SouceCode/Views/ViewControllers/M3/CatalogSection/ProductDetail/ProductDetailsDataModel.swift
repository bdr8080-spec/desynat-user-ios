//
//  ProductDetailsDataModel.swift
//  DesynatUser
//
//  Created by fluper on 18/11/25.
//

import Foundation

struct CheckDeliveryModel {
    let image: String?
    let title: String?
}

// MARK: - ProductDetailsDataModel
struct ProductDetailsDataModel: Codable {
    let id: Int?
    let sellerID, storeID, categoryID, subcategoryID: String?
    let brandID, otherEn, otherAr, productNameEn: String?
    let productNameAr, descriptionEn, descriptionAr, minCardQuantity: String?
    let maxCardQuantity, productReturn, returnDays, productExchangable: String?
    let exchangableDays, reviewRating, affiliatedProduct, customizedProduct: String?
    let readyToShip, cashOnDelivery: String?
    let uploadSizeChart: String?
    let productActiveStatus: Int?
    let createdAt, updatedAt: String?
    var wishlist: Int?
  var addtocartTotalProduct: Int?
    let category: Category?
  let addtocart: Addtocart?
    let subcategory, brand: Brand?
  let store: Store?
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
      case addtocart
      case addtocartTotalProduct = "addtocartTotalProduct"
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
        case wishlist, category, subcategory, brand
        case productSpecifications = "product_specifications"
        case productVariants = "product_variants"
      case store = "store"
    }
}

// MARK: - Addtocart
struct Addtocart: Codable {
    let id, userID, productID, quantity: Int?
    let variantsID: Int?
    let amount, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case productID = "product_id"
        case quantity
        case variantsID = "variants_id"
        case amount
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

//// MARK: - Brand
//struct Brand: Codable {
//    let id: Int
//    let nameEnglish, nameArabic: String
//    let image: String
//    let status: Int
//    let createdAt, updatedAt: String
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
//
//// MARK: - Category
//struct Category: Codable {
//    let id: Int
//    let name, description: String
//    let image: String
//    let status: Int
//    let colorCode, createdAt, updatedAt: String
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, description, image, status
//        case colorCode = "color_code"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}
//
//// MARK: - ProductSpecification
//struct ProductSpecification: Codable {
//    let id: Int
//    let productID, nameEn, featureEn, nameAr: String
//    let featureAr, createdAt, updatedAt: String
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
//
//// MARK: - ProductVariant
//struct ProductVariant: Codable {
//    let id, productID: Int
//    let variantImage: [String]
//    let colorID, sizeID, bust, waist: String
//    let hip, shoulder, sleeveLength, length: String
//    let totalStock, sku, skuThresholdValue, actualPrice: String
//    let discountType, discountValue, finalPrice, status: String
//    let createdAt, updatedAt: String
//    let color, size: Color
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
//
//// MARK: - Color
//struct Color: Codable {
//    let id: Int
//    let name: String
//    let hexCode: String?
//    let createdAt, updatedAt: String
//
//    enum CodingKeys: String, CodingKey {
//        case id, name
//        case hexCode = "hex_code"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}
