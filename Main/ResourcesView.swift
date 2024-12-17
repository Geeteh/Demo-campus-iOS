//
//  ResourcesView.swift
//  Campus
//
//  Created by Drake Geeteh on 6/19/24.
//

import Foundation
import SwiftUI

struct ResourcesView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    Text("OSU Resources")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    
                    Text("We are here to help")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    GroupBox(label:
                                Text("Student Resources")
                        .underline()
                        .fontWeight(.heavy)
                    ) {
                        ScrollView {
                            ResourceItem(title: "Academic Support", description: "Services to help with academic success.", url: "https://ssc.okstate.edu/student-support/resources/academic-resources.html")
                            
                            Divider()
                            
                            ResourceItem(title: "Financial Support", description: "Assistance with financial aid and scholarships.", url: "https://ssc.okstate.edu/student-support/resources/financial-support.html")
                            
                            Divider()
                            
                            ResourceItem(title: "Mental Health", description: "Counseling and mental health resources.", url: "https://wellness.okstate.edu/student-wellness/resources.html")
                            
                            Divider()
                            
                            ResourceItem(title: "Basic Needs & Food Assistance", description: "Support for food and basic needs.", url: "https://ssc.okstate.edu/student-support/basicneeds.html")
                            
                            Divider()
                            
                            ResourceItem(title: "Health & Wellness", description: "Resources for health and wellness.", url: "https://ssc.okstate.edu/student-support/resources/health-wellness.html")
                            
                            Divider()
                            
                            ResourceItem(title: "Summer Resources", description: "Services available during summer.", url: "https://ssc.okstate.edu/student-support/resources/summer.html")
                            
                            Divider()
                            
                            ResourceItem(title: "Additional Resources", description: "Other support services.", url: "https://ssc.okstate.edu/student-support/resources/handouts.html")
                            
                            
                        }
                    }.frame(height:500)
                    
                    EmptySpacer(padding:0)
                    HStackImageSet()
                    EmptySpacer(padding:0)
                    
                    GroupBox(label: Text("OSU Safety")
                        .underline()
                        .fontWeight(.heavy)) {
                            
                            
                
                            
                        ResourceItem(title:"Campus Police Number", description: "405-744-6523",url:"nil")
                            
                        Divider()
                            
                        ResourceItem(title: "Emergency Notifications - Cowboy Alert", description: "Receive emergency notifications via Cowboy Alert service.", url: "https://safety.okstate.edu/safety-resources/cowboy-alert.html")
                            
                            Divider()
                            
                            ResourceItem(title: "Rave Guardian App", description: "Turn your phone into a personal safety resource with the Rave Guardian app.", url: "https://safety.okstate.edu/safety-resources/rave-guardian.html")
                            
                            Divider()
                            
                            ResourceItem(title: "Crisis Response Guide", description: "Best practices and resources for crisis response at OSU.", url: "https://safety.okstate.edu/crisis-response-guide/")
                            
                            
                            
                        }
                    
                    EmptySpacer(padding:0)
                    
                    
                    GroupBox(label: Text("Scholarships & Grants")
                        .underline()
                        .fontWeight(.heavy)) {
                            
                            ScrollView {
                                ResourceItem(title: "Freshman Scholarships", description: "Scholarships for incoming freshman students.", url: "https://go.okstate.edu/scholarships-financial-aid/types-of-aid/scholarships-and-grants/freshman-scholarships/")
                                
                                Divider()
                                
                                ResourceItem(title: "Transfer Scholarships", description: "Scholarships for transfer students.", url: "https://go.okstate.edu/scholarships-financial-aid/types-of-aid/scholarships-and-grants/transfer-scholarships.html")
                                
                                Divider()
                                
                                ResourceItem(title: "International Scholarships", description: "Scholarships for international students.", url: "https://go.okstate.edu/scholarships-financial-aid/types-of-aid/scholarships-and-grants/international-scholarships.html")
                                
                                Divider()
                                
                                ResourceItem(title: "Current Undergraduate Scholarships", description: "Scholarships for current undergraduate students.", url: "https://go.okstate.edu/scholarships-financial-aid/types-of-aid/scholarships-and-grants/current-undergraduate-scholarships/")
                                
                                Divider()
                                
                                ResourceItem(title: "Graduate Scholarships", description: "Scholarships for graduate students.", url: "https://go.okstate.edu/scholarships-financial-aid/types-of-aid/scholarships-and-grants/graduate-student-scholarships.html")
                                
                                Divider()
                                
                                ResourceItem(title: "Additional OSU Scholarship Opportunities", description: "Additional scholarship opportunities at OSU.", url: "https://go.okstate.edu/scholarships-financial-aid/types-of-aid/scholarships-and-grants/current-undergraduate-scholarships/additional-osu-scholarships.html")
                                
                                Divider()
                                
                                ResourceItem(title: "Outside Scholarships", description: "Scholarships from external sources.", url: "https://go.okstate.edu/scholarships-financial-aid/types-of-aid/scholarships-and-grants/outside-scholarships.html")
                                
                                Divider()
                                
                                ResourceItem(title: "Grants for U.S. and Oklahoma residents", description:"Grants available to residents of the U.S. and Oklahoma, providing financial aid based on specific criteria and needs.", url: "https://go.okstate.edu/scholarships-financial-aid/types-of-aid/scholarships-and-grants/grants/")
                                
                            }
                        }.frame(height:500)
                    
                    
                    EmptySpacer(padding:0)
                    
                    GroupBox(label: Text("Student Employment & Work Study")
                        .underline()
                        .fontWeight(.heavy)) {
                        ResourceItem(title: "Career Services", description: "Opportunities for employment and work-study jobs.", url: "https://careerservices.okstate.edu/students-alumni/search/")
                        
                        Divider()
                            
                            ResourceItem(title:"Federal Work-Study Information",description:"See more information about work-study.",url:"https://go.okstate.edu/scholarships-financial-aid/files/documents/23-24/info_sheets/fws.pdf")
                    }
                    
                    
                    EmptySpacer(padding:0)
                    
                    GroupBox(label: Text("Research")
                        .underline()
                        .fontWeight(.heavy)) {
                            
                        ResourceItem(title:"Research Information", description: "Read about research at OSU", url:"https://go.okstate.edu/about-osu/research.html")
                            
                        Divider()
                            
                        ResourceItem(title: "Undergraduate Research Programs", description: "Opportunities for research participation.", url: "https://academicaffairs.okstate.edu/scholars/undergraduate-research/undergrad-research-opportunities.html")
                    }
                    
                    GroupBox(label: Text("ChatGPT Information")
                        .underline()
                        .fontWeight(.heavy)) {
                        ResourceItem(title: "About ChatGPT", description: "Read about Oklahoma State's perspective on generative AI software.", url: "https://itle.okstate.edu/chatgpt.html")
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
            .navigationTitle("Resources")
        }
        .accentColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
        .colorScheme(.dark)
    }
}

struct ResourceItem: View {
    var title: String
    var description: String
    var url: String
    
    var body: some View {
        Button(action: {
            if let url = URL(string: url) {
                UIApplication.shared.open(url)
            }
        }) {
            VStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            .padding()
        }
        .buttonStyle(PlainButtonStyle())
    }
}


