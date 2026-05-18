//
//  SocialLoginManager.swift
//  DemoProject
//
//  Created by Rakhi Kumari on 22/09/25.
//

import Foundation
import GoogleSignIn
import AuthenticationServices
import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

// MARK: - Social Login Manager
class SocialLoginManager: NSObject {
    
    // MARK: - Singleton
    static let shared = SocialLoginManager()
    private weak var presentingVC: UIViewController?
    // MARK: - Typealiases
    public typealias SignupCompletion = ([String: Any]?, Error?) -> Void
    
    // MARK: - Properties
    public var appleSignUpStatus: SignupCompletion?
    
    private override init() {
        super.init()
    }
}

// MARK: - Google Sign-In
extension SocialLoginManager {
    
    public func signupWithGoogle(_ vc: UIViewController,
                                 completion: @escaping SignupCompletion) {
        
        GIDSignIn.sharedInstance.signIn(withPresenting: vc) { signInResult, error in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let result = signInResult else {
                completion(nil, nil)
                return
            }
            
            let user = result.user
            
            let finalDict: [String: Any] = [
                "social_id": user.userID ?? "",
                "social_login_type": "google",
                "email": user.profile?.email ?? "",
                "name": user.profile?.name ?? "",
                "profile_image": user.profile?.imageURL(withDimension: 200)?.absoluteString ?? ""
            ]
            
            completion(finalDict, nil)
        }
    }
}

// MARK: - Facebook Login
extension SocialLoginManager {
    
    public func signupWithFacebook(_ vc: UIViewController, completion: @escaping SignupCompletion) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: vc) { result, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let result = result else {
                completion(nil, nil)
                return
            }
            
            if result.isCancelled {
                let cancelError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Facebook login cancelled"])
                completion(nil, cancelError)
                return
            }
            self.fetchFacebookUserData(completion: completion)
        }
    }
    
    // MARK: - Fetch Facebook User Data
    private func fetchFacebookUserData(completion: @escaping SignupCompletion) {
        guard AccessToken.current != nil else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No active Facebook access token"])
            completion(nil, error)
            return
        }
        let parameters = ["fields": "id,name,email,picture.type(large)"]
        GraphRequest(graphPath: "me", parameters: parameters).start { _, result, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let userData = result as? [String: Any] else {
                let error = NSError(domain: "",code: -1,userInfo: [NSLocalizedDescriptionKey: "Unable to fetch Facebook user data"])
                completion(nil, error)
                return
            }
            let pictureDict = userData["picture"] as? [String: Any]
            let dataDict = pictureDict?["data"] as? [String: Any]
            let imageURL = dataDict?["url"] as? String
            let finalDict: [String: Any] = [
                "social_id": userData["id"] as? String ?? "",
                "social_login_type": "facebook",
                "email": userData["email"] as? String ?? "",
                "name": userData["name"] as? String ?? "",
                "profile_image": imageURL ?? ""
            ]
            completion(finalDict, nil)
        }
    }
}

// MARK: - Apple Sign-In
extension SocialLoginManager: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    public func signupWithApple(_ vc: UIViewController) {

        self.presentingVC = vc

        let appleIDProvider = ASAuthorizationAppleIDProvider()

        let request = appleIDProvider.createRequest()

        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(
            authorizationRequests: [request]
        )

        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self

        authorizationController.performRequests()
    }
    
    // MARK: ASAuthorizationControllerDelegate
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let fullName = [
                appleIDCredential.fullName?.givenName,
                appleIDCredential.fullName?.familyName
            ]
            .compactMap { $0 }
            .joined(separator: " ")
            
            let finalDict: [String: Any] = [
                "social_id": appleIDCredential.user,
                "name": fullName,
                "email": appleIDCredential.email ?? "",
                "social_login_type": "apple"
            ]
            
            self.appleSignUpStatus?(finalDict, nil)
            
        } else {
            
            let error = NSError(domain: "",
                                code: -1,
                                userInfo: [NSLocalizedDescriptionKey: "Apple Sign-In failed"])
            
            self.appleSignUpStatus?(nil, error)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        print("Sign in with Apple failed: \(error.localizedDescription)")
        self.appleSignUpStatus?(nil, error)
    }
    
    // MARK: ASAuthorizationControllerPresentationContextProviding
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {

        return presentingVC?.view.window ?? ASPresentationAnchor()
    }
}


/// usuage

//SocialLoginManager.shared.signupWithGoogle(self) { result, error in
//    if let error = error {
//        print("Google Sign-In error: \(error.localizedDescription)")
//    } else if let userInfo = result {
//        print("Google User info: \(userInfo)")
//    }
//}


//SocialLoginManager.shared.appleSignUpStatus = { result, error in
//    if let error = error {
//        print("Apple Sign-In error: \(error.localizedDescription)")
//    } else if let userInfo = result {
//        print("Apple User info: \(userInfo)")
//    }
//}
//
//// Call sign-in
//SocialLoginManager.shared.signupWithApple(self)
