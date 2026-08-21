//
//  SearchVM.swift
//  DesynatUser
//
//  Created by fluper on 23/12/25.
//

import UIKit

class SearchVM: NSObject {
    
    private var hostVC: SearchVC
    var recentData: [RecentDataModel] = []
    private var lastVisionResponse: [String: Any]?
    
    init(hostVC: SearchVC) {
        self.hostVC = hostVC
    }
    
    func getRecommendedSearchData() {
        WebService.sharedInstance.getRecommendedSearch { data in
            DispatchQueue.main.async {
                self.hostVC.recommendedData = data
                self.hostVC.noReconmmendedDataFoundLAbel.isHidden = !data.isEmpty
                self.hostVC.recommendedCollectionView.reloadData()
                self.hostVC.recommendedCollectionView.layoutIfNeeded()
            }
        }
    }
    
    func getRecentData() {
        WebService.sharedInstance.getRecentSearch { data in
            DispatchQueue.main.async {
                self.hostVC.recentData = data
                self.hostVC.lblNoData.isHidden = !data.isEmpty
                self.hostVC.noLatesSearchFoundLabel.isHidden = !data.isEmpty
                
                self.hostVC.RecentSearchTableView.reloadData()
                self.hostVC.latestSearchCollectionView.reloadData()
                
                self.hostVC.updateLatestSearchCollectionHeight()
            }
        }
    }
    
}

extension SearchVM {
    
    func callCloudVisionApi(image: UIImage, completion: @escaping(_ result: [String]?) -> Void) {
        CommonUtils.showHud(show: true)
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
                        //                        appDelegate.hideLoadingIndicator()
                        CommonUtils.showHud(show: false)
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
                        CommonUtils.showHud(show: false)
                        print("Error decoding JSON response: \(error.localizedDescription)")
                    }
                }
            }
            task.resume()
        }
    }
    
}
