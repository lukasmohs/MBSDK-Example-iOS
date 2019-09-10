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
    @IBOutlet weak var gradientView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationItem.title = "Trip Details"
        mapView.delegate = self
        if let tripData = trip?.tripData {
            drawPolyline(dataPoints: tripData)
            setUpChart(dataPoints: tripData)
        }
        addGradientView()
    }
    
    func setUpChart(dataPoints: [DataPoint]) {

        var const: [Double] = []
        var freeWhl: [Double] = []
        var bonusRange: [Double] = []
        var accel: [Double] = []
        var total:[Double] = []
        
        for dataPoint in dataPoints {
            const.append(Double(dataPoint.ecoScore.const))
            freeWhl.append(Double(dataPoint.ecoScore.freeWhl))
            bonusRange.append(dataPoint.ecoScore.bonusRange)
            accel.append(Double(dataPoint.ecoScore.accel))
            total.append(Double(dataPoint.ecoScore.total))
        }
        
        let constDeries = ChartSeries(const)
        constDeries.color = ChartColors.greenColor()
        chartView.add(constDeries)
        
        let freeWhlDeries = ChartSeries(freeWhl)
        freeWhlDeries.color = ChartColors.blueColor()
        chartView.add(freeWhlDeries)
        
        let bonusRangeDeries = ChartSeries(bonusRange)
        bonusRangeDeries.color = ChartColors.yellowColor()
        chartView.add(bonusRangeDeries)
        
        let accelDeries = ChartSeries(accel)
        accelDeries.color = ChartColors.yellowColor()
        chartView.add(accelDeries)
        
        let totalDeries = ChartSeries(total)
        totalDeries.color = ChartColors.redColor()
        chartView.add(totalDeries)
    }
    
    func addGradientView() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [UIColor.Ridebee.BestGreen, UIColor.Ridebee.BadGreen]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func drawPolyline(dataPoints: [DataPoint]) {
        for i in 0...dataPoints.count {
            if i > 0 && i < (dataPoints.count - 1) {
                addPolyline(firstDataPoint: dataPoints[i], secondDataPoint: dataPoints[i-1])
            }
        }
        if let latitude = dataPoints.first?.location.latitude, let longitude = dataPoints.first?.location.longitude {
            let point1 = CLLocationCoordinate2DMake(latitude, longitude)
            
            UIView.animate(withDuration: 1.5, animations: { () -> Void in
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region1 = MKCoordinateRegion(center: point1, span: span)
                self.mapView.setRegion(region1, animated: true)
            })
        }
        
    }
        
        
    func addPolyline(firstDataPoint: DataPoint, secondDataPoint: DataPoint) {
        let point1 = CLLocationCoordinate2DMake(firstDataPoint.location.latitude, firstDataPoint.location.longitude)
        let point2 = CLLocationCoordinate2DMake(secondDataPoint.location.latitude, secondDataPoint.location.longitude)
        
        let points: [CLLocationCoordinate2D]
        points = [point1, point2]
        
        let geodesic = MKGeodesicPolyline(coordinates: points, count: 2)
        mapView.addOverlay(geodesic)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // Make sure we are rendering a polyline.
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
    
        // Create a specialized polyline renderer and set the polyline properties.
        let polylineRenderer = MKPolylineRenderer(overlay: polyline)
        
        if let ecoScore = self.trip?.tripData.first(where: {$0.location.latitude  == polyline.points()[1].coordinate.latitude && $0.location.longitude  == polyline.points()[1].coordinate.longitude})?.ecoScore.total {
            polylineRenderer.strokeColor = getColorForEcoScore(score: ecoScore)
        } else {
            polylineRenderer.strokeColor = UIColor.black
        }
        
        polylineRenderer.lineWidth = 3
        return polylineRenderer
    }
    
    func getColorForEcoScore(score: Int) -> UIColor{
        let percentage: Double = Double(score / 2) / 100 + 50
        return UIColor(red: 0, green: CGFloat(percentage), blue: 0, alpha: 1)
    }
}
