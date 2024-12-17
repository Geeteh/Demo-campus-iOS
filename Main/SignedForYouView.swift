//
//  SignedForYouView.swift
//  Campus
//
//  Created by Drake Geeteh on 6/18/24.
//

import Foundation
import SwiftUI
import UIKit
import CoreImage.CIFilterBuiltins


struct SignedForYouView: View {
    @State private var studentName: String = "Drake"
    @State private var showingSignOutConfirmation: Bool = false
    @Binding var isSignedIn: Bool

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private var recentTransactions: [Transaction] {
        let sampleDates = (1...30).map {
            Calendar.current.date(byAdding: .day, value: -$0, to: Date())!
        }

        return sampleDates.enumerated().map { index, date in
            Transaction(
                date: dateFormatter.string(from: date),
                description: "Transaction \(index + 1)",
                amount: -Double(index + 1) * 1.25
            )
        }
        .sorted(by: { dateFormatter.date(from: $0.date)! > dateFormatter.date(from: $1.date)! })
    }

    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Hello, \(studentName)!")
                            .font(.headline)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                        
                        Text("Welcome to the OSU App")
                            .font(.subheadline)
                            .foregroundColor(.white)

                        GroupBox {
                            Image("osu-primary-logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 155, height: 122)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Services at Your Fingertips")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .padding(.bottom, 5)
                                
                                ServiceItem(
                                    title: "O-Key Meal Plan Balance",
                                    description: "Check your current meal plan balance.",
                                    action: { proxy.scrollTo("mealPlanBalance", anchor: .top) }
                                )
                                
                                ServiceItem(
                                    title: "Recent Transactions",
                                    description: "View your recent transactions on campus.",
                                    action: { proxy.scrollTo("recentTransactions", anchor: .top) }
                                )
                                
                                ServiceItem(
                                    title: "Colvin Recreation Center Access",
                                    description: "Connect to OKState Wellness for access to Colvin Recreation Center.",
                                    action: { proxy.scrollTo("recreationalCenterAccess", anchor: .top) }
                                )
                                
                                ServiceItem(
                                    title: "Report Lost Student ID",
                                    description: "Report and deactivate a lost or stolen student ID.",
                                    action: { proxy.scrollTo("reportLostID", anchor: .top) }
                                )
                                
                                ServiceItem(
                                    title: "Sign Up for LASSO Tutoring",
                                    description: "Sign up for LASSO tutoring sessions.",
                                    action: { proxy.scrollTo("signUpLassoTutoring", anchor: .top) }
                                )
                                
                                ServiceItem(
                                    title: "Change O-Key Account Password",
                                    description: "Change your O-Key account password for security.",
                                    action: { proxy.scrollTo("changeAccountPassword", anchor: .top) }
                                )
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.vertical)
                        }
                        .foregroundColor(.white)
                        
                        EmptySpacer(padding: 0)
                        HStackImageSet()
                        
                        VStack(alignment: .leading, spacing: 20) {
                            ScrollTargetView(
                                id: "mealPlanBalance",
                                title: "O-Key Meal Plan Balance",
                                description: "Your current meal plan balance is $250.00."
                            )
                            ScrollTargetView(
                                id: "recentTransactions",
                                title: "Recent Transactions",
                                description: "Here are your recent transactions:",
                                transactions: recentTransactions
                            )
                            ScrollTargetView(
                                id: "recreationalCenterAccess",
                                title: "Colvin Recreation Center Access",
                                description: "You have access to all facilities in the Colvin Recreation Center.",
                                hasBarcodeLink: true
                            )
                            ScrollTargetView(
                                id: "reportLostID",
                                title: "Report and Lock Lost Student ID",
                                description: "Lock your lost ID to prevent unauthorized use.",
                                url: URL(string: "https://apps.okstate.edu/okey/index.php/module/Default/action/LockCard")
                            )
                            ScrollTargetView(
                                id: "signUpLassoTutoring",
                                title: "Sign Up for LASSO Tutoring",
                                description: "Sign up for LASSO tutoring sessions here.",
                                url: URL(string: "https://slate.okstate.edu/portal/lasso_tutoring")
                            )
                            ScrollTargetView(
                                id: "changeAccountPassword",
                                title: "Change O-Key Account Password",
                                description: "Change your O-Key account password to enhance security.",
                                url: URL(string: "https://apps.okstate.edu/okey/index.php/module/Default/action/Password")
                            )
                        }
                        .padding(.top)
                        
                        EmptySpacer(padding: 0)
                        
                        Text("A Drake Geeteh Production")
                            .font(.system(size: 12))
                            .foregroundColor(Color(.systemGray))
                            .padding(.bottom, 20)
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                }
            }
            .navigationTitle("For You")
            .navigationBarItems(trailing: Button(action: {
                showingSignOutConfirmation = true
            }) {
                Image(systemName: "door.left.hand.open")
                    .imageScale(.large)
                    .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            })
            .overlay(
                Group {
                    if showingSignOutConfirmation {
                        CustomConfirmationDialog(isPresented: $showingSignOutConfirmation, isSignedIn: $isSignedIn)
                    }
                }
            )
        }
        .colorScheme(.dark)
        .accentColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
    }
}

struct ScrollTargetView: View {
    var id: String
    var title: String
    var description: String
    var transactions: [Transaction]? = nil
    var hasBarcodeLink: Bool = false
    var url: URL? = nil

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.bottom, 5)
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(.bottom, 5)
            
            if id == "signUpLassoTutoring" {
                if let url = url {
                    UnderlinedLink(text: "Make an Appointment", url: url)
                }
            } else if id == "reportLostID" {
                if let url = url {
                    UnderlinedLink(text: "Lock Student ID", url: url)
                }
            } else if id == "changeAccountPassword" {
                if let url = url {
                    UnderlinedLink(text: "Change your Password", url: url)
                }
            }
            
            if hasBarcodeLink {
                NavigationLink(destination: BarcodeView(barcodeData: "1234567890")) {
                    Text("Show Scan-in Barcode")
                        .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                        .underline()
                }
            }
            
            if let transactions = transactions {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(transactions) { transaction in
                            HStack {
                                Text(transaction.date)
                                    .foregroundColor(.white)
                                    .font(.footnote)
                                Spacer()
                                Text(transaction.description)
                                    .foregroundColor(.white)
                                    .font(.footnote)
                                Spacer()
                                Text(String(format: "$%.2f", transaction.amount))
                                    .foregroundColor(.white)
                                    .font(.footnote)
                            }
                            .padding(.vertical, 5)
                            Divider()
                                .background(Color.gray)
                        }
                    }
                }
                .frame(maxHeight: 300) // Set a fixed height for scroll area
            }
            
            Divider()
                .background(Color.gray)
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(8)
        .id(id)
    }
}


struct BarcodeView: View {
    var barcodeData: String

    var body: some View {
        VStack(alignment:.leading) {
            
            Text("Colvin Recreation Center Access")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(.white)
            
            Text("Use Barcode to Scan-in")
                .font(.subheadline)
                .foregroundColor(.white)
            
            GroupBox {
                if let barcodeImage = generateBarcode(from: barcodeData) {
                    Image(uiImage: barcodeImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 100)
                        .padding()
                } else {
                    Text("Failed to generate barcode.")
                }
            }
            
            Spacer()
        }
        .navigationTitle("Your Barcode")
        .padding()
    }
    
    func generateBarcode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.code128BarcodeGenerator()
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        
        return nil
    }
}

struct ServiceItem: View {
    var title: String
    var description: String
    var url: URL? = nil
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))

                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)

                Divider()
                    .background(Color.gray)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct UnderlinedLink: View {
    let text: String
    let url: URL
    
    var body: some View {
        Button(action: {
            UIApplication.shared.open(url)
        }) {
            Text(text)
                .underline()
                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                .padding(.bottom, 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct Transaction: Identifiable {
    var id = UUID()
    var date: String
    var description: String
    var amount: Double
}





