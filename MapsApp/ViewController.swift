//
//  ViewController.swift
//  MapsApp
//
//  Created by Kwikku Nusantara on 21/05/23.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {

    @IBOutlet weak var mapPreview: GMSMapView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var labelTextField: UITextField!
    @IBOutlet weak var btnEdit: UIButton!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnEdit.layer.cornerRadius = btnEdit.frame.width / 2
        btnEdit.clipsToBounds = true
        
        btnEdit.layer.shadowColor = UIColor.black.cgColor
        btnEdit.layer.shadowOffset = CGSize(width: 0, height: 2)
        btnEdit.layer.shadowRadius = 4
        btnEdit.layer.shadowOpacity = 0.5
        btnEdit.layer.masksToBounds = false
        
        mapPreview.delegate = self
        locationManager.delegate = self

        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()

            mapPreview.isMyLocationEnabled = true
            mapPreview.settings.myLocationButton = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func handlePickedLocation(_ data: String) {
        addressTextField.text = data
    }
    
    @IBAction func btnEditPressed(_ sender: Any) {
        if let mapsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapsScene") as? MapsViewController {
            
            mapsViewController.completionHandler = { [weak self] data in
                self?.handlePickedLocation(data)
            }
            
            if let navigator = navigationController {
                navigator.pushViewController(mapsViewController, animated: true)
            }
        }

    }
    
    @IBAction func btnSavePressed(_ sender: Any) {
        let textFields: [UITextField] = [addressTextField, detailTextField, labelTextField]
        
        for textField in textFields {
            guard let text = textField.text, !text.isEmpty else {
                showAlert(title: "Error", message: "Don't Leave Blank!", error: true)
                return
            }
        }
        
        showAlert(title: "Alert", message: "Siap Dikirim")

    }
    
    func showAlert(title: String, message: String, error: Bool = false) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: error ? .destructive : .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
  func locationManager(
    _ manager: CLLocationManager,
    didChangeAuthorization status: CLAuthorizationStatus
  ) {
    guard status == .authorizedWhenInUse else {
      return
    }

      locationManager.requestLocation()
      mapPreview.isMyLocationEnabled = true
      mapPreview.settings.myLocationButton = true
  }

  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }

        mapPreview.camera = GMSCameraPosition(
            target: location.coordinate,
            zoom: 15,
            bearing: 0,
            viewingAngle: 0)
  }

  func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error
  ) {
      print(error)
  }
}


// MARK: - GMSMapViewDelegate
extension ViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
    }


}
