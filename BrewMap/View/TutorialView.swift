//
//  TutorialView.swift
//  BrewMap
//
//  Created by Brian Riviere on 2022-11-11.
//

import SwiftUI

struct TutorialView: View {
    
    @State private var currentPage = 0
    
    let pageHeadings = [ "CREATE YOUR OWN BEER GUIDE", "SHOW YOU THE LOCATION", "DISCOVER GREAT BREWERY" ]
    
    let pageSubHeadings = [ "Pin your favorite craft brewery and create your own craft beer guide", "Search and locate your favorite brewery on Maps", "Find brewery shared by your friends and other craft beer connoisseur"]
    
    let pageImages = [ "onboarding-1", "onboarding-2", "onboarding-3"]
    
    @AppStorage("hasViewedWalkthrough") var hasViewedWalkthrough: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .systemIndigo
        UIPageControl.appearance().pageIndicatorTintColor = .lightGray
    }
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(pageHeadings.indices) { index in
                    TutorialPage(image: pageImages[index], heading: pageHeadings[index],subHeading:pageSubHeadings[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .automatic))
            .animation(.default, value: currentPage)
            
            VStack(spacing: 20) {
                Button(action: {
                    if currentPage < pageHeadings.count - 1 {
                        currentPage += 1
                    } else {
                        hasViewedWalkthrough = true
                        dismiss()
                    }
                }) {
                    Text(currentPage == pageHeadings.count - 1 ? "GET STARTED" : "NEXT")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal, 50)
                        .background(Color(.systemIndigo))
                        .cornerRadius(25)
                    
                }
                if currentPage < pageHeadings.count - 1 {
                    Button(action: {
                        hasViewedWalkthrough = true
                        dismiss()
                    }) {
                        Text("Skip")
                            .font(.headline)
                            .foregroundColor(Color(.darkGray))
                    }
                }
            }
            .padding(.bottom)
            
        }
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
        TutorialPage(image: "onboarding-1", heading: "CREATE YOUR OWN CRAFT BREWERY GUIDE", subHeading: "Pin your favorite craft brewery and create your own craft beer guide")
            .previewLayout(.sizeThatFits)
    }
}
