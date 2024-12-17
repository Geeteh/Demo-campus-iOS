//
//  TestView.swift
//  Campus
//
//  Created by Drake Geeteh on 3/3/24.
//

import Foundation
import SwiftUI

struct SURegisterView: View {
    
    @State private var SUKey: String = ""
    @State private var SUUsername: String = ""
    @State private var SUBio: String = ""
    @State private var SUPassword: String = ""
    @State private var emailBody: String = ""
    @State private var isAuthorized: Bool = false
    @State private var showAlert: Bool = false
    @State private var showUserBioField: Bool = false
    @State private var accessKeys: [AccessKey] = []
    @State private var userBioProvided: Bool = false
    @State private var showAllFieldsUnentered: Bool = false
    @State private var showUsernameFieldUnentered: Bool = false
    @State private var showPasswordFieldUnentered: Bool = false
    @State private var submissionReceived: Bool = false
    @State private var SUUsernameLogin: String = ""
    @State private var SUPasswordLogin: String = ""
    
    
    @Binding var specialUser: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if (!isAuthorized) {
                    Text("Request Access")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    
                    Text("Please answer below")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    GroupBox {
                        Text("-Who are you / Who is your organization?\n\n- What will you be posting on the OSU activity feed?\n\n- How many people do you plan to let post on the OSU activity feed?\n\n- If more than one, please mention who they are to your organization.\n\nStudent organizations, NCAA and intramural sports teams, education / safety departments, OSU help desks, OSU government bodies, and OSU services looking for campus related promotion are highly encouraged to join.")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        EmptySpacer(padding:0)
                        
                        TextField("Type your submission here.", text: $emailBody, axis: .vertical)
                            .background(Color.black.opacity(0.15))
                            .border(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                            .padding()
                                                
                        Button(action: {
                            // still face issues with email unit tests
                            EmailHelper.shared.sendEmail(subject: "[Request for Special Access]", body: emailBody, to: "drake.geeteh@okstate.edu")
                            // refactor the logic here to if email sent then true
                            submissionReceived = true
                        }) {
                            Text("Submit Request")
                                .padding()
                                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        
                        if (submissionReceived) {
                            Text("Submission received.")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    EmptySpacer(padding:0)
                    
                    Text("Special Users")
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    Text("Please sign in below")
                        .foregroundColor(.white)
                        .font(.subheadline)
                    
                    
                    GroupBox {
                        TextField("Special User Username", text: $SUUsernameLogin)
                            .padding()
                            .background(Color.black.opacity(0.15))
                            .border(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                        
                        SecureField("Special User Password", text: $SUPasswordLogin)
                            .padding()
                            .background(Color.black.opacity(0.15))
                            .border(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                        
                        EmptySpacer(padding:0)
                        
                        Button(action: { SUSignIn() }) {
                            Text("Sign in")
                                .padding()
                                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                                .font(.headline)
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                    
                    EmptySpacer(padding:0)
                    
                    Text("Have your access key?")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    
                    Text("Enter it below")
                        .font(.subheadline)
                        .foregroundColor(.white)
                                            
                    GroupBox {
                        
                        Text("Enter your special user access key provided by the developer to gain access to post to the activity feed.")
                        
                        EmptySpacer(padding:0)
                        
                        SecureField("Enter Special User Access Key", text: $SUKey)
                            .padding()
                            .background(Color.black.opacity(0.15))
                            .border(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                        
                        Button(action: { authorizeKey() }) {
                            Text("Enter")
                                .font(.headline)
                        }
                        .padding()
                        .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                        .font(.headline)
                        .disabled(isAuthorized)
                        
                        if (showUserBioField) {
                            Text("Your access key matches the one in our database. Please fill out your profile to complete the authorization process.")
                            
                            EmptySpacer(padding:0)
                            
                            TextField("Set your username", text: $SUUsername)
                                .padding()
                                .background(Color.black.opacity(0.15))
                                .border(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                            
                            SecureField("Set your password", text: $SUPassword)
                                .padding()
                                .background(Color.black.opacity(0.15))
                                .border(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                                                        
                            Button(action: {
                                if (SUPassword != "" && SUUsername != "") {
                                    isAuthorized = true
                                    showAlert = true
                                    registerUserToDatabase()
                                } else if (SUPassword == "" && SUUsername == "") {
                                    showAllFieldsUnentered = true
                                    showPasswordFieldUnentered = false
                                    showUsernameFieldUnentered = false
                                } else if (SUPassword == "" && SUUsername != "") {
                                    showPasswordFieldUnentered = true
                                    showAllFieldsUnentered = false
                                    showUsernameFieldUnentered = false
                                } else if (SUPassword != "" && SUUsername == "") {
                                    showUsernameFieldUnentered = true
                                    showAllFieldsUnentered = false
                                    showPasswordFieldUnentered = false
                                }
                            }) {
                                Text("Register")
                                    .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                                    .font(.headline)
                                    .padding()
                            }
                            
                            
                            if (showAllFieldsUnentered) {
                                Text("Please create your username and password for authorization")
                            } else if (showUsernameFieldUnentered) {
                                Text("Please create your username for authorization")
                            } else if (showPasswordFieldUnentered) {
                                Text("Please create your password for authorization")
                            }
                        }
                    }
                }
                else {
                    VStack(alignment: .leading) {
                        Text("Sign in to your authorized account")
                            .font(.headline)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                                
                        TextField("Username", text: $SUUsernameLogin)
                            .padding()
                            .background(Color.black.opacity(0.15))
                            .border(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                                
                        SecureField("Password", text: $SUPasswordLogin)
                            .padding()
                            .background(Color.black.opacity(0.15))
                            .border(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                                
                        Button(action: { SUSignIn() }) {
                            Text("Sign in")
                                .padding()
                                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                                .font(.headline)
                        }
                    }
                }
            }
                .padding()
                
            }
            .navigationTitle("Special User Access")
            .colorScheme(.dark)
            .onAppear {
                fetchAccessKeys()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(isAuthorized ? "Authorized" : "Not Authorized"),
                      message: Text(isAuthorized ? "You now have authority to post to OSU activity feed. Please sign in with your username and password." : "You are not authorized. Please enter a valid access key."),
                      dismissButton: .default(Text("OK")))
            }
            .onReceive([self.isAuthorized].publisher.first()) { authorized in
                if authorized {
                    //specialUser = true
                    //UserDefaults.standard.set(true, forKey: "isVerified")
                    //
                }
            }
            
    }
            
    func SUSignIn() {
        guard let url = URL(string: "http://localhost:3000/api/login") else {
            print("Invalid URL")
            return
        }
        
        let body: [String: Any] = [
            "username": SUUsernameLogin,
            "password": SUPasswordLogin
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            print("Failed to serialize data")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                if let error = error {
                    print("Error retrieving data: \(error.localizedDescription)")
                } else {
                    print("No data received in response.")
                }
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON data: \(jsonString)")
            }
            
            do {
                
                let loggedInUser = try JSONDecoder().decode(User.self, from: data)
                print("Logged In User:", loggedInUser)
                DispatchQueue.main.async {
                    // Update the app state based on the logged-in user
                    self.specialUser = true
                    UserDefaults.standard.set(loggedInUser.id, forKey: "userId")
                    UserDefaults.standard.set(loggedInUser.username, forKey: "username")
                    UserDefaults.standard.set(true, forKey: "isVerified")
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
        
    
    func authorizeKey() {
        // Check if the entered key exists in the accessKeys array
        // Note: Please do not leave accesskeys empty in database or this function will be bugged
        if accessKeys.contains(where: { $0.key == SUKey }) {
            showUserBioField = true // To display profile fields to user, will not actually authorize until user enters their info.
        } else {
            showAlert = true
        }
    }

    func registerUserToDatabase() {
        guard let url = URL(string: "http://localhost:3000/api/register") else {
            print("Invalid URL")
            return
        }
        
        let body: [String: Any] = [
            "key": SUKey,
            "username": SUUsername,
            "password": SUPassword
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            print("Failed to serialize data")
            return
        }
        

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                if let error = error {
                    print("Error retrieving data: \(error.localizedDescription)")
                } else {
                    print("No data received in response.")
                }
                return
            }
            /*
            if let jsonString = String(data: data, encoding: .utf8) {
                        print("Raw JSON data: \(jsonString)")
                    }
            */
            do {
                let newUser = try JSONDecoder().decode(User.self, from: data)
                //print("New User:", newUser)
                let userId = newUser.id
                let username = newUser.username
                //print("Registered User ID: ", userId)
                UserDefaults.standard.set(userId, forKey: "userId")
                //print("Registered Username: ", username)
                UserDefaults.standard.set(username, forKey: "username")
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func fetchAccessKeys() {
        guard let url = URL(string: "http://localhost:3000/api/accesskeys") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let accessKeys = try JSONDecoder().decode([AccessKey].self, from: data)
                DispatchQueue.main.async {
                    self.accessKeys = accessKeys
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    
}

struct User: Codable {
    var id: String
    var username: String
    var password: String?
    var activities: [String]
    var bio: String?
    var profilePicture: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case username
        case password
        case activities
        case bio
        case profilePicture
    }
}

struct AccessKey: Codable {
    let key: String
}


