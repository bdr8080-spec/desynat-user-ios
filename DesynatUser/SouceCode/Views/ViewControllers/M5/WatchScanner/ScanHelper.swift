//
//  ScanHelper.swift
//  iChronoDealer
//
//  Created by Navanindra Vats on 19/09/25.
//

import UIKit

class WatchRecognizer {
  
  //    private var watchBrands: [Brand] = []
  var recentData: [RecentDataModel] = []
  
//  private let apiKey = "AIzaSyBk1iHVph8nvXAn0uigTvPzKDpb9cslR18"
  
  private let apiKey = "AIzaSyBq0c5p91bGWHgKKusc9CP5cQOIM-z1iuo"
  
  init() {
    WebService.sharedInstance.getRecentSearch { list in
      self.recentData = list
    }
  }
  
  // MARK: - Public
  
  func detectBrandAndModel(
    image: UIImage,
    completion: @escaping (_ brand: RecentDataModel?, _ model: String?, _ colors: [DominantColor]) -> Void
  ) {
    
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
            ["type": "LOGO_DETECTION", "maxResults": 10],
            ["type": "OBJECT_LOCALIZATION", "maxResults": 10],
            ["type": "IMAGE_PROPERTIES", "maxResults": 10],
            ["type": "LABEL_DETECTION", "maxResults": 10]
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
      
      guard
        let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
        let responses = json["responses"] as? [[String: Any]],
        let firstResponse = responses.first
      else {
        completion(nil, nil, [])
        return
      }
      
      printInConsole("Watches Scan: \(json)")
      
      // 🔹 1. Extract dominant colors
      let imageProperties = firstResponse["imagePropertiesAnnotation"] as? [String: Any]
      let colors = self.extractDominantColors(from: imageProperties)
      
      // 🔹 2. Web detection
      guard let webDetection = firstResponse["webDetection"] as? [String: Any] else {
        completion(nil, nil, colors)
        return
      }
      
      // 2.3 Web entities
      if let entities = webDetection["webEntities"] as? [[String: Any]] {
        for entity in entities {
          if let desc = entity["description"] as? String {
            let result = self.extractBrandAndModel(from: desc)
            if result.brand != nil {
              completion(result.brand, result.model, colors)
              return
            }
          }
        }
      }
      
      // 2.1 Best guess labels
      if let bestGuessLabels = webDetection["bestGuessLabels"] as? [[String: Any]],
         let guess = bestGuessLabels.first?["label"] as? String {
        
        let result = self.extractBrandAndModel(from: guess)
        if result.brand != nil {
          completion(result.brand, result.model, colors)
          return
        }
      }
      
      // 2.2 Pages with matching images
      if let pages = webDetection["pagesWithMatchingImages"] as? [[String: Any]] {
        for page in pages {
          let title = page["pageTitle"] as? String ?? ""
          let urlText = page["url"] as? String ?? ""
          let combined = "\(title) \(urlText)"
          
          let result = self.extractBrandAndModel(from: combined)
          if result.brand != nil {
            completion(result.brand, result.model, colors)
            return
          }
        }
      }
      
      // Nothing found
      completion(nil, nil, colors)
      
    }.resume()
  }
  
  // MARK: - Helpers
  
  private func base64EncodeImage(_ image: UIImage) -> String? {
    image.jpegData(compressionQuality: 0.8)?
      .base64EncodedString(options: .endLineWithCarriageReturn)
  }
  
  private func extractBrandAndModel(from text: String) -> (brand: RecentDataModel?, model: String?) {
    for brand in recentData {
      if text.localizedCaseInsensitiveContains(brand.name ?? "shirt") {
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

struct DetectedObject {
    let name: String
    let confidence: Double
    let boundingBox: CGRect?
}
