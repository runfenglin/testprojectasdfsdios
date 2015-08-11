//
//  TripDetailsViewController.swift
//  TURides
//
//  Created by Dennis Hui on 13/06/15.
//
//

import UIKit
import MapKit

class TripDetailsViewController: BaseViewController, AcceptTripServiceDelegate, GooglePlaceDetailsServiceDelegate, MKMapViewDelegate {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tripDetailsLabel: UILabel!
    @IBOutlet var acceptButton: TUPrimaryButton!
    @IBOutlet var changeButton: TUSecondaryButton!
    
    @IBOutlet var mapView: MKMapView!
    var geocoder:CLGeocoder = CLGeocoder()
    var from:CLLocation?;
    var to:CLLocation?;
    var locMark:MKPlacemark?
    var destMark:MKPlacemark?
    var manager:CLLocationManager = CLLocationManager()
    var source:MKMapItem?
    var destination:MKMapItem?
    var request:MKDirectionsRequest = MKDirectionsRequest()
    var directions:MKDirections = MKDirections()
    var directionsResponse:MKDirectionsResponse = MKDirectionsResponse()
    var route:MKRoute = MKRoute()
    var trip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        
        userNameLabel.text = trip?.orgnizer.name
        userImageView.image = trip?.orgnizer.profileIcon
        var label = "From: \(trip!.departure.name)\nTo: \(trip!.destination.name)\nPick up time: \(UIUtil.formatDate(trip!.departureTime))"
        tripDetailsLabel.text = label
        
        GooglePlaceDetailsService(delegate: self).dispatch(trip!.departure.id)
        
        if trip?.orgnizer.id == Session.sharedInstance.me?.id || trip?.driver?.id == Session.sharedInstance.me?.id {
            acceptButton.hidden = true
            changeButton.hidden = true
        }
    }
    
    
    func drawDirection() {
        manager.requestAlwaysAuthorization()
        mapView.delegate = self
       // mapView.mapType = MKMapType.Satellite

        locMark = MKPlacemark(coordinate: CLLocationCoordinate2DMake(from!.coordinate.latitude, from!.coordinate.longitude), addressDictionary: nil)
        destMark = MKPlacemark(coordinate: CLLocationCoordinate2DMake(to!.coordinate.latitude, to!.coordinate.longitude), addressDictionary: nil)

        source = MKMapItem(placemark: locMark)
        destination = MKMapItem(placemark: destMark)

        request.setSource(source)
        request.setDestination(destination)
        request.transportType = MKDirectionsTransportType.Automobile
        //request.requestsAlternateRoutes = true
    
        
        let fromMark = TUAnnotation(title: trip!.departure.name, subTitle: trip!.departure.address, type: TUAnnotationType.Departure, coordinate: CLLocationCoordinate2DMake(from!.coordinate.latitude, from!.coordinate.longitude))
        
        let toMark = TUAnnotation(title: trip!.destination.name, subTitle: trip!.destination.address, type: TUAnnotationType.Destination, coordinate: CLLocationCoordinate2DMake(to!.coordinate.latitude, to!.coordinate.longitude))
    
        mapView.addAnnotation(fromMark)
        mapView.addAnnotation(toMark)
        
                directions = MKDirections(request: request)
        
                directions.calculateDirectionsWithCompletionHandler { (response:MKDirectionsResponse?, error:NSError?) -> Void in
        
                    if error == nil {
                        self.directionsResponse = response!
        
                        let a = response!.routes.count
                        let b = response!.routes
                        self.route = self.directionsResponse.routes[0] as! MKRoute
        
                        for var i=0;i < response!.routes.count; i++ {
                            let route: MKRoute = response!.routes[i] as! MKRoute
                            self.mapView.addOverlay(route.polyline)
                            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsetsMake(50.0, 50.0, 50.0, 50.0), animated: true)
                        }
                        
                    } else {
                        println(error)
                    }
                }
    }
    
    @IBAction func acceptButtonTouched(sender: AnyObject) {
        let params = NSMutableDictionary()
        params.setValue(trip?.tripID, forKey: "trip")
        let service = AcceptTripService(delegate: self)
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        service.dispathWithParams(params)
    }
    
    func mapView(mapView: MKMapView!,
        viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
            if let annotation = annotation as? TUAnnotation {
                let identifier = "pin"
                var view: MKPinAnnotationView
                if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                    as? MKPinAnnotationView { // 2
                        dequeuedView.annotation = annotation
                        view = dequeuedView
                } else {
                    // 3
                    view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    view.canShowCallout = true
                    view.calloutOffset = CGPoint(x: -5, y: 5)
                    UIView(frame: CGRectMake(0, 0, 0, 0))
                    let button1 = UIButton.buttonWithType(UIButtonType.System) as! UIButton
                    button1.setTitle("Start", forState: UIControlState.Normal)
                    button1.frame = CGRectMake(0, 0, 50, 30)
                    view.rightCalloutAccessoryView = button1 as UIView
                }
                
                view.pinColor = annotation.pinColor()
                
                return view
            }
            return nil
    }

    
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if overlay.isKindOfClass(MKPolyline) {
            let route = overlay as! MKPolyline
            let routeRenderer = MKPolylineRenderer(polyline: route)
            routeRenderer.strokeColor = UIColor(netHex: 0x4EAD1D)
            routeRenderer.lineWidth = 5.0
            return routeRenderer
        } else {
            return nil
        }
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let location = view.annotation as! TUAnnotation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMapsWithLaunchOptions(launchOptions)
    }
    
    func handleAcceptTripSuccess() {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    
    func handleAcceptTripFail() {
        
    }
    
    func handleGooglePlaceDetailsSuccess(location: CLLocation) {
        if from == nil {
            from = location
            GooglePlaceDetailsService(delegate: self).dispatch(trip!.destination.id)
        } else {
            to = location
            let fromPin = MKPointAnnotation()
            let toPin = MKPointAnnotation()
            fromPin.coordinate = from!.coordinate
            toPin.coordinate = to!.coordinate
            mapView.addAnnotation(toPin)
            mapView.addAnnotation(toPin)
            drawDirection()
        }
    }
}
