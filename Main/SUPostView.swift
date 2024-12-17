//
//  SUPostView.swift
//  Campus
//
//  Created by Drake Geeteh on 2/29/24.
//

import Foundation
import SwiftUI
import PhotosUI

struct SUPostView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var caption: String = ""
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    
    let userId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    let username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    let userProfilePicture: String = UserDefaults.standard.string(forKey: "profilePicture") ?? ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Create a Post")
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                
                Text("Pick an image, write a caption")
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                GroupBox {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                            .padding()
                    }
                    
                    
                    Button(action: { showingImagePicker = true}) {
                        Text("Select Image")
                    }
                    
                    EmptySpacer(padding:0)
                    
                    TextField("Enter caption", text: $caption, axis: .vertical)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black.opacity(0.15))
                        .border(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                        //.padding()
                    
                    EmptySpacer(padding:0)
                    
                    Button(action: {
                        // Send caption and image to backend
                        print(userId)
                        print(username)
                        if let imageData = selectedImage?.jpegData(compressionQuality: 0.8) {
                            postActivity(userId: userId, username: username, imageData: imageData, caption: caption, userProfilePicture: userProfilePicture) {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }) {
                        Text("Post")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                            .foregroundColor(.white)
                            .font(.headline)
                            .cornerRadius(8)
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
            .navigationTitle("Post")
            .padding()
        }
    }
    
}

func postActivity(userId: String, username: String, imageData: Data, caption: String, userProfilePicture: String, completion: @escaping () -> Void) {
    guard let url = URL(string: "http://localhost:3000/api/activities") else {
        print("Invalid URL")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    let timestamp = dateFormatter.string(from: currentDate)

    let parameters: [String: Any] = [
        "userId": userId,
        "user": username,
        "content": caption,
        "picture": imageData.base64EncodedString(),
        "timestamp": timestamp,
        "userProfilePicture": userProfilePicture // Include user profile picture URL or path
    ]

    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
    } catch {
        print("Error serializing JSON:", error.localizedDescription)
        return
    }

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            print("Invalid response")
            return
        }

        if (200...299).contains(httpResponse.statusCode) {
            print("Post successful")
            DispatchQueue.main.async {
                completion()
            }
        } else {
            print("Post failed with status code: \(httpResponse.statusCode)")
        }
    }.resume()
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if let provider = results.first?.itemProvider {
                if provider.canLoadObject(ofClass: UIImage.self) {
                    provider.loadObject(ofClass: UIImage.self) { image, error in
                        if let error = error {
                            print("Error loading image: \(error.localizedDescription)")
                        } else if let image = image as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.selectedImage = image
                                self.parent.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ContentPreview: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
