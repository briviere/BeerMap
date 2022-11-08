//
//  BrewMapApp.swift
//  BrewMap
//
//  Created by Brian Riviere on 2022-11-02.
//

import SwiftUI
import GoogleMaps

@main
struct BrewMapApp: App {
   
    let persistenceController = PersistenceController.shared
    
    
    init() {
        GMSServices.provideAPIKey(apiKey)
        let navBarAppearance = UINavigationBarAppearance()
        
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle") ?? UIColor.systemRed, .font: UIFont(name: "ArialRoundedMTBold", size: 35)!]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle") ?? UIColor.systemRed, .font: UIFont(name: "ArialRoundedMTBold", size: 20)!]
        
        navBarAppearance.backgroundColor = .clear
        navBarAppearance.backgroundEffect = .none
        navBarAppearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
    }
    
    
    var body: some Scene {
        WindowGroup {
            BreweryListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
             
        }
    }
}
