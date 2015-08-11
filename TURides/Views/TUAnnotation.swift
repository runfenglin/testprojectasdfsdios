//
//  TUAnnotation.swift
//  TURides
//
//  Created by Dennis Hui on 11/08/15.
//
//

import UIKit
import MapKit
import AddressBook

enum TUAnnotationType {
    case Departure
    case Destination
}

class TUAnnotation: NSObject, MKAnnotation {
    let title: String
    let subTitle: String
    let type: TUAnnotationType
    let coordinate: CLLocationCoordinate2D

    var subtitle: String {
        return self.subTitle
    }
    
    init(title: String, subTitle: String, type: TUAnnotationType, coordinate: CLLocationCoordinate2D) {
        
        self.title = title
        self.subTitle = subTitle
        self.type = type
        self.coordinate = coordinate
        
        super.init()
    }
    
    func pinColor() -> MKPinAnnotationColor  {
        if type == TUAnnotationType.Departure {
            return .Green
        } else {
            return .Red
        }
    }
    
    func mapItem() -> MKMapItem {
        let placemark = MKPlacemark(coordinate: self.coordinate, addressDictionary: [String(kABPersonAddressStreetKey): self.subtitle])
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.title
        return mapItem
    }
}
