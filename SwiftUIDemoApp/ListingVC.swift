//
//  ListingVC.swift
//  SwiftUIDemoApp
//
//  Created by Rafaiy Rehman on 12/06/24.
//

import SwiftUI

struct ListingVC: View {

    @State var searchFieldText: String = ""
    var selectedIndex: Int = 0
    var listingVM = CartoonListingVM()

    @State var listing: [Cartoon]?


    var body: some View {
        ScrollView {
            pageView
            searchTextfield
            devider
            GenreOptions
            VStack (spacing: 40) {
                if self.listing != nil {
                    showsListing
                    showsListing
                }
            }
        }
        .padding(.bottom, 50)
        .onAppear(perform: {
            Task {
                let listing = try await listingVM.downloadCartoonListing()
                self.listing = listing
                print("rar --->> \(Thread.current)")
            }
        })
        .ignoresSafeArea()
        .background(Color.black)
    }


    var pageView: some View {
        TabView {
            ForEach(0..<30) { i in
                ZStack {
                    Rectangle()
                        .cornerRadius(20)
                        .overlay {
                            Image("venom")
                                .resizable()
                        }
                }
            }
        }

        .frame(width: UIScreen.main.bounds.width, height: 200)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

    }


    var searchTextfield: some View {
        // top view
        HStack {
            Text("OPENING THIS WEEK")
                .padding(.leading, 5)
                .font(.headline)
                .foregroundStyle(Color.white)
            Spacer()

            ZStack {
                Rectangle()
                    .foregroundStyle(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                HStack {
                    TextField("Search", text: $searchFieldText)
                        .foregroundStyle(Color.gray)
                        .placeholder("search", when: searchFieldText.isEmpty)
                        .padding(.leading, 10 )
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.trailing, 5)
                }
            }
            .frame(height: 30)
            .overlay(content: {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray, lineWidth: 1)
            })
        }
        .frame(height: 50)
    }
    
    var devider: some View {
        Color.red
            .overlay(
                LinearGradient(gradient: Gradient(colors: [Color.red, Color.black]), startPoint: .leading, endPoint: .trailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.leading, 5)
            .frame(height: 3)

    }

    var GenreOptions: some View {
        ScrollView (.horizontal) {
            HStack(alignment: .center, spacing: 10, content: {
                ForEach(0...7, id: \.self) { item in
                    Button(action: {

                    }, label: {
                        Text("All films")
                            .foregroundStyle(Color.white)
                            .font(.headline)
                    })
                    .frame(width: 90, height: 35)
                    .background(selectedIndex == item ? Color.red : Color.init(uiColor: UIColor(red: 0.156, green: 0.156, blue: 0.156, alpha: 1)))
                    .cornerRadius(5)

                }
            })
            .padding(.leading, 10)
        }
        .scrollIndicators(.hidden)
        .padding(.top, 10)
    }

    var showsListing: some View {
        ScrollView(.horizontal) {
            HStack(content: {
                ForEach(listing!, id: \.self) { element in
                    VStack (alignment: .leading) {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 150, height: 250)
                            .overlay {
//                                Image("spidermanPor")
//                                    .resizable()
                                AsyncImage(url: URL(string: element.image)) { phase in
                                    switch phase {
                                    case .empty:
                                        Image("noImg")
                                            .resizable()
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .scaledToFit()
                                    case .success(let image):
                                        image.resizable()
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .scaledToFit()
                                    case .failure(_):
                                        Image("noImg")
                                            .resizable()
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .scaledToFit()
                                    @unknown default:
                                        Image("noImg")
                                            .resizable()
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .scaledToFit()

                                    }
                                }

                            }
                        Text("\(element.title)")
                            .font(.headline)
                            .foregroundStyle(Color.white)
                        HStack {
                            Text("Episodes \(element.episodes)")
                                .minimumScaleFactor(0.3)
                            Rectangle()
                                .frame(width: 2)
                            Text("\(element.genre.map{ $0.rawValue }.joined(separator: ","))")
                                .minimumScaleFactor(0.3)

                        }
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                    }.frame(maxWidth: 150)
                }
            }).padding(7)

        }
        .scrollIndicators(.hidden)
    }

    
}

#Preview {
    ListingVC()
}


extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }

    func placeholder(
        _ text: String,
        when shouldShow: Bool,
        alignment: Alignment = .leading) -> some View {

            let placeholder = placeholder(when: shouldShow, alignment: alignment) {
                Text(text).foregroundColor(.gray)
            }

            return placeholder
    }



}
