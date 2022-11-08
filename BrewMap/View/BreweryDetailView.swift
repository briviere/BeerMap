//
//  BreweryDetailView.swift
//  BrewMap
//
//  Created by Brian Riviere on 2022-11-02.
//

import SwiftUI
import GoogleMaps

struct BreweryDetailView: View {
    @ObservedObject var brewery: Brewery
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showReview = false
    @State private var showNewRestaurant = false
    
    @State var zoomInCenter: Bool = false
    @State var expandList: Bool = false
    @State var selectedMarker: GMSMarker?
    @State var yDragTranslation: CGFloat = 0
    
    static let cities = [
      City(name: "San Francisco", coordinate: CLLocationCoordinate2D(latitude: 37.7576, longitude: -122.4194)),
      City(name: "Seattle", coordinate: CLLocationCoordinate2D(latitude: 47.6131742, longitude: -122.4824903)),
      City(name: "Singapore", coordinate: CLLocationCoordinate2D(latitude: 1.3440852, longitude: 103.6836164)),
      City(name: "Sydney", coordinate: CLLocationCoordinate2D(latitude: -33.8473552, longitude: 150.6511076)),
      City(name: "Tokyo", coordinate: CLLocationCoordinate2D(latitude: 35.6684411, longitude: 139.6004407))
    ]
    
    /// State for markers displayed on the map for each city in `cities`
    @State var markers: [GMSMarker] = cities.map {
      let marker = GMSMarker(position: $0.coordinate)
      marker.title = $0.name
      return marker
    }
    
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        ScrollView {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Image(uiImage: UIImage(data: brewery.image)!)
                        .resizable()
                        .scaledToFill()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 445)
                }
                .overlay {
                    VStack {
                        Image(systemName: brewery.isFavorite ? "heart.fill" : "heart")
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topTrailing)
                            .padding()
                            .font(.system(size: 30))
                            .foregroundColor(brewery.isFavorite ? .yellow : .white)
                            .padding(.top, 40)
                        
                        HStack(alignment: .bottom) {
                            VStack(alignment: .leading) {
                                Text(brewery.name)
                                    .font(.custom("Nunito-Regular", size: 35, relativeTo: .largeTitle))
                                    .bold()
                                Text(brewery.type)
                                    .font(.system(.headline, design: .rounded))
                                    .padding(.all, 5)
                                    .background(Color.black)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottomLeading)
                            .foregroundColor(.white)
                            .padding()
                            
                            if let rating = brewery.rating, !showReview {
                                Image(rating.image)
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .padding([.bottom, .trailing])
                                    .transition(.scale)
                            }
                        }
                        .animation(.spring(response: 0.2, dampingFraction: 0.3, blendDuration: 0.3), value: brewery.rating)
                    }

                }
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("\(Image(systemName: "chevron.left"))"
                            )
                        }
                    }
                }
                .onChange(of: brewery) { _ in
                    if self.context.hasChanges {
                        try? self.context.save()
                    }
                }
            }
           
            
            Text(brewery.summary)
            .padding()
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("ADDRESS")
                        .font(.system(.headline, design: .rounded))
                    Text(brewery.location)
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                VStack(alignment: .leading) {
                    Text("PHONE")
                        .font(.system(.headline, design: .rounded))
                    Text(brewery.phone)
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
            
            NavigationLink(
                destination:
                    //MapView(location: brewery.location)
                MapContainerView(zoomInCenter: $zoomInCenter, markers: $markers, selectedMarker: $selectedMarker, location: $brewery.location)
                    .edgesIgnoringSafeArea(.all)
            ) {
//                MapView(location: brewery.location)
//                    .frame(minWidth: 0, maxWidth: .infinity)
//                    .frame(height: 200)
//                    .cornerRadius(20)
//                    .padding()
                
                   
                  MapContainerView(zoomInCenter: $zoomInCenter, markers: $markers, selectedMarker: $selectedMarker, location: $brewery.location)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 200)
                    .cornerRadius(20)
                    .padding()
            }
            
            Button(action: {
                self.showReview.toggle()
            }) {
                Text("Rate it")
                    .font(.system(.headline, design: .rounded))
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
            .tint(Color("NavigationBarTitle"))
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 25))
            .controlSize(.large)
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .ignoresSafeArea()
        .overlay(
            self.showReview ?
            ZStack {
                ReviewView(brewery: brewery, isDisplayed: $showReview)
                    .navigationBarHidden(true)
            }
            : nil
        )
    }
    
    struct MapContainerView: View {

      
      @Binding var zoomInCenter: Bool
      @Binding var markers: [GMSMarker]
      @Binding var selectedMarker: GMSMarker?
      @Binding var location: String

      var body: some View {
        GeometryReader { geometry in
            
          let diameter = zoomInCenter ? geometry.size.width : (geometry.size.height * 2)
                  
          MapViewControllerBridge(markers: $markers, selectedMarker: $selectedMarker, onAnimationEnded: {
                      self.zoomInCenter = true
          }, mapViewWillMove: { (isGesture) in
              guard isGesture else { return }
              self.zoomInCenter = false
            })
          .clipShape(
            Circle()
              .size(
                width: diameter,
                height: diameter
              )
              .offset(
                CGPoint(
                  x: (geometry.size.width - diameter) / 2,
                  y: (geometry.size.height - diameter) / 2
                )
              )
          )
          .animation(.easeIn)
          .background(Color(red: 254.0/255.0, green: 1, blue: 220.0/255.0))
          .task {
              getLatLngForAddress(address: location)
          }
        }
      }
        
      func getLatLngForAddress(address: String) {
            let formattedAddress = address.replacingOccurrences(of: " ", with: "+")
            
            //https://maps.googleapis.com/maps/api/geocode/json?address=G/F,%2072%20Po%20Hing%20Fong,%20Sheung%20Wan,%20Hong%20Kong&key=AIzaSyBz8MnayGs3g95WbIF6DqhVq0Fi5bw1_QM
            let url = URL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=\(formattedAddress)&key=\(apiKey)")
            let data = try! Data(contentsOf: url!)
            let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
            if let result = json["results"] as? [[String: Any]] {
                if let geometry = result[0]["geometry"] as? [String: Any] {
                    if let location = geometry["location"] as? [String: Any] {
                        let latitude = location["lat"] as! NSNumber
                        let longitude = location["lng"] as! NSNumber
                        print("\nlatitude: \(latitude), longitude: \(longitude)")
                        selectedMarker = GMSMarker(position: CLLocationCoordinate2D(latitude:  CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude)))
                        
                    }
                }
            }
        }
    }
}

struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BreweryDetailView(brewery: (PersistenceController.testData?.first)!)
            .environment(\.managedObjectContext, PersistenceController
                .preview.container.viewContext)
        }
        .accentColor(.white)
    }
}
