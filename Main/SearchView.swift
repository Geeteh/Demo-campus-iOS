//
//  SearchView.swift
//  Campus
//
//  Created by Drake Geeteh on 2/26/24.
//

import Foundation
import SwiftUI


struct SearchView: View {
    @State private var searchText = ""
    @State private var searchResults: [String] = []


    private func performSearch() {
            // Here, you would implement your logic to search from a broader data source,
            // such as an external database or API, based on the searchText
            // For the sake of this example, let's say we have some predefined additional data
        let additionalData = ["Landmark 1", "Landmark 2", "Landmark 3"]
        
            // Filter the additional data based on the search text
            // searchResults should contain an array of all searchable items
            //
        let totalData = additionalData + buildingNames
        
        searchResults = totalData.filter {
            $0.lowercased().contains(searchText.lowercased())
        }
        
    }
    
    
//    var buildings: [String] {
//        let lcBuildings = buildingNames.map { $0.lowercased() }
//        return searchText == "" ? lcBuildings : lcBuildings.filter {
//            $0.contains(searchText.lowercased())
//        }
//    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults, id: \.self) { result in
                    NavigationLink(destination: Text(result.capitalized)) {
                        Text(result.capitalized)
                    }
                }
            }
            .navigationTitle("Search")
        }
                
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search Oklahoma State App")
            .onChange(of: searchText) {
                performSearch()
            }
            .colorScheme(.dark)
            
    }
        
}

