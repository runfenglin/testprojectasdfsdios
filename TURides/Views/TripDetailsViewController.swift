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
    @IBOutlet var driverImageView: UIImageView!
    @IBOutlet var driverNameLabel: UILabel!
    
    @IBOutlet var driverIconImageView: UIImageView!
    @IBOutlet var passengerIconImageView: UIImageView!
    
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
        
        userNameLabel.text = trip!.orgnizer.name
        userImageView.image = trip?.orgnizer.profileIcon
        driverImageView.image = trip!.driver?.profileIcon
        driverNameLabel.text = "Driver: \(trip!.driver!.name)"
        
        driverIconImageView.image = driverIconImageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        driverIconImageView.tintColor = UIColor(netHex: 0x4EAD1D)
        
        passengerIconImageView.image = passengerIconImageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        passengerIconImageView.tintColor = UIColor(netHex: 0x4EAD1D)
        
        
        var label = "From: \(trip!.departure.name)\nTo: \(trip!.destination.name)\nPick up time: \(UIUtil.formatDate(trip!.departureTime))"
        tripDetailsLabel.text = label
        
        GooglePlaceDetailsService(delegate: self).dispatch(trip!.departure.id)
        
        if trip?.orgnizer.id == Session.sharedInstance.me?.id || trip?.driver?.id == Session.sharedInstance.me?.id {
            acceptButton.hidden = true
            changeButton.hidden = true
        }
    }
    
    func setUpLocalPushNoification(minutesBefore: Int) {
        
        let notificationSettings: UIUserNotificationSettings! = UIApplication.sharedApplication().currentUserNotificationSettings()
        
        //if notificationSettings.types == UIUserNotificationType.None {
            var notificationTypes: UIUserNotificationType = .Alert | .Sound
            
            var startNavigationAction = UIMutableUserNotificationAction()
            startNavigationAction.identifier = "startNavigation"
            startNavigationAction.title = "Start Navigation"
            startNavigationAction.activationMode = .Background
            startNavigationAction.destructive = false
            startNavigationAction.authenticationRequired = false
        
        var dismissAction = UIMutableUserNotificationAction()
        dismissAction.identifier = "dismiss"
        dismissAction.title = "OK"
        dismissAction.activationMode = .Background
        dismissAction.destructive = false
        dismissAction.authenticationRequired = false
        
            let actionsArray = NSArray(objects: dismissAction, startNavigationAction)
            let actionsArrayMinimal = NSArray(objects: dismissAction, startNavigationAction)

            // Specify the category related to the above actions.
            var shoppingListReminderCategory = UIMutableUserNotificationCategory()
            shoppingListReminderCategory.identifier = "shoppingListReminderCategory"
            shoppingListReminderCategory.setActions(actionsArray as [AnyObject], forContext: UIUserNotificationActionContext.Default)
            shoppingListReminderCategory.setActions(actionsArrayMinimal as [AnyObject], forContext: UIUserNotificationActionContext.Minimal)


            let categoriesForSettings = NSSet(objects: shoppingListReminderCategory)


            // Register the notification settings.
            let newNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: categoriesForSettings as Set<NSObject>)
            
            UIApplication.sharedApplication().registerUserNotificationSettings(newNotificationSettings)
            var localNotification = UILocalNotification()

            let calendar = NSCalendar.currentCalendar()
            let date = calendar.dateByAddingUnit(.CalendarUnitMinute, value: 1, toDate: NSDate(), options: nil)



            localNotification.fireDate = date
        
        if trip?.orgnizer.id == Session.sharedInstance.me?.id {
            localNotification.alertBody = "\(trip?.orgnizer.name) is going to pick you up at \(trip?.departure.name) in \(minutesBefore) minutes."
        } else {
           localNotification.alertBody = "You need to pickup \(trip!.orgnizer.name) at \(trip!.departure.name) in \(minutesBefore) minutes."
        }
        localNotification.alertAction = "Open TURide"

            localNotification.category = "shoppingListReminderCategory"

            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)

            
            
            
        //} else {
        //    var notificationTypes: UIUserNotificationType = UIUserNotificationType.Alert | UIUserNotificationType.Sound
        //}
        
        
        //
        //            if (notificationSettings.types == UIUserNotificationType.None){
        //                // Specify the notification types.
        //                var notificationTypes: UIUserNotificationType = UIUserNotificationType.Alert | UIUserNotificationType.Sound
        //
        //
        //                // Specify the notification actions.
        //                var justInformAction = UIMutableUserNotificationAction()
        //                justInformAction.identifier = "justInform"
        //                justInformAction.title = "OK, got it"
        //                justInformAction.activationMode = UIUserNotificationActivationMode.Background
        //                justInformAction.destructive = false
        //                justInformAction.authenticationRequired = false
        //
        //                var modifyListAction = UIMutableUserNotificationAction()
        //                modifyListAction.identifier = "editList"
        //                modifyListAction.title = "Edit list"
        //                modifyListAction.activationMode = UIUserNotificationActivationMode.Foreground
        //                modifyListAction.destructive = false
        //                modifyListAction.authenticationRequired = true
        //
        //                var trashAction = UIMutableUserNotificationAction()
        //                trashAction.identifier = "trashAction"
        //                trashAction.title = "Delete list"
        //                trashAction.activationMode = UIUserNotificationActivationMode.Background
        //                trashAction.destructive = true
        //                trashAction.authenticationRequired = true
        //
        //                let actionsArray = NSArray(objects: justInformAction, modifyListAction, trashAction)
        //                let actionsArrayMinimal = NSArray(objects: trashAction, modifyListAction)
        //
        //                // Specify the category related to the above actions.
        //                var shoppingListReminderCategory = UIMutableUserNotificationCategory()
        //                shoppingListReminderCategory.identifier = "shoppingListReminderCategory"
        //
        //
        //
        //
        //                shoppingListReminderCategory.setActions(actionsArray as [AnyObject], forContext: UIUserNotificationActionContext.Default)
        //                shoppingListReminderCategory.setActions(actionsArrayMinimal as [AnyObject], forContext: UIUserNotificationActionContext.Minimal)
        //
        //
        //                let categoriesForSettings = NSSet(objects: shoppingListReminderCategory)
        //
        //
        //                // Register the notification settings.
        //                let newNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: categoriesForSettings as Set<NSObject>)
        //                UIApplication.sharedApplication().registerUserNotificationSettings(newNotificationSettings)
        //            } else {
        //                var notificationTypes: UIUserNotificationType = UIUserNotificationType.Alert | UIUserNotificationType.Sound
        //
        //
        //                // Specify the notification actions.
        //                var justInformAction = UIMutableUserNotificationAction()
        //                justInformAction.identifier = "justInform"
        //                justInformAction.title = "OK, got it"
        //                justInformAction.activationMode = UIUserNotificationActivationMode.Background
        //                justInformAction.destructive = false
        //                justInformAction.authenticationRequired = false
        //
        //                var modifyListAction = UIMutableUserNotificationAction()
        //                modifyListAction.identifier = "editList"
        //                modifyListAction.title = "Edit list"
        //                modifyListAction.activationMode = UIUserNotificationActivationMode.Foreground
        //                modifyListAction.destructive = false
        //                modifyListAction.authenticationRequired = true
        //
        //                var trashAction = UIMutableUserNotificationAction()
        //                trashAction.identifier = "trashAction"
        //                trashAction.title = "Delete list"
        //                trashAction.activationMode = UIUserNotificationActivationMode.Background
        //                trashAction.destructive = true
        //                trashAction.authenticationRequired = true
        //
        //                let actionsArray = NSArray(objects: justInformAction, modifyListAction, trashAction)
        //                let actionsArrayMinimal = NSArray(objects: trashAction, modifyListAction)
        //
        //                // Specify the category related to the above actions.
        //                var shoppingListReminderCategory = UIMutableUserNotificationCategory()
        //                shoppingListReminderCategory.identifier = "shoppingListReminderCategory"
        //
        //
        //
        //
        //                shoppingListReminderCategory.setActions(actionsArray as [AnyObject], forContext: UIUserNotificationActionContext.Default)
        //                shoppingListReminderCategory.setActions(actionsArrayMinimal as [AnyObject], forContext: UIUserNotificationActionContext.Minimal)
        //
        //
        //                let categoriesForSettings = NSSet(objects: shoppingListReminderCategory)
        //
        //
        //                // Register the notification settings.
        //                let newNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: categoriesForSettings as Set<NSObject>)
        //                UIApplication.sharedApplication().registerUserNotificationSettings(newNotificationSettings)
        //                var localNotification = UILocalNotification()
        //                
        //                let calendar = NSCalendar.currentCalendar()
        //                let date = calendar.dateByAddingUnit(.CalendarUnitMinute, value: 1, toDate: NSDate(), options: nil)
        //
        //                
        //                
        //                localNotification.fireDate = date
        //                localNotification.alertBody = "Hey, you must go shopping, remember?"
        //                localNotification.alertAction = "View List"
        //                
        //                localNotification.category = "shoppingListReminderCategory"
        //                
        //                UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        //        }

    }
    
    @IBAction func reminderButtonTouched(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Reminder", message: "", preferredStyle: .Alert)
        let buttonOne = UIAlertAction(title: "5 minutes before", style: .Default, handler: { (action) -> Void in
            self.setUpLocalPushNoification(5)
        })
        let buttonTwo = UIAlertAction(title: "10 minutes before", style: .Default, handler: { (action) -> Void in
            self.setUpLocalPushNoification(10)
        })
        let buttonThree = UIAlertAction(title: "15 minutes before", style: .Default, handler: { (action) -> Void in
            self.setUpLocalPushNoification(15)
        })
        let buttonFour = UIAlertAction(title: "30 minutes before", style: .Default, handler: { (action) -> Void in
            self.setUpLocalPushNoification(30)
        })
        let buttonCancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in}
        
        alertController.addAction(buttonOne)
        alertController.addAction(buttonTwo)
        alertController.addAction(buttonThree)
        alertController.addAction(buttonFour)
        alertController.addAction(buttonCancel)
        alertController.modalPresentationStyle = UIModalPresentationStyle.Popover
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func drawDirection() {
        manager.requestAlwaysAuthorization()
        mapView.delegate = self

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
