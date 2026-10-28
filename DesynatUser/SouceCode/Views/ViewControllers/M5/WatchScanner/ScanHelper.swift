//
//  ScanHelper.swift
//  iChronoDealer
//
//  Created by fluper_mac3 on 11/02/26.
//

import UIKit

class ScanProductRecognizer {
    
    var recentData: [RecentDataModel] = []
    
    private var lastVisionResponse: [String: Any]?
    
    init() {
        WebService.sharedInstance.getRecentSearch { [weak self] list in
            self?.recentData = list
        }
    }
    
    func callCloudVisionApi(image: UIImage, completion: @escaping(_ result: [String]?) -> Void) {
        Shimmer.shared.show(show: true)
        guard let imageData = image.jpegData(compressionQuality: 0.9) else {
            return
        }
        // Construct the Vision API request URL
        let requestURL = "https://vision.googleapis.com/v1/images:annotate?key=\(googleApiKey)"
        
        // Construct the request JSON
        let requestJSON: [String: Any] = [
            "requests": [
                "image": ["content": imageData.base64EncodedString()],
                "features": [
                    ["type": "LABEL_DETECTION", "maxResults": 10],
                    ["type": "OBJECT_LOCALIZATION","maxResults": 10],
                    ["type": "LOGO_DETECTION", "maxResults": 10],
                    ["type": "WEB_DETECTION","maxResults": 10],
                    ["type": "TEXT_DETECTION", "maxResults": 10],
                    ["type": "BARCODE_DETECTION","maxResults": 10]
                    as [String : Any]]
            ] as [String : Any]
        ]
        
        // Perform the request
        if let jsonData = try? JSONSerialization.data(withJSONObject: requestJSON),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            let session = URLSession.shared
            var request = URLRequest(url: URL(string: requestURL)!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonString.data(using: .utf8)
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                if let data = data {
                    // Parse the response data (data) and handle the results
                    var findObjects = [String]()
                    do {
                        // Decode the JSON response
                        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        Shimmer.shared.show(show: false)
                        // Check if the response contains 'responses' key
                        if let responses = jsonResponse?["responses"] as? [[String: Any]] {
                            // Assuming 'LABEL_DETECTION' is requested
                            print("responses: \(responses)")
                            if let objectAnnotations = responses.first?["localizedObjectAnnotations"] as? [[String: Any]] {
                                // Extract label information
                                for objectAnnotation in objectAnnotations {
                                    if let name = objectAnnotation["name"] as? String {
                                        // Handle the label description (e.g., update UI, print, etc.)
                                        print("Label: \(name)")
                                        findObjects.append(name)
                                    }
                                    if let score = objectAnnotation["score"] as? Double {
                                        // Handle the label score (e.g., update UI, print, etc.)
                                        print("Score: \(score)")
                                    }
                                }
                                completion(findObjects)
                            }
                            else if let labelAnnotations = responses.first?["labelAnnotations"] as? [[String: Any]] {
                                // Extract label information
                                for labelAnnotation in labelAnnotations {
                                    if let description = labelAnnotation["description"] as? String {
                                        // Handle the label description (e.g., update UI, print, etc.)
                                        print("Label: \(description)")
                                        findObjects.append(description)
                                    }
                                    if let score = labelAnnotation["score"] as? Double {
                                        // Handle the label score (e.g., update UI, print, etc.)
                                        print("Score: \(score)")
                                    }
                                }
                                completion(findObjects)
                            }
                            else {
                                print("No label annotations found in the response.")
                            }
                        } else {
                            print("Invalid or unexpected response format.")
                        }
                    } catch {
                        Shimmer.shared.show(show: false)
                        print("Error decoding JSON response: \(error.localizedDescription)")
                    }
                }
            }
            task.resume()
        }
    }
}

//class ScanProductRecognizer {
//
//    var recentData: [RecentDataModel] = []
//
//    private var lastVisionResponse: [String: Any]?
//
//    init() {
//        WebService.sharedInstance.getRecentSearch { [weak self] list in
//            self?.recentData = list
//        }
//    }
//
//    func callCloudVisionApi(image: UIImage,completion: @escaping ([String]?) -> Void) {
//        DispatchQueue.main.async {
//            Shimmer.shared.show(show: true)
//        }
//        // MARK: - Resize Image
//        let resizedImage = resizeImage(
//            image,
//            maxDimension: 1600
//        )
//        // MARK: - Convert Image To JPEG
//        guard let imageData = resizedImage.jpegData(
//            compressionQuality: 0.65
//        ) else {
//            DispatchQueue.main.async {
//                Shimmer.shared.show(show: false)
//            }
//            completion(nil)
//            return
//        }
//
//        // MARK: - Base64
//        let base64Image = imageData.base64EncodedString()
//        
//        // MARK: - URL
//        let requestURL = "https://vision.googleapis.com/v1/images:annotate?key=\(googleApiKey)"
//        guard let url = URL(string: requestURL) else {
//            DispatchQueue.main.async {
//                Shimmer.shared.show(show: false)
//            }
//            completion(nil)
//            return
//        }
//        let requestJSON: [String: Any] = [
//            "requests": [["image": ["content": base64Image],
//                    "features": [["type": "LABEL_DETECTION", "maxResults": 10],
//                        ["type": "OBJECT_LOCALIZATION","maxResults": 10],
//                        ["type": "LOGO_DETECTION", "maxResults": 5
//                        ],
//
//                        [
//                            "type": "WEB_DETECTION",
//                            "maxResults": 10
//                        ],
//
//                        [
//                            "type": "TEXT_DETECTION",
//                            "maxResults": 10
//                        ],
//
//                        [
//                            "type": "BARCODE_DETECTION",
//                            "maxResults": 10
//                        ]
//                    ]
//                ]
//            ]
//        ]
//
//        print("✅ Request JSON created")
//        print(requestJSON)
//        // MARK: - Serialize JSON
//
//        guard let jsonData = try? JSONSerialization.data(
//            withJSONObject: requestJSON,
//            options: []
//        ) else {
//            DispatchQueue.main.async {
//                Shimmer.shared.show(show: false)
//            }
//
//            completion(nil)
//            return
//        }
//
//        // Optional readable JSON print
//        if let jsonString = String(data: jsonData,encoding: .utf8) {
//            print(
//                jsonString.prefix(2000)
//            )
//
//            print("========== END REQUEST JSON ==========")
//        }
//
//        // MARK: - URLRequest
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonData
//        // MARK: - Print CURL
//        print("========== CURL REQUEST ==========")
//        print("curl -X POST \\")
//        print("  '\(requestURL)' \\")
//        print("  -H 'Content-Type: application/json' \\")
//        print("  --data-binary '@request.json'")
//        print("==================================")
//        print("🚀 Calling Google Vision API...")
//        // MARK: - API Call
//
//        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
//            DispatchQueue.main.async {
//                Shimmer.shared.show(show: false)
//            }
//            // MARK: - Network Error
//            if let error = error {
//                print("❌ NETWORK ERROR")
//                print(error.localizedDescription)
//                DispatchQueue.main.async {
//                    completion(nil)
//                }
//                return
//            }
//
//            // MARK: - HTTP Response
//            if let httpResponse = response as? HTTPURLResponse {
//                print("🌐 HTTP STATUS CODE:")
//                print(httpResponse.statusCode)
//                print("🌐 RESPONSE HEADERS:")
//                print(httpResponse.allHeaderFields)
//                if !(200...299).contains(httpResponse.statusCode) {
//                    print("❌ HTTP ERROR STATUS:")
//                    print(httpResponse.statusCode)
//                }
//            }
//            // MARK: - Response Data
//            guard let data = data else {
//                print("❌ NO RESPONSE DATA")
//                DispatchQueue.main.async {
//                    completion(nil)
//                }
//                return
//            }
//            print("📥 RESPONSE DATA SIZE:")
//            print("\(data.count) bytes")
//            // MARK: - Raw Response
//            if let responseString = String(data: data, encoding: .utf8) {
//                print("========== GOOGLE VISION RESPONSE ==========")
//                print(responseString)
//                print("========== END RESPONSE ==========")
//            }
//            // MARK: - Decode JSON
//            do {
//                guard let jsonResponse =
//                        try JSONSerialization.jsonObject(
//                            with: data,
//                            options: []
//                        ) as? [String: Any]
//                else {
//
//                    print("❌ Response is not a JSON dictionary")
//
//                    DispatchQueue.main.async {
//                        completion(nil)
//                    }
//
//                    return
//                }
//
//                self?.lastVisionResponse = jsonResponse
//
//                print("✅ JSON RESPONSE DECODED")
//
//                // MARK: - Google API Error
//
//                if let errorObject =
//                    jsonResponse["error"] as? [String: Any] {
//
//                    print("❌ GOOGLE VISION API ERROR")
//
//                    if let code = errorObject["code"] {
//                        print("Code:", code)
//                    }
//
//                    if let status = errorObject["status"] {
//                        print("Status:", status)
//                    }
//
//                    if let message = errorObject["message"] {
//                        print("Message:", message)
//                    }
//
//                    DispatchQueue.main.async {
//                        completion(nil)
//                    }
//
//                    return
//                }
//
//                // MARK: - Responses
//
//                guard let responses =
//                    jsonResponse["responses"] as? [[String: Any]]
//                else {
//
//                    print("❌ Invalid or unexpected response format")
//
//                    print(
//                        "Available response keys:",
//                        jsonResponse.keys
//                    )
//
//                    DispatchQueue.main.async {
//                        completion(nil)
//                    }
//
//                    return
//                }
//
//                print("✅ Responses count:", responses.count)
//
//                var findObjects: [String] = []
//
//                // MARK: - Parse Each Response
//
//                for responseItem in responses {
//
//                    // -----------------------------------------
//                    // LABEL DETECTION
//                    // -----------------------------------------
//
//                    if let labelAnnotations =
//                        responseItem["labelAnnotations"]
//                            as? [[String: Any]] {
//
//                        print(
//                            "🏷️ Label count:",
//                            labelAnnotations.count
//                        )
//
//                        for label in labelAnnotations {
//
//                            if let description =
//                                label["description"] as? String {
//
//                                print(
//                                    "🏷️ Label:",
//                                    description
//                                )
//
//                                findObjects.append(description)
//                            }
//
//                            if let score =
//                                label["score"] as? Double {
//
//                                print(
//                                    "📊 Label score:",
//                                    score
//                                )
//                            }
//                        }
//                    }
//
//                    // -----------------------------------------
//                    // OBJECT LOCALIZATION
//                    // -----------------------------------------
//
//                    if let objects =
//                        responseItem["localizedObjectAnnotations"]
//                            as? [[String: Any]] {
//
//                        print(
//                            "📦 Object count:",
//                            objects.count
//                        )
//
//                        for object in objects {
//
//                            if let name =
//                                object["name"] as? String {
//
//                                print(
//                                    "📦 Object:",
//                                    name
//                                )
//
//                                findObjects.append(name)
//                            }
//
//                            if let score =
//                                object["score"] as? Double {
//
//                                print(
//                                    "📊 Object score:",
//                                    score
//                                )
//                            }
//                        }
//                    }
//
//                    // -----------------------------------------
//                    // LOGO DETECTION
//                    // -----------------------------------------
//
//                    if let logos =
//                        responseItem["logoAnnotations"]
//                            as? [[String: Any]] {
//
//                        print(
//                            "🔷 Logo count:",
//                            logos.count
//                        )
//
//                        for logo in logos {
//
//                            if let description =
//                                logo["description"] as? String {
//
//                                print(
//                                    "🔷 Logo:",
//                                    description
//                                )
//
//                                findObjects.append(description)
//                            }
//
//                            if let score =
//                                logo["score"] as? Double {
//
//                                print(
//                                    "📊 Logo score:",
//                                    score
//                                )
//                            }
//                        }
//                    }
//
//                    // -----------------------------------------
//                    // WEB DETECTION
//                    // -----------------------------------------
//
//                    if let webDetection =
//                        responseItem["webDetection"]
//                            as? [String: Any] {
//
//                        if let entities =
//                            webDetection["webEntities"]
//                                as? [[String: Any]] {
//
//                            print(
//                                "🌐 Web entity count:",
//                                entities.count
//                            )
//
//                            for entity in entities {
//
//                                if let description =
//                                    entity["description"] as? String {
//
//                                    print(
//                                        "🌐 Web Entity:",
//                                        description
//                                    )
//
//                                    findObjects.append(description)
//                                }
//
//                                if let score =
//                                    entity["score"] as? Double {
//
//                                    print(
//                                        "📊 Web score:",
//                                        score
//                                    )
//                                }
//                            }
//                        }
//                    }
//
//                    // -----------------------------------------
//                    // TEXT DETECTION
//                    // -----------------------------------------
//
//                    if let textAnnotations =
//                        responseItem["textAnnotations"]
//                            as? [[String: Any]] {
//
//                        print(
//                            "📝 Text annotation count:",
//                            textAnnotations.count
//                        )
//
//                        for text in textAnnotations {
//
//                            if let description =
//                                text["description"] as? String {
//
//                                print(
//                                    "📝 Detected Text:",
//                                    description
//                                )
//                            }
//                        }
//                    }
//
//                    // -----------------------------------------
//                    // BARCODE DETECTION
//                    // -----------------------------------------
//
//                    if let barcodes =
//                        responseItem["barcodeAnnotations"]
//                            as? [[String: Any]] {
//
//                        print(
//                            "📱 Barcode count:",
//                            barcodes.count
//                        )
//
//                        for barcode in barcodes {
//
//                            if let displayValue =
//                                barcode["displayValue"] as? String {
//
//                                print(
//                                    "📱 Barcode:",
//                                    displayValue
//                                )
//
//                                findObjects.append(displayValue)
//                            }
//                        }
//                    }
//                }
//
//                // MARK: - Remove Duplicates
//
//                findObjects = Array(
//                    Set(
//                        findObjects
//                            .map {
//                                $0.trimmingCharacters(
//                                    in: .whitespacesAndNewlines
//                                )
//                            }
//                            .filter {
//                                !$0.isEmpty
//                            }
//                    )
//                )
//
//                print("================================")
//                print("✅ FINAL DETECTED OBJECTS")
//                print(findObjects)
//                print("================================")
//
//                DispatchQueue.main.async {
//                    completion(findObjects)
//                }
//
//            } catch {
//
//                print("❌ JSON DECODING ERROR")
//                print(error.localizedDescription)
//
//                if let responseString =
//                    String(data: data, encoding: .utf8) {
//
//                    print("❌ RESPONSE THAT FAILED TO DECODE:")
//                    print(responseString)
//                }
//
//                DispatchQueue.main.async {
//                    completion(nil)
//                }
//            }
//        }
//
//        task.resume()
//
//        print("🚀 URLSession task resumed")
//    }
//
//    // MARK: - Resize Image
//
//    private func resizeImage(
//        _ image: UIImage,
//        maxDimension: CGFloat
//    ) -> UIImage {
//
//        let originalSize = image.size
//
//        let scale = min(
//            maxDimension / originalSize.width,
//            maxDimension / originalSize.height,
//            1.0
//        )
//
//        let newSize = CGSize(
//            width: originalSize.width * scale,
//            height: originalSize.height * scale
//        )
//
//        if newSize == originalSize {
//            return image
//        }
//
//        UIGraphicsBeginImageContextWithOptions(
//            newSize,
//            true,
//            1.0
//        )
//
//        image.draw(
//            in: CGRect(
//                origin: .zero,
//                size: newSize
//            )
//        )
//
//        let resizedImage =
//            UIGraphicsGetImageFromCurrentImageContext()
//
//        UIGraphicsEndImageContext()
//
//        return resizedImage ?? image
//    }
//}
