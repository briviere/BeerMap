//
//  ReviewView.swift
//  BrewMap
//
//  Created by Brian Riviere on 2022-11-05.
//

import SwiftUI

struct ReviewView: View {
    
    var brewery: Brewery
    @Binding var isDisplayed: Bool
    
    @State private var showRatings = false
    
    var body: some View {
        ZStack {
            Image(uiImage: UIImage(data: brewery.image)!)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity)
                .ignoresSafeArea()
            Color.black
                .opacity(0.6)
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
            
            HStack {
                Spacer()
                
                VStack {
                    Button(action: {
                        withAnimation(.easeOut(duration: 0.3)) {
                            self.isDisplayed = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 30.0))
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                }
            }
            
            VStack(alignment: .leading) {
                ForEach(Brewery.Rating.allCases, id: \.self) { rating in
                    HStack {
                        Image(rating.image)
                        Text(rating.rawValue.capitalized)
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .opacity(showRatings ? 1.0 : 0)
                    .offset(x: showRatings ? 0 : 1000)
                    .animation(.easeOut, value: showRatings)
                    .onTapGesture {
                        self.brewery.rating = rating
                        self.isDisplayed = false
                    }
                }
            }
        }
        .onAppear {
        showRatings.toggle()
        }
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView(brewery: (PersistenceController.testData?.first)!, isDisplayed: .constant(true))
    }
}

