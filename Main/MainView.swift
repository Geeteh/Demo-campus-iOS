//
//  MainView.swift
//  Campus
//
//  Created by Drake Geeteh on 2/11/24.
//

import Foundation
import SwiftUI

struct MainView: View {
    @State private var isSpecialUser = UserDefaults.standard.bool(forKey: "isVerified")
    @State private var isSignedIn: Bool = false
    
    var body: some View {
        TabView {
            if isSignedIn {
                SignedForYouView(isSignedIn: $isSignedIn)
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("For You")
                    }
            } else {
                ForYouView(isSignedIn: $isSignedIn)
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("For You")
                    }
            }
            
            if isSignedIn {
                AcademicsView(isSignedIn: $isSignedIn)
                    .tabItem {
                        Image(systemName: "building.columns.fill")
                        Text("Academics")
                    }
            } else {
                UnsignedAcademicView(isSignedIn: $isSignedIn)
                    .tabItem {
                        Image(systemName: "building.columns.fill")
                        Text("Academics")
                    }
            }
            
            FeedView(specialUser: isSpecialUser)
                .tabItem {
                    Image(systemName: "newspaper")
                    Text("Feed")
                }
            
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
            
            ResourcesView()
                .tabItem {
                    Image(systemName: "doc.text.magnifyingglass")
                    Text("Resources")
                }
        }
        .colorScheme(.dark)
        .accentColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
        .onAppear {
            self.isSignedIn = UserDefaults.standard.bool(forKey: "isSignedIn")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isSignedIn.toggle()
                    UserDefaults.standard.set(isSignedIn, forKey: "isSignedIn")
                }) {
                    Text(isSignedIn ? "Sign Out" : "Sign In")
                        .foregroundColor(.orange)
                }
            }
        }
    }
}



