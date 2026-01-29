//
//  StringConstant.swift
//  ChorApp
//
//  Created by Developer on 05/12/23.
//

import Foundation

enum StringConstant: String {
  case ok                         = "Ok"
  case done                       = "Done"
  case cancel                     = "Cancel"
  
  func value() -> String {
    return self.rawValue
  }
}

enum AlertConstant: String {
  
  case none = ""
  /// Network validation
  case noInternet                 = "Network connection failed. Please check your internet and try again."
  case noStatusCode               = "No status code found"
  case noResponse                 = "No response data"
  case wentWrong                  = "Something went wrong"
  case noDataFound                = "No data found"
  case unableToDecode             = "Unable to decode data"
  case sessionExpired             = " Your session has expired. Please log in again"
  case imageMimeNotSame           = "Mime type and file are not of same data type"
  case videoMimeNotSame           = "Video Mime type and file are not URL"
  case decodingError              = "Failed to decode response"
  
  ///Validation Error Message
  case EnterEmailOrMobileNumber   = "Please enter Email Address or Mobile Number"
  case EnterEmail                 = "Please enter email address"
  case EnterMobileNumber          = "Please Enter Mobile Number"
  case EnterValidEmailAddress     = "Please enter Valid Email"
  case validMobileNumber          = "Please enter valid mobile number between 7 to 15 digits"
  case SelectProfileImage         = "Please Upload a Profile Image"
  case EnterFullName             = "Please enter your full name"
  case EnterValidEmailorMobile   = "Please Enter Valid Email Address or Mobile Number"
  case EnterPassword              = "Please enter password"
  case InvalidPasswordFormat      = "Password must be at least 8 characters long and contain letters and digits"
//  case InvalidPasswordFormat      = "Password must be at least 8 characters long, include 1 uppercase, 1 lowercase, and 1 special character"
  case EnterNewPassword           = "Please enter create new password"
  case EnterConfirmPassword       = "Please enter confirm new password"
  case PasswordNotMatched         = "Passwords do not match"
  case changeNewMobile            = "Please enter new mobile number"
  case chnageNewEmail             = "Please enter new email address"
  case AcceptTermsAndConditions   = "Please accept the Terms & Conditions to continue"
  
  case EnterName = "Please enter name"
  case EnterCountryCode = "Please select country code"
  case EnterAddress = "Please enter address"
  case EnterHouseNumber = "Please enter house number"
  case EnterStreetNumber = "Please enter street number"
  case EnterPostalCode = "Please enter postal code"
  case EnterCity = "Please enter city"
  case EnterState = "Please enter state"
  case EnterLandMark = "Please enter landmark"
  
  case ChooseAmount = "Please choose amount"
  case EnterAmount = "Please enter amount"
  case EnterRecepientName = "Please enter recepient name"
  case EnterRecepientEmail = "Please enter recepient email"
  case EnterRecepientWhatsapp = "Please enter recepient whatsapp number"
  case EnterFromName = "Please enter your name"
  case EnterWishMessage = "Please enter wish message"
  case EnterNote = "Please enter note"
  case UplaodDoc1 = "Please upload document 1"
  case UplaodDoc2 = "Please upload document 2"
  
    case UploadAccountHolderImage   = "Please upload proof of account"
    case SelectAccountType          = "Please select an account type"
    case EnterIBAN                  = "Please enter IBAN number"
    case EnterSWIFT                 = "Please enter SWIFT/BIC number"
    case EnterBankName              = "Please enter bank name"
    case EnterAccountHolder         = "Please enter account holder name"
    case EnterAccountNumber         = "Please enter account number"
    case EnterConfirmAccountNumber  = "Please enter confirm account number"
    case chooseCountry              = "Please select country"
    case chooseLocation             = "Please select location"
    case addressLine1               = "Please enter address line 1"
    case addressLine2               = "Please enter address line 2"
    case enterPincode               = "Please enter pin code"
    case enterlocalityTown          = "Please enter locality town"
    case AccountNumberNotMatch      = "Account number and confirm account number didn't match"
    case confirmPasswordForAffiliate      = "Please Reenter password"
    case EnterNewPassowrdAffliate      = "Please Enter New Password"
    case EnterReEnterPassowrdAffliate      = "Please ReEnter New Password"
    
  func value() -> String {
    return self.rawValue
  }
}

struct MatchCharacterConstant {
  static let capitalAlphabet      = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  static let smallAlphabet        = "abcdefghijklmnopqrstuvwxyz"
  static let spacialCharacter     = "@._!#$%^&*()/<>'+,:;=?[]{}|~`-\""
  static let number               = "0123456789"
  static let timing               = number + ":"
  static let cardExpiration       = number + "/"
}


