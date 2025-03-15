//
//  ViewController.swift
//  Exe9
//
//  Created by Civan Metin on 2025-03-15.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locations: [CLLocationCoordinate2D] = []
    var polyline: MKPolyline?
    var polygon: MKPolygon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mapTapped(_:)))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc func mapTapped(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: mapView)
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        if let index = locations.firstIndex(where: { isClose($0, to: coordinate) }) {
            locations.remove(at: index)
        } else if locations.count < 3 {
            locations.append(coordinate)
        }
        
        updateMap()
    }
    
    func updateMap() {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            mapView.addAnnotation(annotation)
        }
        
        if locations.count == 3 {
            polyline = MKPolyline(coordinates: locations, count: locations.count)
            polygon = MKPolygon(coordinates: locations, count: locations.count)
            
            if let polyline = polyline {
                mapView.addOverlay(polyline)
            }
            if let polygon = polygon {
                mapView.addOverlay(polygon)
            }
        }
    }
    
    func isClose(_ coord1: CLLocationCoordinate2D, to coord2: CLLocationCoordinate2D) -> Bool {
        let threshold = 0.001
        return abs(coord1.latitude - coord2.latitude) < threshold && abs(coord1.longitude - coord2.longitude) < threshold
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = UIColor.green
            renderer.lineWidth = 3
            return renderer
        } else if let polygon = overlay as? MKPolygon {
            let renderer = MKPolygonRenderer(polygon: polygon)
            renderer.fillColor = UIColor.red.withAlphaComponent(0.5)
            return renderer
        }
        return MKOverlayRenderer()
    }
}

