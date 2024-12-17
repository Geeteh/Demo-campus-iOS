//
//  SUProfileView.swift
//  Campus
//
//  Created by Drake Geeteh on 2/29/24.
//

import Foundation
import SwiftUI

struct SUProfileView: View {
    
    let username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    let userId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    @State private var profileImage: UIImage?
    @State private var activities: [Activity] = []
    @State private var bio: String = ""
    
    var columns: [GridItem] = [
            GridItem(.adaptive(minimum: 100), spacing: 16)
        ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                // Profile Header
                if (username != "") {
                    Text("Hello, " + username + "!")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                } else {
                    Text("Hello!")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                }
                
                Text("Welcome to your profile")
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                // Profile Picture
                GroupBox {
                    VStack(alignment: .leading) {
                        HStack {
                            VStack {
                                
                                if let image = profileImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 45, height: 45)
                                        .overlay(
                                            Circle().stroke(Color.white, lineWidth: 1)
                                        )
                                        .clipShape(Circle())
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
                                
                                Text("@" + username)
                                    .font(.headline)
                                    
                                
                            }
                            
                            //EmptySpacer(padding:0)
                            Divider()
                            Text(bio)
                            
                        }
                        
                        Divider()
                        
                        NavigationLink(destination: EditProfileView()) {
                            Text("Edit Profile")
                                .font(.body)
                                .fontWeight(.medium)
                                .padding()
                                .background(.black)
                                .cornerRadius(8)

                        }
                        .frame(maxWidth:.infinity)
                        
                    }
                    
                }
                .frame(maxWidth: .infinity)
                
               
                
                // Activities Section
                Text("Your Posts")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    //.padding(.top, 16)
                
               
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(activities, id: \.id) { activity in
                        NavigationLink(destination: ActivityDetailView(activity: activity)) {
                            if let imageData = Data(base64Encoded: activity.picture),
                               let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(8)
                                    .clipped()
                            } else {
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding(.horizontal, 10)
               
                
                
            }
            .onAppear {
                fetchActivities()
                fetchProfilePicture()
                fetchUserBio()
            }
            .padding()
        }
        .navigationTitle("Profile")
        .navigationBarItems(trailing:
            NavigationLink(destination: SettingsView()) {
                Image(systemName: "gear")
            }
        )
    }
    
    func loadUserProfilePicture(_ userProfilePicture: String?) -> UIImage? {
        guard let userProfilePicture = userProfilePicture,
              let imageData = Data(base64Encoded: userProfilePicture),
              let uiImage = UIImage(data: imageData) else {
            return nil
        }
        return uiImage
    }
    
    func fetchUserBio() {
            guard let url = URL(string: "http://localhost:3000/api/users/\(userId)/bio") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let userBio = json["bio"] as? String {
                        DispatchQueue.main.async {
                            self.bio = userBio
                        }
                    } else {
                        print("Invalid or missing 'bio' field in JSON response")
                    }
                } catch {
                    print("Error parsing JSON response: \(error.localizedDescription)")
                }
            }.resume()
        }
    
    func fetchProfilePicture() {
        guard let url = URL(string: "http://localhost:3000/api/users/\(userId)/profile-picture") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Status code: \(httpResponse.statusCode)")
            }
            
            /*
             print("Received data size: \(data.count) bytes")
            print("Data received: \(String(describing: String(data: data, encoding: .utf8)))")
            */
            do {
                // Attempt to decode JSON response
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    
                    if let profilePictureString = json["profilePicture"] as? String,
                       let imageData = Data(base64Encoded: profilePictureString),
                       let profileImage = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.profileImage = profileImage
                            //print("Profile image set successfully")
                        }
                    } else {
                        //print("Invalid or missing 'profilePicture' field in JSON response")
                    }
                } else {
                   // Fallback case
                    if let profileImage = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.profileImage = profileImage
                            print("Profile image set successfully")
                        }
                    } else {
                        print("Invalid data received for profile picture")
                        //print("Data description: \(String(describing: String(data: data, encoding: .utf8)))")
                    }
                }
            } catch {
                print("Error parsing JSON response: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func fetchActivities() {
        guard let url = URL(string: "http://localhost:3000/api/users/\(userId)/activities") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let activities = try JSONDecoder().decode([Activity].self, from: data)
                DispatchQueue.main.async {
                    self.activities = activities
                }
            } catch {
                print("Error decoding activities: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings View")
            .navigationTitle("Settings")
    }
}


struct ActivityDetailView: View {
    var activity: Activity

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let imageData = Data(base64Encoded: activity.picture),
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8)
                        .clipped()
                }
                
                Text(activity.content)
                    .font(.body)
                    .padding()
                
                Spacer()
                
                // Delete Button
                Button(action: {
                    deleteActivity()
                }) {
                    Text("Delete Post")
                        .padding()
                        .background(Color.black)
                        .cornerRadius(8)
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle(activity.user)
    }
    
    func deleteActivity() {
        guard let url = URL(string: "http://localhost:3000/api/activities/\(activity.id)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                //print("Delete Activity Response Status code: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    // Handle successful deletion (e.g., navigate back to the previous view or refresh the list of activities)
                    DispatchQueue.main.async {
                        // Go back to previous view or handle UI update
                    }
                }
            }
        }.resume()
    }
}


struct EditProfileView: View {
    @State private var newUsername: String = ""
    @State private var newBio: String = ""
    @State private var newProfileImage: UIImage? = nil
    @State private var isImagePickerPresented: Bool = false
    let username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    let userId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    @Environment(\.presentationMode) var presentationMode

    
    var body: some View {
        Form {
            Section(header: Text("Profile Picture")) {
                if let image = newProfileImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .onTapGesture {
                            isImagePickerPresented = true
                        }
                } else {
                    Button("Select Profile Picture") {
                        isImagePickerPresented = true
                    }
                }
            }
            
            Section(header: Text("Username")) {
                TextField("Username", text: $newUsername)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Section(header: Text("Bio")) {
                TextField("Bio", text: $newBio)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Button("Save") {
                saveProfileChanges()
            }
        }
        .navigationTitle("Edit Profile")
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $newProfileImage)
        }
    }
    
    func saveProfileChanges() {
        // Ensure userId is valid
        guard !userId.isEmpty else { return }
        
        // Create dispatch group to handle multiple requests
        let dispatchGroup = DispatchGroup()
        
        // Update bio
        if !newBio.isEmpty {
            dispatchGroup.enter()
            updateBio(newBio) {
                dispatchGroup.leave()
            }
        }
        
        if let profileImage = newProfileImage, let imageData = profileImage.jpegData(compressionQuality: 0.8) {
            let base64Image = imageData.base64EncodedString()
            dispatchGroup.enter()
            updateProfilePicture(base64Image) {
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.presentationMode.wrappedValue.dismiss()
        }
    }

    func updateBio(_ bio: String, completion: @escaping () -> Void) {
        guard let url = URL(string: "http://localhost:3000/api/users/\(userId)/bio") else {
            print("Invalid URL")
            completion()
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["bio": bio]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error updating bio: \(error.localizedDescription)")
            } else if let response = response as? HTTPURLResponse {
                print("Bio update response code: \(response.statusCode)")
            }
            completion()
        }.resume()
    }

    func updateProfilePicture(_ profilePicture: String, completion: @escaping () -> Void) {
        guard let url = URL(string: "http://localhost:3000/api/users/\(userId)/profile-picture") else {
            print("Invalid URL")
            completion()
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["profilePicture": profilePicture]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error updating profile picture: \(error.localizedDescription)")
            } else if let response = response as? HTTPURLResponse {
                print("Profile picture update response code: \(response.statusCode)")
            }
            completion()
        }.resume()
    }
}

struct AcademicsView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(specialUser:true)
    }
}
