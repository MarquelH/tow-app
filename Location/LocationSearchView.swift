//
//  LocationSearchView.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 3/17/22.
//

import SwiftUI
import CoreLocation
import MapKit

struct LocationSearchView: View {
    @Binding var presentedAsModal: Bool
    @Binding var txt: Bool
    @Binding var isSource: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                //SearchBar(map: self.$map, source: self.$source, destination: self.$destination, result: self.$result, name: self.$name, distance: self.$distance, time: self.$time,txt: self.$txt)
            }
            Button("dismiss") { self.presentedAsModal = false }
            
        }.navigationTitle("Location Search")
    }
}

struct SearchBar : UIViewRepresentable {
    
    @Binding var map : MKMapView
    @Binding var source : CLLocationCoordinate2D!
    @Binding var destination : CLLocationCoordinate2D!
    @Binding var result : [SearchData]
    @Binding var name : String
    @Binding var distance : String
    @Binding var time : String
    @Binding var sourceTxt : String
    
    func makeCoordinator() -> Coordinator {
        return SearchBar.Coordinator(parent1: self)
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        
        let view = UISearchBar()
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        view.delegate = context.coordinator
        
        return view
    }
    
    func updateUIView(_ uiView:  UISearchBar, context: Context) {
        
        
    }
    
    class Coordinator : NSObject,UISearchBarDelegate {
        
        var parent : SearchBar
        
        init(parent1 : SearchBar) {
            
            parent = parent1
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            print("Text changed")
            self.parent.sourceTxt = searchText
            
            let req = MKLocalSearch.Request()
            req.naturalLanguageQuery = searchText
            req.region = self.parent.map.region
            
            let search = MKLocalSearch(request: req)
            
            DispatchQueue.main.async {
                
                self.parent.result.removeAll()
            }
            
            search.start { (res, err) in
                
                if err != nil{
                    
                    print((err?.localizedDescription)!)
                    return
                }
                
                for i in 0..<res!.mapItems.count{
                    
                    let temp = SearchData(id: i, name: res!.mapItems[i].name!, address: res!.mapItems[i].placemark.title!, coordinate: res!.mapItems[i].placemark.coordinate)
                    
                    self.parent.result.append(temp)
                }
            }
        }
    }
}


struct SearchData : Identifiable {
    
    var id : Int
    var name : String
    var address : String
    var coordinate : CLLocationCoordinate2D
}
