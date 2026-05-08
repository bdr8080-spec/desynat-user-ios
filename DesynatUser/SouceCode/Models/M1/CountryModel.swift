//
//  CountryModel.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 04/11/25.
//


// MARK: - Country
struct CountryModel: Codable {
    let id: Int?
    let name,nameAr: String?
    let isoCode: String?
    let currencyName: String?
    let currencyCode: String?
    let currencySymbol: String?
    let dialCode: String?
    let flag: String?
    let exchangeRateToKwd: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case isoCode = "iso_code"
        case currencyName = "currency_name"
        case currencyCode = "currency_code"
        case currencySymbol = "currency_symbol"
        case dialCode = "dial_code"
        case flag
        case exchangeRateToKwd = "exchange_rate_to_kwd"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case nameAr = "name_ar"
    }
}

enum comingReasonAtAddAddress {
  case forEditAddress
  case forAddNewAddress
}




// MARK: - GetAllUserCountryModel
struct GetAllUserCountryModel: Codable {
    let id: Int?
    let name,nameAr, code, isoCode: String?
    let isoCodeNumber: String?
    let currencyName, currencyCode, currencySymbol: String?
    let exchangeRate: String?
    let dialCode: String?
    let flag: String?
    let flag1: String?

    enum CodingKeys: String, CodingKey {
        case id, name, code
        case isoCode = "iso_code"
        case isoCodeNumber = "iso_code_number"
        case currencyName = "currency_name"
        case currencyCode = "currency_code"
        case currencySymbol = "currency_symbol"
        case exchangeRate = "exchange_rate_to_kwd"
        case dialCode = "dial_code"
        case flag
        case nameAr = "name_ar"
      case flag1 = "flag1"
    }
}
