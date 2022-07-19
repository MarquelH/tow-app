//
//  File.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 3/11/22.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation

// Extension for adding rounded corners to specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}

extension MKMapItem {
    
    var fullName: String {
        guard let name = name, !placemark.fullLocationAddress.contains(name) else {
            return placemark.fullLocationAddress
        }
        return (name + ", ") + placemark.fullLocationAddress
    }
    
}

extension CLPlacemark {
    
    var fullLocationAddress: String {
        // MARK: Get the same address, that could be provided by Google Places API
        // https://developers.google.com/maps/documentation/javascript/examples/places-autocomplete
        var placemarkData: [String] = []
        
        if let area = areasOfInterest?.first { placemarkData.append(area.localizedCapitalized) }
        if let street = thoroughfare?.localizedCapitalized { placemarkData.append(street) }
        if let building = subThoroughfare?.localizedCapitalized { placemarkData.append(building)}
        if let city = locality?.localizedCapitalized { placemarkData.append(city) }
        if let subCity = subLocality?.localizedCapitalized { placemarkData.append(subCity) }
        if let state = administrativeArea?.localizedCapitalized { placemarkData.append(state) }
        if let stateArea = subAdministrativeArea?.localizedCapitalized { placemarkData.append(stateArea) }
        if let county = country?.localizedCapitalized { placemarkData.append(county) }
        placemarkData.removeDuplicates()
        
        var result = ""
        
        placemarkData.forEach { result.append(" "+$0+",") }
        result = result.trimmingCharacters(in: .whitespaces)
        //result.removeLast() // remove last comma
        
        return result
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

extension View {
    func foregroundGradient() -> some View {
        overlay(
            LinearGradient(colors: [
                Color.white,
                Color.red.opacity(0.5)
            ],
            startPoint: .leading,
            endPoint: .trailing)
        )
            .mask(self)
    }
}

// Custom RoundedCorner shape used for cornerRadius extension above
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension CLLocationCoordinate2D: Codable {
     public func encode(to encoder: Encoder) throws {
         var container = encoder.unkeyedContainer()
         try container.encode(longitude)
         try container.encode(latitude)
     }
      
     public init(from decoder: Decoder) throws {
         var container = try decoder.unkeyedContainer()
         let longitude = try container.decode(CLLocationDegrees.self)
         let latitude = try container.decode(CLLocationDegrees.self)
         self.init(latitude: latitude, longitude: longitude)
     }
 }

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
}
