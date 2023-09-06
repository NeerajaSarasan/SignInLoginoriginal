//
//  MapViewController.swift
//  SignInLogin
//
//  Created by Neeraja Sarasan on 31/08/23.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var latTextField: UITextField!
    @IBOutlet weak var longTextField: UITextField!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocation()
        setupMapView()
    }
    
    func setupLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func setupMapView() {
        mapView.delegate = self
        mapView.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard gestureRecognizer.state == .ended else { return }
        let point = gestureRecognizer.location(in: mapView)
        let tappedCoordinate = mapView.convert(point, toCoordinateFrom: mapView)
        let location = CLLocation(latitude: tappedCoordinate.latitude, longitude: tappedCoordinate.longitude)
        mapView.removeAnnotations(mapView.annotations)
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            if let placemark = placemarks?.first {
                let annotation = MKPointAnnotation()
                annotation.coordinate = tappedCoordinate
                annotation.title = placemark.name
                annotation.subtitle = placemark.locality
                self?.mapView.addAnnotation(annotation)
            }
        }
    }
    
    
    @IBAction func showLocationButtonPressed(_ sender: UIButton) {
        guard
            let latitudeStr = latTextField.text,
            let longitudeStr = longTextField.text,
            let latitude = Double(latitudeStr),
            let longitude = Double(longitudeStr)
        else {
            
            return
        }
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Selected Location"
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = "My Location"
        mapView.addAnnotation(annotation)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseIdentifier = "Customannotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
            if annotation.title == "My Location"{
                annotationView?.pinTintColor = .blue
            }else {
                annotationView?.pinTintColor = .red
            }
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
}


class LocationDetailsView: UIView {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 8
        layer.masksToBounds = true
        addSubview(nameLabel)
        addSubview(addressLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            addressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            addressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            addressLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    func update(with placemark: CLPlacemark) {
        nameLabel.text = placemark.name
        var formattedAddress = ""
        
        if let thoroughfare = placemark.thoroughfare {
            formattedAddress += thoroughfare + ", "
        }
        
        if let locality = placemark.locality {
            formattedAddress += locality + ", "
        }
        
        if let administrativeArea = placemark.administrativeArea {
            formattedAddress += administrativeArea + " "
        }
        
        if let postalCode = placemark.postalCode {
            formattedAddress += postalCode
        }
        
        addressLabel.text = formattedAddress
    }
    
}

