//
//  ForYouView.swift
//  Campus
//
//  Created by Drake Geeteh on 2/22/24.
//

import SwiftUI

struct ForYouView: View {
    
    @State var emailID: String = ""
    @State var password: String = ""
    @Binding var isSignedIn: Bool
    
    var body: some View {
        
        NavigationView {
                
                ScrollView {
                    VStack(alignment: .leading) {
                        
                        
                        Text("Current Cowboys")
                            .font(.headline)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                        
                        Text("Please connect your O-Key account")
                            .font(.subheadline)
                            .foregroundColor(.white)
                                                
                        GroupBox {
                            
                            Image("osu-primary-logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:100,height:80)
                            
                            TextField("O-Key Email", text: $emailID)
                                .padding()
                                .background(Color.black.opacity(0.15))
                                .border(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                            
                            SecureField("O-Key Password", text: $password)
                                .padding()
                                .background(Color.black.opacity(0.15))
                                .border(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                                
                            EmptySpacer(padding:0)
                            
                            Button(action: { signIn() }) {
                                Text("Sign in")
                            }
                                .padding()
                                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                                .font(.headline)

                            
                        }
                        .frame(maxWidth: .infinity)

                        GroupBox {
                            
                            Button(action: { getHelpSignIn() }) {
                                Text("Get help with signing in")
                            }
                            .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                            .font(.headline)
                            .fontWeight(.light)
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity)
                            
                        }
                        
                        EmptySpacer(padding:0)
                        
                        Text("Welcome to the OSU App")
                            .font(.headline)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                        
                        Text("We are here to assist you")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        GroupBox {
                            VStack(alignment: .leading, spacing: 0) {
                                
                                NavigationLink(destination: FutureStudentView()) {
                                        HStack {
                                            Image(systemName: "books.vertical.fill")
                                                .frame(width: 25, height: 25)
                                                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                                            Text("Future Students")
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                        }
                                }
                                .foregroundColor(.white)
                                
                                EmptySpacer(padding:5)
                                
                                NavigationLink(destination: ParentsAndFamilyView()) {
                                    HStack {
                                        Image(systemName:"figure.and.child.holdinghands")
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                                        Text("Parents and Family")
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                    }
                                }
                                .foregroundColor(.white)

                                EmptySpacer(padding:5)
                                
                                NavigationLink(destination: FansView()) {
                                    HStack {
                                        Image(systemName:"football.fill")
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                                        Text("Fans")
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                    }
                                }
                                .foregroundColor(.white)
                                
                                EmptySpacer(padding:5)
                                
                                NavigationLink(destination: AlumniView()) {
                                    HStack {
                                        Image(systemName:"graduationcap.fill")
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                                        Text("Alumni")
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                    }
                                }
                                .foregroundColor(.white)
                                
                                EmptySpacer(padding:5)
                                
                                NavigationLink(destination: GuestsView()) {
                                    HStack {
                                        Image(systemName: "figure.wave")
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                                        Text("Guests")
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                    }
                                }
                                .foregroundColor(.white)

                            }
                        }

                        EmptySpacer(padding:0)
                        
                        Text("A Drake Geeteh Production")
                            .font(.system(size: 12))
                            .foregroundColor(Color(.systemGray))
                            .padding(.bottom, 20)
                            .frame(maxWidth:.infinity)
                            
                        
                      
                    }
                    .padding()
                    
                }
                .navigationTitle("For You")
            }
            .colorScheme(.dark)
            .accentColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
        
    }
    
    func signIn() {
        // Implement logic for authorizing student.
    /*
        Task {
            do {
                try await // Authorize user
                print("User Authorized")
                try await fetchUserData()
            }catch{
                print("Error: \(error)")
            }
        }
    */
        isSignedIn = true
        UserDefaults.standard.set(true, forKey: "isSignedIn")
        
    }
}



struct EmptySpacer: View {
    let padding: CGFloat
    
    var body: some View {
        Text("")
            .padding(padding)
    }
}



func fetchUserData() {
    // Implement logic for student data retrieval.
}



func getHelpSignIn() {
    
}







