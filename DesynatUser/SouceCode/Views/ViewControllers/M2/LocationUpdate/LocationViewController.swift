//
//  LocationViewController.swift
//  DesynatUser
//
//  Created by fluper on 06/11/25.
//

import UIKit
import GoogleMaps
import GooglePlaces

class LocationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var lblLocation: UILabel!
    
    var locationFor = ""
    var currentLocation:String?
    var latitude:Double?
    var longitude:Double?
    let ZOOM_LEVEL_HIGH:Float = 16.0
    var locationCallBack: ((String, String, String, String, String, String, Double, Double) -> ())?
    var currentLatLong = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var locationManager = CLLocationManager()
    var address = ""
    var locality = ""
    var city = ""
    var state = ""
    var country = ""
    var pincode = ""
    var locationMarker = GMSMarker()
    lazy private var viewModel = LocationViewModel(hostVC: self)
    var comingReason: ComingReasonAtLocationScreen = .fromHome
  var preSelectedLat: Double?
  var preSelectedLng: Double?
  
  override func viewDidLoad() {
      super.viewDidLoad()
      
      txtSearch.delegate = self
      viewMap.delegate = self
      
      // Setup location manager
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.requestWhenInUseAuthorization()
      locationManager.startUpdatingLocation()
      
      // Smart: Use pre-selected > current location > fallback
      let targetLat: Double
      let targetLng: Double
      let zoom: Float
      
      if let lat = preSelectedLat, let lng = preSelectedLng, lat != 0, lng != 0 {
          targetLat = lat
          targetLng = lng
          zoom = ZOOM_LEVEL_HIGH  // Zoom in if user already picked a place
      } else {
          targetLat = LocationManager.sharedInstance.location?.latitude ?? 28.6139  // Default: Delhi (or your city)
          targetLng = LocationManager.sharedInstance.location?.longitude ?? 77.2090
          zoom = 12
      }
      
      let camera = GMSCameraPosition.camera(withLatitude: targetLat, longitude: targetLng, zoom: zoom)
      viewMap.camera = camera
//      locationMarker.position = CLLocationCoordinate2D(latitude: targetLat, longitude: targetLng)
//      locationMarker.map = viewMap
      reverseGeocodeCoordinate(CLLocationCoordinate2D(latitude: targetLat, longitude: targetLng))
    
  }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCurrentLocation(_ sender: Any) {
        self.latitude = LocationManager.sharedInstance.location?.latitude ?? 0.0
        self.longitude = LocationManager.sharedInstance.location?.longitude ?? 0.0
        let camera = GMSCameraPosition.camera(withLatitude: latitude ?? 0.0, longitude: longitude ?? 0.0, zoom: 12)
        self.viewMap.camera = camera
    }
    
    @IBAction func btnSave(_ sender: Any) {
        let fullAddress = lblLocation.text ?? address
        locationCallBack?(
            fullAddress,
            locality,
            city,
            state,
            country,
            pincode,
            latitude ?? 0,
            longitude ?? 0
        )
        self.navigationController?.popViewController(animated: true)
    }
  
  func googleMapSetup() {
      viewMap.isMyLocationEnabled = false
      viewMap.delegate = self

      // If preselected location exists, show it
      if let preLat = preSelectedLat, let preLong = preSelectedLng {
          self.latitude = preLat
          self.longitude = preLong
//        viewMap.settings.myLocationButton = false
          let camera = GMSCameraPosition.camera(withLatitude: preLat, longitude: preLong, zoom: 12)
          self.viewMap.camera = camera
//          addMarker(at: CLLocationCoordinate2D(latitude: preLat, longitude: preLong))
      }
  }
    
    private func initialSetup() {
        switch comingReason {
        case .fromHome:
            titleLabel.text = "Change Location"
        case .fromAddAddress:
            titleLabel.text = "Set Location"
        }
    }
}

extension LocationViewController: CLLocationManagerDelegate,GMSMapViewDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      guard let location = locations.last else { return }

      // Only move camera if no preselected location
      if preSelectedLat == nil && preSelectedLng == nil {
          let coordinate = location.coordinate
          self.latitude = coordinate.latitude
          self.longitude = coordinate.longitude

          let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude,
                                                longitude: coordinate.longitude,
                                                zoom: 12)
          self.viewMap.animate(to: camera)
//          addMarker(at: coordinate)
      }

      locationManager.stopUpdatingLocation()
  }

    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        self.latitude = cameraPosition.target.latitude
        self.longitude = cameraPosition.target.longitude
        reverseGeocodeCoordinate(cameraPosition.target)
    }
    
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil else { return }
            guard let pm = placemarks?.first else { return }
            
            // 🔹 Extract components safely
            let name = pm.name ?? ""
            let subLocality = pm.subLocality ?? ""
            let locality = pm.locality ?? ""
            let state = pm.administrativeArea ?? ""
            let country = pm.country ?? ""
            let postalCode = pm.postalCode ?? ""
            
            // 🔹 Construct clean short address (for main field)
            var shortAddress = name
            if shortAddress.lowercased().contains(subLocality.lowercased()) {
                shortAddress = shortAddress.replacingOccurrences(of: subLocality, with: "", options: .caseInsensitive)
            }
            shortAddress = shortAddress.replacingOccurrences(of: ", ,", with: ",")
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .trimmingCharacters(in: CharacterSet(charactersIn: ", "))
            
            // 🔹 Construct full readable address
            let fullAddress = [name, subLocality, locality, state, country, postalCode]
                .filter { !$0.isEmpty }
                .joined(separator: ", ")
            
            // 🔹 Assign values (always non-nil)
            self.locality = subLocality.isEmpty ? "" : subLocality
            self.city = locality.isEmpty ? "" : locality
            self.state = state.isEmpty ? "" : state
            self.country = country.isEmpty ? "" : country
            self.pincode = postalCode.isEmpty ? "" : postalCode
            self.address = shortAddress.isEmpty ? "" : shortAddress
            
            // 🔹 Update UI
            DispatchQueue.main.async {
                self.txtSearch.text = self.address
                self.lblLocation.text = fullAddress
            }
        }
    }


    
    
}
extension LocationViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        viewMap.moveCamera(GMSCameraUpdate.setTarget(CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude), zoom: ZOOM_LEVEL_HIGH))
        dismiss(animated: true, completion: nil)
        self.txtSearch.text = place.formattedAddress
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtSearch{
            self.txtSearch.resignFirstResponder()
            let acController = GMSAutocompleteViewController()
            acController.delegate = self as GMSAutocompleteViewControllerDelegate
            present(acController, animated: true, completion: nil)
            return
        }
    }
}


enum ComingReasonAtLocationScreen {
    case fromHome
    case fromAddAddress
}
