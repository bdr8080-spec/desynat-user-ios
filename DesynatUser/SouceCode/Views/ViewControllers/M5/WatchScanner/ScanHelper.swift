//
//  ScanHelper.swift
//  iChronoDealer
//
//  Created by Navanindra Vats on 19/09/25.
//


//import UIKit
//
//class WatchRecognizer {
//  
//  //      private var watchBrands: [Brand] = []
//  var recentData: [RecentDataModel] = []
//  //    private let apiKey = "AIzaSyBq0c5p91bGWHgKKusc9CP5cQOIM-z1iuo" //Desynat User Api key
//  private let apiKey = "AIzaSyBk1iHVph8nvXAn0uigTvPzKDpb9cslR18"
//  
//  init() {
//    WebService.sharedInstance.getRecentSearch { list in
////      self.recentData = list
//    }
//  }
//  
//  // MARK: - Public
//  
//  func detectProduct(
//      image: UIImage,
//      completion: @escaping (_ productType: ProductType,
//                              _ colors: [DominantColor]) -> Void,
//      errCompletion: @escaping () -> Void
//  ) {
//
//      guard let base64Image = base64EncodeImage(image) else {
//        DispatchQueue.main.async {
//            errCompletion()
//        }
//          return
//      }
//
//      let url = URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(apiKey)")!
//
//      let requestJSON: [String: Any] = [
//          "requests": [
//              [
//                  "image": ["content": base64Image],
//                  "features": [
//                      ["type": "LABEL_DETECTION", "maxResults": 10],
//                      ["type": "IMAGE_PROPERTIES", "maxResults": 10]
//                  ]
//              ]
//          ]
//      ]
//
//      guard let requestData = try? JSONSerialization.data(withJSONObject: requestJSON) else {
//          errCompletion()
//          return
//      }
//
//      var request = URLRequest(url: url)
//      request.httpMethod = "POST"
//      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//      request.httpBody = requestData
//
//      URLSession.shared.dataTask(with: request) { data, _, error in
//
//          guard let data = data, error == nil else {
//              errCompletion()
//              return
//          }
//
//          guard
//              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
//              let responses = json["responses"] as? [[String: Any]],
//              let firstResponse = responses.first
//          else {
//              errCompletion()
//              return
//          }
//
//          // ✅ LABELS
//          let labels = firstResponse["labelAnnotations"] as? [[String: Any]] ?? []
//
//          let labelTexts = labels
//              .compactMap { $0["description"] as? String }
//              .map { $0.lowercased() }
//
//          // ✅ CATEGORY DETECTION
//          let productType = self.detectProductType(from: labelTexts)
//
//          if productType == .unknown {
//              errCompletion()
//              return
//          }
//
//          // ✅ COLORS
//          let colors = self.extractDominantColors(
//              from: firstResponse["imagePropertiesAnnotation"] as? [String: Any]
//          )
//
//        DispatchQueue.main.async {
//            completion(productType, colors)
//        }
//
//      }.resume()
//  }
//
//
//  
////  func detectBrandAndModel( image: UIImage,
////                            completion: @escaping (_ brand: RecentDataModel?, _ model: String?, _ colors: [DominantColor]) -> Void,
////                            errCompletion:@escaping()->()) {
////    
////    guard let base64Image = base64EncodeImage(image) else {
////      completion(nil, nil, [])
////      return
////    }
////    
////    let url = URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(apiKey)")!
////    
////    let requestJSON: [String: Any] = [
////      "requests": [
////        [
////          "image": ["content": base64Image],
////          "features": [
////            ["type": "WEB_DETECTION", "maxResults": 10],
////            ["type": "IMAGE_PROPERTIES", "maxResults": 10],
////            ["type": "LABEL_DETECTION", "maxResults": 10],
////            ["type": "BARCODE_DETECTION", "maxResults": 10]
////          ]
////        ]
////      ]
////    ]
////    
////    guard let requestData = try? JSONSerialization.data(withJSONObject: requestJSON) else {
////      completion(nil, nil, [])
////      return
////    }
////    
////    var request = URLRequest(url: url)
////    request.httpMethod = "POST"
////    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
////    request.httpBody = requestData
////    
////    CommonUtils.showHud(show: true)
////    
////    URLSession.shared.dataTask(with: request) { data, _, error in
////      DispatchQueue.main.async {
////        CommonUtils.showHud(show: false)
////      }
////      
////      guard let data = data, error == nil else {
////        completion(nil, nil, [])
////        return
////      }
////      
////      guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
////            let responses = json["responses"] as? [[String: Any]],
////            let firstResponse = responses.first
////      else {
////        completion(nil, nil, [])
////        return
////      }
////      
////      printInConsole("Watches Scan: \(json)")
////      
////      var brand: RecentDataModel? = nil
////      var model: String? = nil
////      var colors: [DominantColor] = []
////      
//////      if let labels = firstResponse["labelAnnotations"] as? [[String: Any]] {
//////        let watches = labels.map { ($0["description"] as? String)?.lowercased() }.compactMap(\.self)
//////        if watches.contains("watch") {
//////          continueWithNextResponse()
//////        } else {
//////          errCompletion()
//////        }
//////      }
////      if let labels = firstResponse["labelAnnotations"] as? [[String: Any]] {
////          let detectedLabels = labels
////              .compactMap { $0["description"] as? String }
////              .map { $0.lowercased() }
////
////          print("Detected labels:", detectedLabels)
////
////          // Just continue — do NOT block
////          continueWithNextResponse()
////      } else {
////          continueWithNextResponse()
////      }
////
////      
////      func continueWithNextResponse() {
////        if let imageProperties = firstResponse["imagePropertiesAnnotation"] as? [String: Any] {
////          colors = self.extractDominantColors(from: imageProperties)
////        }
////        
////        if let webDetection = firstResponse["webDetection"] as? [String: Any] {
////          if let bestGuessLabels = webDetection["bestGuessLabels"] as? [[String: Any]],
////             let guess = bestGuessLabels.first?["label"] as? String {
////            
////            let result = self.extractBrandAndModel(from: guess)
////            if result.brand != nil {
////              brand = result.brand
////              model = result.model
////            }
////          }
////          
////          if let pages = webDetection["pagesWithMatchingImages"] as? [[String: Any]] {
////            for page in pages {
////              let title = page["pageTitle"] as? String ?? ""
////              let urlText = page["url"] as? String ?? ""
////              let combined = "\(title) \(urlText)"
////              
////              let result = self.extractBrandAndModel(from: combined)
////              if result.brand != nil {
////                brand = result.brand
////                model = result.model
////              }
////            }
////          }
////          
////          if let entities = webDetection["webEntities"] as? [[String: Any]] {
////            for entity in entities {
////              if let desc = entity["description"] as? String {
////                let result = self.extractBrandAndModel(from: desc)
////                if result.brand != nil {
////                  brand = result.brand
////                  model = result.model
////                }
////              }
////            }
////          }
////        }
////        
////        
//////        completion(brand, model, colors)
////        if brand == nil && model == nil {
////            errCompletion()
////        } else {
////            completion(brand, model, colors)
////        }
////      }
////      
////    }.resume()
////  }
//  
//  func detectProductType(from labels: [String]) -> ProductType {
//
//      let map: [ProductType: [String]] = [
//          .shirt: ["shirt"],
//          .tshirt: ["t-shirt", "tshirt", "tee"],
//          .pant: ["pant", "pants", "trouser", "jeans"],
//          .dress: ["dress"],
//          .gown: ["gown"],
//          .shoes: ["shoe", "sneaker", "footwear"],
//          .watch: ["watch", "wristwatch"]
//      ]
//
//      for (type, keywords) in map {
//          if labels.contains(where: { label in
//              keywords.contains { label.contains($0) }
//          }) {
//              return type
//          }
//      }
//
//      return .unknown
//  }
//
//
//  
//  // MARK: - Helpers
//  
//  private func base64EncodeImage(_ image: UIImage) -> String? {
//    image.jpegData(compressionQuality: 0.8)?
//      .base64EncodedString(options: .endLineWithCarriageReturn)
//  }
//  
//  private func extractBrandAndModel(from text: String) -> (brand: RecentDataModel?, model: String?) {
//    for brand in recentData {
//      if text.localizedCaseInsensitiveContains(brand.name ?? "") {
//        let modelPart = text.replacingOccurrences(
//          of: brand.name ?? "",
//          with: "",
//          options: .caseInsensitive
//        )
//        
//        let cleanedModel = modelPart
//          .replacingOccurrences(of: "watch", with: "", options: .caseInsensitive)
//          .trimmingCharacters(in: .whitespacesAndNewlines)
//        
//        return (brand, cleanedModel.isEmpty ? nil : cleanedModel)
//      }
//    }
//    return (nil, nil)
//  }
//}
//
//struct DominantColor {
//  let red: Int
//  let green: Int
//  let blue: Int
//  let score: Double
//  var hexCode: String {
//    String(
//      format: "#%02X%02X%02X",
//      red,
//      green,
//      blue
//    )
//  }
//}
//
//extension WatchRecognizer {
//  
//  func extractDominantColors(from imageProperties: [String: Any]?) -> [DominantColor] {
//    guard
//      let imageProperties = imageProperties,
//      let dominantColors = imageProperties["dominantColors"] as? [String: Any],
//      let colorsArray = dominantColors["colors"] as? [[String: Any]]
//    else {
//      return []
//    }
//    
//    return colorsArray.compactMap { item in
//      guard
//        let color = item["color"] as? [String: Any],
//        let red = color["red"] as? Int,
//        let green = color["green"] as? Int,
//        let blue = color["blue"] as? Int,
//        let score = item["score"] as? Double
//      else {
//        return nil
//      }
//      
//      return DominantColor(
//        red: red,
//        green: green,
//        blue: blue,
//        score: score
//      )
//    }
//  }
//}
//
//enum ProductType: String {
//    case shirt
//    case tshirt
//    case pant
//    case dress
//    case gown
//    case shoes
//    case watch
//    case unknown
//}


import UIKit

class WatchRecognizer {
    
  var recentData: [RecentDataModel] = []
  private var lastVisionResponse: [String: Any]?

    private let apiKey = "AIzaSyBk1iHVph8nvXAn0uigTvPzKDpb9cslR18"
//  private let apiKey = "AIzaSyBq0c5p91bGWHgKKusc9CP5cQOIM-z1iuo" //Desynat User Api key
    init() {
        WebService.sharedInstance.getRecentSearch { list in
            self.recentData = list
        }
    }
  
  private func detectProductName(
      webDetection: [String: Any],
      brand: String?
  ) -> String? {

      if let bestGuess = webDetection["bestGuessLabels"] as? [[String: Any]],
         let label = bestGuess.first?["label"] as? String {

          if let brand = brand {
              return label.replacingOccurrences(
                  of: brand,
                  with: "",
                  options: .caseInsensitive
              ).trimmingCharacters(in: .whitespaces)
          }
          return label
      }
      return nil
  }

  
  private func extractAttributes(from labels: [[String: Any]]) -> [String] {

      let ignored = ["clothing", "product", "fashion", "textile"]
      
      return labels.compactMap {
          let text = ($0["description"] as? String)?.lowercased()
          return ignored.contains(text ?? "") ? nil : text
      }
  }

  
//  func recognizeProduct(
//      image: UIImage,
//      completion: @escaping (ProductRecognitionResult?) -> Void
//  ) {
//
//      detectBrandAndModel(image: image) { _, _, colors in
//          
//          guard
//              let json = self.lastVisionResponse,
//              let first = (json["responses"] as? [[String: Any]])?.first
//          else {
//              completion(nil)
//              return
//          }
//
//          let category = self.detectCategory(from: first)
//          let webDetection = first["webDetection"] as? [String: Any]
//          let brand = webDetection.flatMap { self.detectBrand(from: $0) }
//          let productName = webDetection.flatMap {
//              self.detectProductName(webDetection: $0, brand: brand)
//          }
//
//          let attributes = self.extractAttributes(
//              from: first["labelAnnotations"] as? [[String: Any]] ?? []
//          )
//
//          completion(
//              ProductRecognitionResult(
//                  category: category,
//                  brand: brand,
//                  productName: productName,
//                  attributes: attributes,
//                  colors: colors
//              )
//          )
//      }
//  }
  
  private func detectCategory(from response: [String: Any]) -> String? {

      // 1️⃣ Prefer web entities (most accurate for ecommerce)
      if let webDetection = response["webDetection"] as? [String: Any],
         let entities = webDetection["webEntities"] as? [[String: Any]] {

          let sorted = entities.sorted {
              ($0["score"] as? Double ?? 0) >
              ($1["score"] as? Double ?? 0)
          }

          return sorted.first?["description"] as? String
      }

      // 2️⃣ Fallback to labels
      if let labels = response["labelAnnotations"] as? [[String: Any]] {
          return labels.first?["description"] as? String
      }

      return nil
  }

  
  func recognizeProduct(
      image: UIImage,
      completion: @escaping (ProductRecognitionResult?) -> Void
  ) {

      detectBrandAndModel(image: image) { _, _, colors in

          guard
              let json = self.lastVisionResponse,
              let first = (json["responses"] as? [[String: Any]])?.first
          else {
              completion(nil)
              return
          }

          let category = self.detectCategory(from: first)

          let webDetection = first["webDetection"] as? [String: Any]
          let brand = webDetection.flatMap { self.detectBrand(from: $0) }
          let productName = webDetection.flatMap {
              self.detectProductName(webDetection: $0, brand: brand)
          }

          let attributes = self.extractAttributes(
              from: first["labelAnnotations"] as? [[String: Any]] ?? []
          )

          completion(
              ProductRecognitionResult(
                  category: category,
                  brand: brand,
                  productName: productName,
                  attributes: attributes,
                  colors: colors
              )
          )
      } errCompletion: {
          completion(nil)
      }
  }



    // MARK: - Public
    func detectBrandAndModel( image: UIImage,
                              completion: @escaping (_ brand: RecentDataModel?, _ model: String?, _ colors: [DominantColor]) -> Void,
                              errCompletion:@escaping()->()) {

        guard let base64Image = base64EncodeImage(image) else {
            completion(nil, nil, [])
            return
        }

        let url = URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(apiKey)")!

        let requestJSON: [String: Any] = [
            "requests": [
                [
                    "image": ["content": base64Image],
                    "features": [
                        ["type": "WEB_DETECTION", "maxResults": 10],
                        ["type": "IMAGE_PROPERTIES", "maxResults": 10],
                        ["type": "LABEL_DETECTION", "maxResults": 10],
                        ["type": "BARCODE_DETECTION", "maxResults": 10]
                    ]
                ]
            ]
        ]

        guard let requestData = try? JSONSerialization.data(withJSONObject: requestJSON) else {
            completion(nil, nil, [])
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestData

        CommonUtils.showHud(show: true)

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                CommonUtils.showHud(show: false)
            }
            
            guard let data = data, error == nil else {
                completion(nil, nil, [])
                return
            }

//            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
//                  let responses = json["responses"] as? [[String: Any]],
//                  let firstResponse = responses.first
//            else {
//                completion(nil, nil, [])
//                return
//            }
          
          guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let responses = json["responses"] as? [[String: Any]],
                let firstResponse = responses.first
          else {
              completion(nil, nil, [])
              return
          }

          // ✅ STORE RESPONSE
          self.lastVisionResponse = json


            printInConsole("Watches Scan: \(json)")
            
            var brand: RecentDataModel? = nil
            var model: String? = nil
            var colors: [DominantColor] = []
            
            if let labels = firstResponse["labelAnnotations"] as? [[String: Any]] {
                let watches = labels.map { ($0["description"] as? String)?.lowercased() }.compactMap(\.self)
//                if watches.contains("watch") {
                    continueWithNextResponse()
//                } else {
//                    errCompletion()
//                }
            }
            func continueWithNextResponse() {
                if let imageProperties = firstResponse["imagePropertiesAnnotation"] as? [String: Any] {
                    colors = self.extractDominantColors(from: imageProperties)
                }

                if let webDetection = firstResponse["webDetection"] as? [String: Any] {
                    if let bestGuessLabels = webDetection["bestGuessLabels"] as? [[String: Any]],
                       let guess = bestGuessLabels.first?["label"] as? String {

                        let result = self.extractBrandAndModel(from: guess)
                        if result.brand != nil {
                            brand = result.brand
                            model = result.model
                        }
                    }
                    
                    if let pages = webDetection["pagesWithMatchingImages"] as? [[String: Any]] {
                        for page in pages {
                            let title = page["pageTitle"] as? String ?? ""
                            let urlText = page["url"] as? String ?? ""
                            let combined = "\(title) \(urlText)"

                            let result = self.extractBrandAndModel(from: combined)
                            if result.brand != nil {
                                brand = result.brand
                                model = result.model
                            }
                        }
                    }
                    
                    if let entities = webDetection["webEntities"] as? [[String: Any]] {
                        for entity in entities {
                            if let desc = entity["description"] as? String {
                                let result = self.extractBrandAndModel(from: desc)
                                if result.brand != nil {
                                    brand = result.brand
                                    model = result.model
                                }
                            }
                        }
                    }
                }
                
                
                completion(brand, model, colors)
            }

        }.resume()
    }
  
  private func detectBrand(from webDetection: [String: Any]) -> String? {

      if let entities = webDetection["webEntities"] as? [[String: Any]] {
          let candidates = entities
              .filter { ($0["score"] as? Double ?? 0) > 0.6 }
              .compactMap { $0["description"] as? String }

          return candidates.first
      }
      return nil
  }



    // MARK: - Helpers

    private func base64EncodeImage(_ image: UIImage) -> String? {
        image.jpegData(compressionQuality: 0.8)?
            .base64EncodedString(options: .endLineWithCarriageReturn)
    }

    private func extractBrandAndModel(from text: String) -> (brand: RecentDataModel?, model: String?) {
        for brand in recentData {
            if text.localizedCaseInsensitiveContains(brand.name ?? "") {
                let modelPart = text.replacingOccurrences(
                    of: brand.name ?? "",
                    with: "",
                    options: .caseInsensitive
                )

                let cleanedModel = modelPart
                    .replacingOccurrences(of: "watch", with: "", options: .caseInsensitive)
                    .trimmingCharacters(in: .whitespacesAndNewlines)

                return (brand, cleanedModel.isEmpty ? nil : cleanedModel)
            }
        }
        return (nil, nil)
    }
}

struct DominantColor {
    let red: Int
    let green: Int
    let blue: Int
    let score: Double
    var hexCode: String {
        String(
            format: "#%02X%02X%02X",
            red,
            green,
            blue
        )
    }
}

extension WatchRecognizer {

    func extractDominantColors(from imageProperties: [String: Any]?) -> [DominantColor] {
        guard
            let imageProperties = imageProperties,
            let dominantColors = imageProperties["dominantColors"] as? [String: Any],
            let colorsArray = dominantColors["colors"] as? [[String: Any]]
        else {
            return []
        }

        return colorsArray.compactMap { item in
            guard
                let color = item["color"] as? [String: Any],
                let red = color["red"] as? Int,
                let green = color["green"] as? Int,
                let blue = color["blue"] as? Int,
                let score = item["score"] as? Double
            else {
                return nil
            }

            return DominantColor(
                red: red,
                green: green,
                blue: blue,
                score: score
            )
        }
    }
}

struct ProductRecognitionResult {
    let category: String?
    let brand: String?
    let productName: String?
    let attributes: [String]
    let colors: [DominantColor]
}
