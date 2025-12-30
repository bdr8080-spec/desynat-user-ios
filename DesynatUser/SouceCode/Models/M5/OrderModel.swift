//
//  OrderModel.swift
//  DesynatUser
//
//  Created by fluper on 19/12/25.
//

// MARK: - Datum
struct OrderModel: Codable {
    let id, orderID, userID, productID: Int?
    let variantsID, quantity: Int?
    let amount, status, createdAt, updatedAt: String?
    let returnType, rEApprove: String?
    let returnReason, returnImage, exchangeReason, cancelReason, exchangeNewSize: String?
    let exchangeOldSize, notDeliveredReason: String?
    let paymentStatus, deliveryStatus: String?
    let allOtherOrderVarient: [AllOtherOrderVarient]?
    let order: Order?
    let productDetails: ProductDetails?
    let variationDetails: VariationDetails?
    let userRatingReviewProvide: UserRatingReviewProvide?
    
    enum CodingKeys: String, CodingKey {
        case id
        case orderID = "order_id"
        case userID = "user_id"
        case productID = "product_id"
        case variantsID = "variants_id"
        case quantity, amount, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case returnType = "return_type"
        case rEApprove = "r_e_approve"
        case allOtherOrderVarient
        case returnReason = "return_reason"
        case returnImage = "return_image"
        case exchangeReason = "exchange_reason"
        case cancelReason = "cancel_reason"
        case exchangeNewSize = "exchange_new_size"
        case exchangeOldSize = "exchange_old_size"
        case paymentStatus = "payment_status"
        case deliveryStatus = "delivery_status"
        case order
        case productDetails = "product_details"
        case variationDetails = "variation_details"
        case userRatingReviewProvide = "user_rating_review_provide"
      case notDeliveredReason = "not_delivered_reason"
    }
}

// MARK: - AllOtherOrderVarient
struct AllOtherOrderVarient: Codable {
    let id, orderID, userID, productID: Int?
    let variantsID, quantity: Int?
    let amount, status, createdAt, updatedAt: String?
    let returnType, rEApprove: String?
    let returnReason, returnImage, exchangeReason, exchangeNewSize: String?
    let exchangeOldSize: String?
    let paymentStatus, deliveryStatus: String?
    let deliveryBoyID: String?
    let assignStatus: String?
    let assignDate, cancelReason: String?
    let isPicked: String?
    let notDeliveredReason: String?
    let productDetails: ProductDetails?
    let variationDetails: VariationDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case orderID = "order_id"
        case userID = "user_id"
        case productID = "product_id"
        case variantsID = "variants_id"
        case quantity, amount, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case returnType = "return_type"
        case rEApprove = "r_e_approve"
        case returnReason = "return_reason"
        case returnImage = "return_image"
        case exchangeReason = "exchange_reason"
        case exchangeNewSize = "exchange_new_size"
        case exchangeOldSize = "exchange_old_size"
        case paymentStatus = "payment_status"
        case deliveryStatus = "delivery_status"
        case deliveryBoyID = "delivery_boy_id"
        case assignStatus = "assign_status"
        case assignDate = "assign_date"
        case cancelReason = "cancel_reason"
        case isPicked = "is_picked"
        case notDeliveredReason = "not_delivered_reason"
        case productDetails = "product_details"
        case variationDetails = "variation_details"
    }
}

// MARK: - UserRatingReviewProvide
struct UserRatingReviewProvide: Codable {
    let id, userID, orderID, orderdetailsID: Int?
    let productID: Int?
    let productRating, productReview, productImage: String?
    let storeID: Int?
    let storeRating, storeReview, storeImage, createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case orderID = "order_id"
        case orderdetailsID = "orderdetails_id"
        case productID = "product_id"
        case productRating = "product_rating"
        case productReview = "product_review"
        case productImage = "product_image"
        case storeID = "store_id"
        case storeRating = "store_rating"
        case storeReview = "store_review"
        case storeImage = "store_image"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Order
struct Order: Codable {
    let id: Int?
    let orderID: String?
    let userID, deliveryAddress: Int?
    let totalMrp, discountMrp, promocodeStatus: String?
    let promocodeID, promocodeValue, giftcardAmount, giftcardID: String?
    let shippingFees, tax: String?
    let walletAmount: String?
    let totalAmount, paymentStatus, paymentMethod, deliveryStatus: String?
    let transactionID, deliveryBoyID: String?
    let assignStatus: String?
    let assignDate, notDeliveredReason: String?
    let createdAt, updatedAt: String?
    let deliveryDetails: DeliveryDetails?
    let giftCardDetails, promocodeDetails: String?

    enum CodingKeys: String, CodingKey {
        case id
        case orderID = "order_id"
        case userID = "user_id"
        case deliveryAddress = "delivery_address"
        case totalMrp = "total_mrp"
        case discountMrp = "discount_mrp"
        case promocodeStatus = "promocode_status"
        case promocodeID = "promocode_id"
        case promocodeValue = "promocode_value"
        case giftcardAmount = "giftcard_amount"
        case giftcardID = "giftcard_id"
        case shippingFees = "shipping_fees"
        case tax
        case walletAmount = "wallet_amount"
        case totalAmount = "total_amount"
        case paymentStatus = "payment_status"
        case paymentMethod = "payment_method"
        case deliveryStatus = "delivery_status"
        case transactionID = "transaction_id"
        case deliveryBoyID = "delivery_boy_id"
        case assignStatus = "assign_status"
        case assignDate = "assign_date"
        case notDeliveredReason = "not_delivered_reason"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deliveryDetails = "delivery_details"
        case giftCardDetails = "gift_card_details"
        case promocodeDetails = "promocode_details"
    }
}


// MARK: VariationDetails
struct VariationDetails: Codable {
    let id, productID: Int?
    let parentChild: String?
    let variantImage: [String]?
    let colorID, sizeID, bust, waist: String?
    let hip, shoulder, sleeveLength, length: String?
    let totalStock, sku: String?
    let skuThresholdValue: String?
    let actualPrice, discountType, discountValue, finalPrice: String?
    let status, createdAt, updatedAt: String?
    let color, size: Color?

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case parentChild = "parent_child"
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

// MARK: - Datum
struct RejectReasonModel: Codable {
    let id: Int?
    let reasonEnglish, reasonArabic: String?
    let type, status: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case reasonEnglish = "reason_english"
        case reasonArabic = "reason_arabic"
        case type, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct RecentDataModel: Codable {
    let id, userID: Int?
    let name, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - DataClass
struct SearchModel: Codable {
    let currentPage: Int?
    let data: [ProductList]?
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

// MARK: - Datum
//struct DataModel: Codable {
//    let id: Int?
//    let sellerID, storeID, categoryID, subcategoryID: String?
//    let brandID: String?
//    let otherEn, otherAr: String?
//    let productNameEn, productNameAr, descriptionEn, descriptionAr: String?
//    let minCardQuantity, maxCardQuantity, productReturn: String?
//    let returnDays: String?
//    let productExchangable: String?
//    let exchangableDays: String?
//    let reviewRating, affiliatedProduct: String?
//    let affiliatedCommission: String?
//    let customizedProduct, readyToShip, cashOnDelivery: String?
//    let uploadSizeChart: String?
//    let productActiveStatus: Int?
//    let createdAt, updatedAt: String?
//    let wishlist: Int?
//    let brand: Brand?
//    let category: Category?
//    let subcategory: Brand?
//    let productSpecifications: [ProductSpecification]?
//    let productVariants: [ProductVariant]?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case sellerID = "seller_id"
//        case storeID = "store_id"
//        case categoryID = "category_id"
//        case subcategoryID = "subcategory_id"
//        case brandID = "brand_id"
//        case otherEn = "other_en"
//        case otherAr = "other_ar"
//        case productNameEn = "product_name_en"
//        case productNameAr = "product_name_ar"
//        case descriptionEn = "description_en"
//        case descriptionAr = "description_ar"
//        case minCardQuantity = "min_card_quantity"
//        case maxCardQuantity = "max_card_quantity"
//        case productReturn = "product_return"
//        case returnDays = "return_days"
//        case productExchangable = "product_exchangable"
//        case exchangableDays = "exchangable_days"
//        case reviewRating = "review_rating"
//        case affiliatedProduct = "affiliated_product"
//        case affiliatedCommission = "affiliated_commission"
//        case customizedProduct = "customized_product"
//        case readyToShip = "ready_to_ship"
//        case cashOnDelivery = "cash_on_delivery"
//        case uploadSizeChart = "upload_size_chart"
//        case productActiveStatus = "product_active_status"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case wishlist, brand, category, subcategory
//        case productSpecifications = "product_specifications"
//        case productVariants = "product_variants"
//    }
//}
