//
//  GeoViewModel.swift
//  MapsApp
//
//  Created by Kwikku Nusantara on 23/05/23.
//

import Foundation

class GeoViewModel: ObservableObject {
    var items = [PlaceViewModel]()
    
    var onDataUpdated: (() -> Void)?
    
    init() {
//        retrieveData(q: "sasando")
    }
    
    func removeData() {
        items = []
        onDataUpdated?()
    }
    
    func retrieveData(q: String) {
        if items.count == 0 {
            Remote().getSuggestions(query: q) { i in
                guard let item = i else { return }
                self.items = item.map(PlaceViewModel.init)
                self.onDataUpdated?()
            }
        }
    }
}

struct PlaceViewModel {

    var item: Item
    
    init(item: Item) {
        self.item = item
    }
    
    var addressLabel: String {
        return item.address.label
    }
    
}
