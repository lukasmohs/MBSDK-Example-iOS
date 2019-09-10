//
//  TripDetailViewController.swift
//  MBMobileExample
//
//  Created by Lukas Mohs on 10.09.19.
//  Copyright © 2019 Daimler AG. All rights reserved.
//

import Foundation
import UIKit
import SwiftChart
import MapKit

class TripDetailViewController: UIViewController, MKMapViewDelegate {
    
    var trip: Trip?

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var chartView: Chart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationItem.title = "Trip Details"
        mapView.delegate = self
        setUpChart()
        drawPolyline()
    }
    
    func setUpChart() {

        let series = ChartSeries([0, 6.5, 2, 8, 4.1, 7, -3.1, 10, 8,  4.1, 7, -3.1, 10, 8,  4.1, 7, -3.1, 10, 8,  4.1, 7, -3.1, 10, 8,  4.1, 7, -3.1, 10, 8,  4.1, 7, -3.1, 10, 8,  4.1, 7, -3.1, 10, 8])
         series.color = ChartColors.greenColor()
        chartView.add(series)
        
    }
    
    func drawPolyline() {
        let point1 = CLLocationCoordinate2DMake(50.115282, 8.651516)
        let point2 = CLLocationCoordinate2DMake(50.115359, 8.650476)
        let point3 = CLLocationCoordinate2DMake(50.117538, 8.653677)
        let point4 = CLLocationCoordinate2DMake(50.120384, 8.659118)
        let point5 = CLLocationCoordinate2DMake(50.120384, 8.659118)
        
        let points: [CLLocationCoordinate2D]
        points = [point1, point2, point3, point4, point5]
        
        let geodesic = MKGeodesicPolyline(coordinates: points, count: 5)
        mapView.addOverlay(geodesic)
        
        UIView.animate(withDuration: 1.5, animations: { () -> Void in
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region1 = MKCoordinateRegion(center: point1, span: span)
            self.mapView.setRegion(region1, animated: true)
        })
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // Make sure we are rendering a polyline.
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        // Create a specialized polyline renderer and set the polyline properties.
        let polylineRenderer = MKPolylineRenderer(overlay: polyline)
        polylineRenderer.strokeColor = .green
        polylineRenderer.lineWidth = 3
        return polylineRenderer
    }
}
