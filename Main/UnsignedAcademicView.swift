//
//  UnsignedAcademicView.swift
//  Campus
//
//  Created by Drake Geeteh on 6/12/24.
//
// For Unsigned User

import Foundation
import SwiftUI

struct UnsignedAcademicView: View {
    @Binding var isSignedIn: Bool
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack(alignment:.leading) {

                    Text("Current Students")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    
                    Text("Sign in to Connect with Canvas")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    
                    GroupBox(label: Label("Connect to Canvas", systemImage: "link.circle.fill")
                        .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("By signing in, you can streamline your academic experience:")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("• Access course grades")
                            Text("• View assignments and deadlines")
                            Text("• Easily access syllabi and course materials")
                                       
                            Button(action: {
                                isSignedIn = true
                                UserDefaults.standard.set(true, forKey: "isSignedIn")
                                       }) {
                                Text("Sign In")
                                    .font(.headline)
                                    .padding()
                                    .background(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    .frame(maxWidth: .infinity)
                            }
                            .padding(.top, 10)
                        }
                        .padding()
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    
                    
                    EmptySpacer(padding:0)
                    HStackImageSet()
                    EmptySpacer(padding:0)
                    
                    Text("Prospective Students")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    
                    Text("Explore our Programs")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    GroupBox {
                        ProgramsView()
                    }
                    
                    EmptySpacer(padding:0)
                    
                    Text("Fall 2024 OSU Academic Calendar")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    
                    Text("Add/Drop Deadlines, Holidays, and More")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    GroupBox {
                        ScrollView {
                            AcademicScheduleView()
                        }
                    }
                    .frame(height:400)
                    
                    
                    EmptySpacer(padding:0)
                    
                    Text("A Drake Geeteh Production")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.systemGray))
                        .padding(.bottom, 20)
                        .frame(maxWidth:.infinity)
                    
                    
                    
                }
                .padding()
            }
            .navigationTitle("Academics")
        }
        .colorScheme(.dark)
        .accentColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
        
    }
}

struct ProgramsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Link(destination: URL(string: "https://go.okstate.edu/undergraduate-academics/majors/")!) {
                Text("Majors Offered & Major Quiz")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.subheadline)
            }
            
            Link(destination: URL(string: "https://go.okstate.edu/undergraduate-academics/")!) {
                Text("Undergraduate Programs")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.subheadline)
            }
            
            Link(destination: URL(string: "https://go.okstate.edu/graduate-academics/")!) {
                Text("Graduate and Professional Education")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.subheadline)
            }
            
            Link(destination: URL(string: "https://osuonline.okstate.edu")!) {
                Text("Online Programs")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.subheadline)
            }
        }
        .padding()
    }
}


