//
//  RestaurantFormViewModel.swift
//  BrewMap
//
//  Created by Brian Riviere on 2022-11-06.
//

import Foundation
import Combine
import UIKit
class BreweryFormViewModel: ObservableObject {
    // Input
    @Published var name: String = ""
    @Published var type: String = ""
    @Published var location: String = ""
    @Published var phone: String = ""
    @Published var description: String = ""
    @Published var image: UIImage = UIImage()
    init(brewery: Brewery? = nil) {
        if let brewery = brewery {
            self.name = brewery.name
            self.type = brewery.type
            self.location = brewery.location
            self.phone = brewery.phone
            self.description = brewery.summary
            self.image = UIImage(data: brewery.image) ?? UIImage()
        }
    }
}
