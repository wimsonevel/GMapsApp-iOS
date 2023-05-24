//
//  MapsViewController.swift
//  MapsApp
//
//  Created by Kwikku Nusantara on 21/05/23.
//

import Foundation
import UIKit
import GoogleMaps

class MapsViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var pinImageVerticalConstraint: NSLayoutConstraint!
    
    let locationManager = CLLocationManager()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: PaddedTextField!
    
    var completionHandler: ((String) -> Void)?
    var pickedLocation: String?
    
    var viewModel: GeoViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self

        textField.delegate = self
        
        if let searchIcon = UIImage(systemName: "magnifyingglass") {
            let searchIconImageView = UIImageView(image: searchIcon)
            searchIconImageView.contentMode = .center
            
            textField.leftView = searchIconImageView
            textField.leftViewMode = .always
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()

            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
        viewModel = GeoViewModel()
        viewModel.onDataUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
        
    }
    
    func reverseGeocode(coordinate: CLLocationCoordinate2D) {
        self.addressLabel.unlock()

        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard
                let address = response?.firstResult(),
                let lines = address.lines
            else {
                return
                
            }
            
            self.pickedLocation = lines.joined(separator: "\n")
            self.addressLabel.text = self.pickedLocation
            
            let labelHeight = self.addressLabel.intrinsicContentSize.height
            let bottomInset = self.view.safeAreaInsets.bottom
            self.mapView.padding = UIEdgeInsets(
                top: labelHeight,
                left: 0,
                bottom: bottomInset,
                right: 0)

            UIView.animate(withDuration: 0.25) {
                self.pinImageVerticalConstraint.constant = (labelHeight) * 0.5
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func onPicked(_ sender: Any) {
        locationPick(pickedLocation ?? "")
    }
    
    func locationPick(_ location: String) {
        completionHandler?(location)
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - CLLocationManagerDelegate
extension MapsViewController: CLLocationManagerDelegate {
  func locationManager(
    _ manager: CLLocationManager,
    didChangeAuthorization status: CLAuthorizationStatus
  ) {
    guard status == .authorizedWhenInUse else {
      return
    }

      locationManager.requestLocation()
      mapView.isMyLocationEnabled = true
      mapView.settings.myLocationButton = false
  }

  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }

        mapView.camera = GMSCameraPosition(
            target: location.coordinate,
            zoom: 16,
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
extension MapsViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocode(coordinate: position.target)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        addressLabel.lock()
    }


}

extension MapsViewController: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    
    // Handle text field focus
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    // Handle user input in the text field
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let userInput = textField.text else {
            return
        }
        
        if userInput.count > 5 {
            tableView.isHidden = false
            viewModel.retrieveData(q: userInput)
        } else {
            tableView.isHidden = true
            viewModel.removeData()
            tableView.reloadData()
        }
    }
    
    // UITableView data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! GestureTableViewCell
        
        let item = viewModel.items[indexPath.row]
        cell.textLabel?.text = item.addressLabel
        
        cell.tapAction = {
            self.locationPick(item.addressLabel)
        }
        
        return cell
    }
}
