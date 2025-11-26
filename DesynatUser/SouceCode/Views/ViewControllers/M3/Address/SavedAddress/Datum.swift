//
//  Datum.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 26/11/25.
//


// MARK: - Datum
struct Datum: Codable {
    let id, userID: Int?
    let name, mobile, countryCode, address: String?
    let houseNo, streetNo, postalCode, city: String?
    let state: String?
    let landmark: JSONNull?
    let saveAddressAs, status: Int?
    let latitude, longitude: JSONNull?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case name, mobile
        case countryCode = "country_code"
        case address
        case houseNo = "house_no"
        case streetNo = "street_no"
        case postalCode = "postal_code"
        case city, state, landmark
        case saveAddressAs = "save_address_as"
        case status, latitude, longitude
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
