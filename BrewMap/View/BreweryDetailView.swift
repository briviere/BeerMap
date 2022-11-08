//
//  BreweryDetailView.swift
//  BrewMap
//
//  Created by Brian Riviere on 2022-11-02.
//

import SwiftUI

struct BreweryDetailView: View {
    var brewery: Brewery
    @Environment(\.dismiss) var dismiss
    @State private var showReview = false
    @State private var showNewRestaurant = false
    
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
            }
           
            
            Text(brewery.description)
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
                    MapView(location: brewery.location)
                    .edgesIgnoringSafeArea(.all)
            ) {
                MapView(location: brewery.location)
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
