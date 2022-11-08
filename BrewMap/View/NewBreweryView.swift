//
//  NewBreweryView.swift
//  BrewMap
//
//  Created by Brian Riviere on 2022-11-06.
//

import SwiftUI

struct NewBreweryView: View {
    @State var breweryName = ""
    
    @State private var showPhotoOptions = false
    
    @ObservedObject private var breweryFormViewModel: BreweryFormViewModel
    
    @Environment(\.dismiss) var dismiss
    
    enum PhotoSource: Identifiable {
        case photoLibrary
        case camera
        var id: Int {
            hashValue
        }
    }
    
    @State private var photoSource: PhotoSource?
    
    init() {
        let viewModel = BreweryFormViewModel()
        viewModel.image = UIImage(named: "newphoto")!
        breweryFormViewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
                ScrollView {
                    VStack {
                        Image(uiImage: breweryFormViewModel.image)
                            .resizable()
                            .scaledToFill()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 200)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 20.0))
                            .padding(.bottom)
                            .onTapGesture {
                                self.showPhotoOptions.toggle()
                            }
                        
                        FormTextField(label: "NAME", placeholder: "Fill in the brewery name", value: $breweryFormViewModel.name)
                        FormTextField(label: "TYPE", placeholder: "Fill in the brewery type", value: $breweryFormViewModel.type)
                        FormTextField(label: "ADDRESS", placeholder: "Fill inthe brewery address", value: $breweryFormViewModel.location)
                        FormTextField(label: "PHONE", placeholder: "Fill in the brewery phone", value: $breweryFormViewModel.phone)
                        FormTextView(label: "DESCRIPTION", value: $breweryFormViewModel.description, height: 100)
                    }
                    .padding()
                }
            // Navigation bar configuration
            .navigationTitle("New Brewery")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .accentColor(.primary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(Color("NavigationBarTitle"))
                }
            }
        }
        .actionSheet(isPresented: $showPhotoOptions) {
            ActionSheet(title: Text("Choose your photo source"), message: nil,
                        buttons: [
                            .default(Text("Camera")) {
                                self.photoSource = .camera
                            },
                            .default(Text("Photo Library")) {
                                self.photoSource = .photoLibrary
                            },
                            .cancel()
                        ])
        }
        .fullScreenCover(item: $photoSource) { source in
            switch source {
            case .photoLibrary: ImagePicker(sourceType: .photoLibrary, selectedImage: $breweryFormViewModel.image).ignoresSafeArea()
            case .camera: ImagePicker(sourceType: .camera, selectedImage: $breweryFormViewModel.image).ignoresSafeArea()
            }
        }
    }
}

struct FormTextField: View {
    let label: String
    var placeholder: String = ""
    @Binding var value: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(label.uppercased())
                .font(.system(.headline, design: .rounded))
                .foregroundColor(Color(.darkGray))
            TextField(placeholder, text: $value)
                .font(.system(.body, design: .rounded))
                .textFieldStyle(PlainTextFieldStyle())
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
                .padding(.vertical, 10)
        }
    }
}

struct FormTextView: View {
    let label: String
    @Binding var value: String
    var height: CGFloat = 200.0
    var body: some View {
        VStack(alignment: .leading) {
            Text(label.uppercased())
                .font(.system(.headline, design: .rounded))
                .foregroundColor(Color(.darkGray))
            TextEditor(text: $value)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
                .padding(.top, 10)
        }
    }
}

struct NewBreweryView_Previews: PreviewProvider {
    static var previews: some View {
        NewBreweryView()
        

        
    }
}
