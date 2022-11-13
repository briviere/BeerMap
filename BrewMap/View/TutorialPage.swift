//
//  TutorialPage.swift
//  BrewMap
//
//  Created by Brian Riviere on 2022-11-11.
//

import SwiftUI

struct TutorialPage: View {
    let image: String
    let heading: String
    let subHeading: String
    
    var body: some View {
        VStack(spacing: 70) {
            Image(image)
                .resizable()
                .scaledToFit()
            VStack(spacing: 10) {
                Text(heading)
                    .font(.headline)
                Text(subHeading)
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            Spacer()
        }
        .padding(.top)
    }
}
