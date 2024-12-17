//
//  FeedView.swift
//  Campus
//
//  Created by Drake Geeteh on 2/28/24.
//

import Foundation
import SwiftUI

struct FeedView: View {
    
    @State private var activities: [Activity] = []
    @State private var serverDown: Bool = false
    @State private var isRefreshing: Bool = false
    
    @State private var currentPage = 1
    @State private var isLoading = false
    @State private var page: Int = 1

    @State var specialUser: Bool
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                
                if (serverDown) {
                    
                    Image("osu-primary-logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                    
                    EmptySpacer(padding:0)
                    
                    GroupBox {
                        Text("Oh no! Our server is currently offline. Check back later to load the activity feed.")
                        EmptySpacer(padding:5)
                        Text("In the meantime, check out other app features!")
                        //                    HStack {
                        //                        Image("image-set-1")
                        //                            .resizable()
                        //                            .aspectRatio(contentMode: .fit)
                        //                            .frame(maxWidth: .infinity)
                        //                    }
                    }
                    .frame(maxWidth: .infinity)
                }
            
                
                
                // Otherwise,
                VStack(alignment: .leading) {
                    Text("Browse the feed")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                
                    Text("See what OSU is up to")
                        .font(.subheadline)
                        .foregroundColor(.white)
                
                
                    ForEach(activities.indices, id: \.self) { index in
                        FeedItemView(activity: activities[index])
                            .onAppear {
                                //print(index)
                                if index == activities.count - 1 {
                                    loadMoreActivities()
                                }
                            }
                             

                    }
                }
                .padding()
                //.onAppear {
                  //  fetchActivities(page:page, limit:4)
                //}
                
                
                
                

            }
            .navigationTitle("Feed")
            .onAppear {
                fetchActivities(page:page,limit:4)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if (specialUser) {
                        HStack {
                            NavigationLink(destination: SUPostView()) {
                                Image(systemName: "square.and.pencil")
                                    .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                            }
                            
                            NavigationLink(destination: SUProfileView()) {
                                Image(systemName: "person")
                                    .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                            }
                            
                        }
                    } else {
                        HStack {
                            NavigationLink(destination: SURegisterView(specialUser: $specialUser)) {
                                Image(systemName: "key")
                                    .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                            }
                            
                        }
                    }
                    
                }
                
            }
                
            
            
        }
        .refreshable {
            fetchActivities(page:1,limit:4)
//            for index in activities.indices {
//                    activities[index].timestamp = formatTimestamp(activities[index].timestamp)
//                }
        }
        .colorScheme(.dark)
        .accentColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
        
    }
    
    func fetchActivities(page: Int = 1, limit: Int = 10) {
            guard let url = URL(string: "http://localhost:3000/api/activities?page=\(page)&limit=\(limit)") else {
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else {
                    print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode([Activity].self, from: data)
                    DispatchQueue.main.async {
                        if page == 1 {
                            self.activities = decodedResponse
                        } else {
                            self.activities.append(contentsOf: decodedResponse)
                        }
                        self.isLoading = false
                        
                        //print(decodedResponse)
                    }
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            }.resume()
        }
    
//    func refreshActivities() {
//        page = 1
//        fetchActivities(page: page, limit: 2)
//    }
        
    func loadMoreActivities() {
        print("loading page \(page)")
        isLoading = true
        page += 1
        fetchActivities(page: page, limit: 4)
    }
    
}


struct FeedItemView: View {
    let activity: Activity
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading) {
                HStack(spacing: 2) {
                    // Process user profile picture
                    if let userProfileImage = loadUserProfilePicture(activity.userProfilePicture) {
                        Image(uiImage: userProfileImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 45, height: 45)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 1)
                            )
                            .padding(.trailing, 10)
                    } else {
                        Image("osu-primary-logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .foregroundColor(.gray)
                            .frame(width: 45, height: 45)
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 1)
                            )
                            .padding(.trailing, 10)
                    }
                    
                    // User button
                    Button(action: { /* Goto user's profile */ }) {
                        Text("@" + activity.user)
                            .font(.headline)
                    }
                    .multilineTextAlignment(.leading)
                }
                
                Divider()
                
                // Display activity image if available
                if let imageData = Data(base64Encoded: activity.picture),
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(8)
                        .frame(maxHeight: 200)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(activity.user) • \(formatTimestamp(activity.timestamp))")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    if !activity.content.isEmpty {
                        Text(activity.content)
                            .font(.body)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
    }
    
    func loadUserProfilePicture(_ userProfilePicture: String?) -> UIImage? {
        guard let userProfilePicture = userProfilePicture,
              let imageData = Data(base64Encoded: userProfilePicture),
              let uiImage = UIImage(data: imageData) else {
            return nil
        }
       // print("user profile parsed")  // Debug statement
        return uiImage
    }
}

func formatTimestamp(_ timestamp: String) -> String {
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    // Convert the string timestamp to a Date object
    guard let date = dateFormatter.date(from: timestamp) else {
        print("Invalid timestamp")
        return ""
    }
    
    let currentDate = Date()
    let timeDifference = Int(currentDate.timeIntervalSince(date))
    
    // Determine the appropriate time format based on the time difference
    if timeDifference < 60 {
        return "\(timeDifference) second\(timeDifference != 1 ? "s" : "") ago"
    } else if timeDifference < 3600 {
        let minutesAgo = timeDifference / 60
        return "\(minutesAgo) minute\(minutesAgo != 1 ? "s" : "") ago"
    } else if timeDifference < 86400 {
        let hoursAgo = timeDifference / 3600
        return "\(hoursAgo) hour\(hoursAgo != 1 ? "s" : "") ago"
    } else {
        // Format the date in "MM-dd-yyyy" format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.string(from: date)
    }
}


struct Activity: Codable, Hashable {
    var id: String
    var userId: String
    var user: String
    var content: String
    var picture: String
    var timestamp: String
    var userProfilePicture: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case user, userId, content, picture, timestamp, userProfilePicture
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.user = try container.decode(String.self, forKey: .user)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.content = try container.decode(String.self, forKey: .content)
        self.picture = try container.decode(String.self, forKey: .picture)
        self.timestamp = try container.decode(String.self, forKey: .timestamp)
        self.userProfilePicture = try container.decode(String.self, forKey: .userProfilePicture)
    }
}



