//
//  MapViewController.swift
//  SignInLogin
//
//  Created by Neeraja Sarasan on 31/08/23.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var latTextField: UITextField!
    @IBOutlet weak var longTextField: UITextField!
    var locationManager: CLLocationManager!
    
 
    
    let locationDetailsView: LocationDetailsView = {
          let view = LocationDetailsView()
          view.translatesAutoresizingMaskIntoConstraints = false
          return view
      }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
     
        mapView.delegate = self
        
      
                mapView.addSubview(locationDetailsView)
                locationDetailsView.isHidden = true

                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                mapView.addGestureRecognizer(tapGesture)
    }

    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
        
            let point = gestureRecognizer.location(in: mapView)

            let tappedCoordinate = mapView.convert(point, toCoordinateFrom: mapView)

            
            let location = CLLocation(latitude: tappedCoordinate.latitude, longitude: tappedCoordinate.longitude)
            let geocoder = CLGeocoder()
             mapView.removeAnnotations(mapView.annotations)
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                if let placemark = placemarks?.first {
   
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = tappedCoordinate
                    annotation.title = placemark.name
                    annotation.subtitle = placemark.locality
                    self?.mapView.addAnnotation(annotation)
                }
//                let annotation = MKPointAnnotation()
//                annotation.coordinate = tappedCoordinate
//                self?.mapView.addAnnotation(annotation)
            }
        }
    }


    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let coordinate = location.coordinate
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "My Location"
            mapView.addAnnotation(annotation)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        print("Location error: \(error.localizedDescription)")
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
    
    
    //    class CustomUserAnnotationView: MKAnnotationView {
    //        override var annotation: MKAnnotation? {
    //            didSet {
    //                if let annotation = annotation {
    //                    //image = UIImage(systemName: "circle.fill")?.withTintColor(.blue) 
    //                    image = UIImage(named: "bluedot")
    //                    centerOffset = CGPoint(x: 0, y: -image!.size.height / 2)
    //                }
    //            }
    //        }
    //    }SignInLogin copy    //}
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
