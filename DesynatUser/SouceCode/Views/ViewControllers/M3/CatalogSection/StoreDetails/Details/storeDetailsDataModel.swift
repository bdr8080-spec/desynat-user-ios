//
//  storeDetailsDataModel.swift
//  DesynatUser
//
//  Created by fluper on 25/11/25.
//

import Foundation

// MARK: - SingleStoreDetailsDataModel
struct SingleStoreDetailsDataModel: Codable {
    let store: Store?
    var allProduct: AllProduct?

    enum CodingKeys: String, CodingKey {
        case store
        case allProduct = "All_Product"
    }
}

// MARK: - AllProduct
struct AllProduct: Codable {
    let currentPage: Int?
    var data: [ProductList]?
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

// MARK: - ProductList
struct ProductList: Codable {
    let id: Int?
    let sellerID, storeID, categoryID, subcategoryID: String?
    let brandID, otherEn, otherAr, productNameEn: String?
    let productNameAr, descriptionEn, descriptionAr, minCardQuantity: String?
    let maxCardQuantity, productReturn, returnDays, productExchangable: String?
    let exchangableDays, reviewRating, affiliatedProduct, customizedProduct: String?
    let readyToShip, cashOnDelivery: String?
    let uploadSizeChart: String?
    let productActiveStatus: Int?
    let productAvgRating: Double?
    let createdAt, updatedAt: String?
    var wishlist: Int?
    let brand: Brand?
    let category: Category?
    let subcategory: Brand?
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
        case wishlist, brand, category, subcategory
        case productSpecifications = "product_specifications"
        case productVariants = "product_variants"
        case productAvgRating = "average_rating"
    }
}

// MARK: - Brand
struct Brand: Codable {
    let id: Int?
    let nameEnglish, nameArabic: String?
    let image: String?
    let status: Int?
    let createdAt, updatedAt: String?
    let categoryID: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case nameEnglish = "name_english"
        case nameArabic = "name_arabic"
        case image, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case categoryID = "category_id"
    }
}

// MARK: - Category
struct Category: Codable {
    let id: Int?
    let name, nameAr, description: String?
    let image: String?
    let status: Int?
    let colorCode, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, description, image, status
        case colorCode = "color_code"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case nameAr = "name_ar"
    }
}

// MARK: - ProductSpecification
struct ProductSpecification: Codable {
    let id: Int?
    let productID, nameEn, featureEn, nameAr: String?
    let featureAr, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case nameEn = "name_en"
        case featureEn = "feature_en"
        case nameAr = "name_ar"
        case featureAr = "feature_ar"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - ProductVariant
struct ProductVariant: Codable {
    let id, productID: Int?
    let variantImage: [String]?
    let colorID, sizeID: String?
    let bust, waist, hip, shoulder: String?
    let sleeveLength, length: String?
    let totalStock, sku, skuThresholdValue, actualPrice: String?
    let discountType, discountValue, finalPrice, status: String?
    let createdAt, updatedAt: String?
    let color, size: Color?

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case variantImage = "variant_image"
        case colorID = "color_id"
        case sizeID = "size_id"
        case bust, waist, hip, shoulder
        case sleeveLength = "sleeve_length"
        case length
        case totalStock = "total_stock"
        case sku
        case skuThresholdValue = "sku_threshold_value"
        case actualPrice = "actual_price"
        case discountType = "discount_type"
        case discountValue = "discount_value"
        case finalPrice = "final_price"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case color, size
    }
}

// MARK: - Color
struct Color: Codable {
    let id: Int?
    let name,nameAr, hexCode, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case hexCode = "hex_code"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case nameAr = "name_ar"
    }
}

// MARK: - Link
struct Link: Codable {
    let url: String?
    let label: String?
    let active: Bool?
}

// MARK: - Store
struct Store: Codable {
    let id, sellerID: Int?
    let storeImage: String?
    let storeName, country, storeAddress, addressLine1: String?
    let addressLine2, storePhone, countryCode, storeMailID: String?
    let storeAvailability: Int?
    let bio, storeLet, long, createdAt: String?
    let updatedAt: String?
    let sellerInformation: SellerInformation?

    enum CodingKeys: String, CodingKey {
        case id
        case sellerID = "seller_id"
        case storeImage = "store_image"
        case storeName = "store_name"
        case country
        case storeAddress = "store_address"
        case addressLine1 = "address_line1"
        case addressLine2 = "address_line2"
        case storePhone = "store_phone"
        case countryCode = "country_code"
        case storeMailID = "store_mail_id"
        case storeAvailability = "Store_Availability"
        case bio
        case storeLet = "let"
        case long
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case sellerInformation = "seller_information"
    }
}


// MARK: - SellerHighlightsModel
struct SellerHighlightsModel: Codable {
    var id, type, sellerID: Int?
    var file: String?
    var title: String?
    var status: Int?
    var createdAt, updatedAt, isPromotional: String?
    var isWhishlisted: Int?
    var isSeen: Int?
    var sellerDetails: SellerDetails?

    enum CodingKeys: String, CodingKey {
        case id, type
        case sellerID = "seller_id"
        case file, title, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isWhishlisted = "is_whishlisted"
        case isSeen = "is_seen"
        case sellerDetails = "seller_details"
        case isPromotional = "is_promotional"

    }
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let value  = try? container.decodeIfPresent(Int.self, forKey: .id) {
                id = value
            }
            if let value  = try? container.decodeIfPresent(Int.self, forKey: .type) {
                type = value
            }
            if let value  = try? container.decodeIfPresent(Int.self, forKey: .sellerID) {
                sellerID = value
            }
            if let value  = try? container.decodeIfPresent(String.self, forKey: .file) {
                file = value
            }
            if let value  = try? container.decodeIfPresent(String.self, forKey: .title) {
                title = value
            }
            if let value  = try? container.decodeIfPresent(Int.self, forKey: .status) {
                status = value
            }
            if let value  = try? container.decodeIfPresent(String.self, forKey: .createdAt) {
                createdAt = value
            }
            if let value  = try? container.decodeIfPresent(String.self, forKey: .updatedAt) {
                updatedAt = value
            }
            if let value  = try? container.decodeIfPresent(Int.self, forKey: .isWhishlisted) {
                isWhishlisted = value
            }
            
            if let value  = try? container.decodeIfPresent(Int.self, forKey: .isSeen) {
                isSeen = value
            }
            
            if let value  = try? container.decodeIfPresent(SellerDetails.self, forKey: .sellerDetails) {
                sellerDetails = value
            }
            
            if let value  = try? container.decodeIfPresent(String.self, forKey: .isPromotional) {
                isPromotional = value
            }
            
        } catch {
            print("error:",error.localizedDescription)
        }
    }
}
//
//// MARK: - GetHighLightsList
//struct GetHighLightsList: Codable {
//    let id, type, sellerID: Int?
//    let file: String?
//    let title: String?
//    let thumbnail: String?
//    let status: Int?
//    let createdAt, updatedAt: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id, type
//        case sellerID = "seller_id"
//        case file, title, status, thumbnail
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}

// MARK: - GetHighLightsList
struct GetHighLightsList: Codable {
    let title: String?
    let highlights: [HighlightsList]?
}

// MARK: - HighlightsList
struct HighlightsList: Codable {
    let id, type, sellerID: Int?
    let file: String?
    let title: String?
    let status: Int?
    let thumbnail, isPromotional: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, type
        case sellerID = "seller_id"
        case file, title, status, thumbnail
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isPromotional = "is_promotional"
    }
}
