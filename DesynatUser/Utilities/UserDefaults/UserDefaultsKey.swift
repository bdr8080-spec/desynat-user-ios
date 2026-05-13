//
//  UserDefaultsKey.swift
//  DemoProject
//
//  Created by Rakhi Kumari on 22/09/25.
//

import Foundation


enum UserDefaultsKey : String {
    case deviceToken
    case accessToken
    case userLocation
    case user
    case affiliatedUserDeatils
    case isSkip
    case selectedLanguage
    case defaultLanguage
    case language
    case sessionToken
    case userId
    case affiliatedAccessToken
    case exchangeRateOfCurrency
    case savedUserCurrency
}

extension UserDefaults {
    func isAppInstalled() -> Bool {
        return self.bool(forKey: kIsAppInstalled)
    }
    
    func setAppInstalled(installed: Bool) {
        self.set(installed, forKey: kIsAppInstalled)
        self.synchronize()
    }
    func saveStringFor(Key: UserDefaultsKey, value:String?) {
        self.saveValue(value: value, for: Key)
    }
    
    func saveValue<T>(Key: UserDefaultsKey, value:T) {
        self.set(value, forKey: Key.rawValue)
        self.synchronize()
    }
    func getValue<T>(Key: UserDefaultsKey) -> T? {
        return self.value(forKey: Key.rawValue) as? T
    }
    
    func getStringFor(key:UserDefaultsKey) -> String? {
        return self.string(forKey: key.rawValue)
    }
    
    func saveIntFor(key:UserDefaultsKey, value:Int?) {
        self.saveValue(value: value, for: key)
    }
    
    func getIntFor(key:UserDefaultsKey) -> Int? {
        return self.integer(forKey: key.rawValue)
    }
    
    func saveModelFor(key:UserDefaultsKey, value:Encodable) {
        if let encoded = try? JSONEncoder().encode(value) {
            self.set(encoded, forKey: key.rawValue)
            self.synchronize()
        }
    }
    
    func retrieveModelFor<T: Decodable>(key: UserDefaultsKey, model: T.Type) -> T? {
        guard let data = self.data(forKey: key.rawValue) else { return nil }
        do {
            let decodedObject = try JSONDecoder().decode(model, from: data)
            return decodedObject
        } catch {
//            print("❌ Failed to decode model for key \(key.rawValue): \(error)")
            return nil
        }
    }
    
    func saveBoolFor(key:UserDefaultsKey, value:Bool) {
        self.saveValue(value: value, for: key)
    }
    
    func getModelFor<T:Decodable>(key:UserDefaultsKey,
                                  model:T.Type,
                                  completion:@escaping(_ result:Result<T, UserDefaulError>) -> Void) {
        if let data = self.object(forKey: key.rawValue) as? Data {
            do {
                let response = try JSONDecoder().decode(model, from: data)
                completion(.success(response))
            } catch let err {
//                printInConsole("Error Fetching model from user default\n\(err)")
                completion(.failure(.errorDecodingData))
            }
        } else {
            completion(.failure(.noDataFound))
        }
    }
    
    private func saveValue(value:Any?, for Key:UserDefaultsKey) {
        self.set(value, forKey: Key.rawValue)
        self.synchronize()
    }
    
    func clearAllData(except:[UserDefaultsKey]) {
        let exceptKey = except.map({$0.rawValue})
        for (key, _) in self.dictionaryRepresentation() {
            if !exceptKey.contains(key) { self.removeObject(forKey: key) }
        }
        self.synchronize()
    }
    
    func removeValue(for key: UserDefaultsKey) {
            UserDefaults.standard.removeObject(forKey: key.rawValue)
            UserDefaults.standard.synchronize()
        }
    
    
    func clearData(key:UserDefaultsKey) {
        self.removeObject(forKey: key.rawValue)
        self.synchronize()
    }
}

enum UserDefaulError: Error {
    case noDataFound
    case errorDecodingData
}

extension UserDefaulError : LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .noDataFound:
            return NSLocalizedString(AlertConstant.noDataFound.value().localiz(), comment: "")
        case .errorDecodingData:
            return NSLocalizedString(AlertConstant.unableToDecode.value().localiz(), comment: "")
        }
    }
}
