//
//  BreweryListView.swift
//  BrewMap
//
//  Created by Brian Riviere on 2022-11-02.
//

import SwiftUI

struct BreweryListView: View {
    @FetchRequest(
        entity: Brewery.entity(),
        sortDescriptors: [])
    
    var brewerys: FetchedResults<Brewery>
    
    @State private var showNewBrewery = false
    
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        NavigationView {
            List {
                if brewerys.count == 0 {
                    Image("emptydata")
                        .resizable()
                        .scaledToFit()
                } else {
                    ForEach(brewerys.indices, id: \.self) { index in
                        ZStack(alignment: .leading) {
                            NavigationLink(destination: BreweryDetailView(brewery: brewerys[index])) {
                                EmptyView()
                            }
                            .opacity(0)
                            
                            BasicTextImageRow(brewery: brewerys[index])
                        }
                    }
                    .onDelete(perform: deleteRecord)
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .navigationTitle("BrewMap")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                Button(action: {
                    self.showNewBrewery = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .accentColor(.primary)
        .sheet(isPresented: $showNewBrewery) {
            NewBreweryView()
        }
       
    }
    
    private func deleteRecord(indexSet: IndexSet) {
        for index in indexSet {
            let itemToDelete = brewerys[index]
            context.delete(itemToDelete)
        }
        DispatchQueue.main.async {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - BasicTextImageRow

struct BasicTextImageRow: View {
    
    // MARK: - Binding

    @ObservedObject var brewery: Brewery
    
    // MARK: - State variables
    
    @State private var showOptions = false
    @State private var showError = false
    
    // MARK: - View body
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            if let imageData = brewery.image {
                Image(uiImage: UIImage(data: imageData) ?? UIImage())
                    .resizable()
                    .frame(width: 120, height: 118)
                    .cornerRadius(20)
            }
            
            VStack(alignment: .leading) {
                Text(brewery.name)
                    .font(.system(.title2, design: .rounded))
                
                Text(brewery.type)
                    .font(.system(.body, design: .rounded))
                
                Text(brewery.location)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.gray)
            }
            
            if brewery.isFavorite {
                Spacer()
                
                Image(systemName: "heart.fill")
                    .foregroundColor(.yellow)
            }
        }
        .contextMenu {
            Button(action: {
                self.showError.toggle()
            }) {
                HStack {
                    Text("Reserve a table")
                    Image(systemName: "phone")
                }
            }
            Button(action: {
                self.brewery.isFavorite.toggle()
            }) {
                HStack {
                    Text(brewery.isFavorite ? "Remove from favorites" : "Mark as favorite")
                    Image(systemName: "heart")
                }
            }
            Button(action: {
                self.showOptions.toggle()
            }) {
                HStack {
                    Text("Share")
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Not yet available"),
                  message: Text("Sorry, this feature is not available yet. Please retry later."),
                  primaryButton: .default(Text("OK")),
                  secondaryButton: .cancel())
        }
        .sheet(isPresented: $showOptions) {
            let defaultText = "Just checking in at \(brewery.name)"
            
            if let imageData = brewery.image,
               let imageToShare = UIImage(data: imageData) {
                ActivityView(activityItems: [defaultText, imageToShare])
            } else {
                ActivityView(activityItems: [defaultText])
            }
        }
    }
}

struct FullImageRow: View {
    
    var imageName: String
    var name: String
    var type: String
    var location: String
    
    @Binding var isFavorite: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .cornerRadius(20)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.system(.title2, design: .rounded))
                        
                    Text(type)
                        .font(.system(.body, design: .rounded))
                    
                    Text(location)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.gray)
                }
                
                if isFavorite {
                    Spacer()
                    
                    Image(systemName: "heart.fill")
                        .foregroundColor(.yellow)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            
        }
    }
}


struct RestaurantListView_Previews: PreviewProvider {
    static var previews: some View {
        BreweryListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        BreweryListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .preferredColorScheme(.dark)
        BasicTextImageRow(brewery: (PersistenceController.testData?.first)!)
            .previewLayout(.sizeThatFits)
        FullImageRow(imageName: "cafedeadend", name: "Cafe Deadend", type:
                        "Cafe", location: "Hong Kong", isFavorite: .constant(true))
        .previewLayout(.sizeThatFits)
    }
}

