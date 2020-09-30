//
//  NewPostView.swift
//  Sellers Spot
//
//  Created by Bishal Aryal on 20/9/16.
//  Copyright © 2020 Bishal Aryal. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct NewPostView: View
{
    @State var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @State var userEmail: String = UserDefaults.standard.string(forKey: "userEmail") ?? ""
    @State var userImage: String = UserDefaults.standard.string(forKey: "userImage") ?? ""
    
    @State var productName: String = ""
    @State var productDescription: String = ""
    @State var productImages: [String] = []
    @State var productPrice: String = "0.00"
    @State var productLocation: String = ""
    
    @State var keyboardHeight: CGFloat = 0
    @State var openAccountView: Bool = false
    @State var loggedIn: Bool = UserDefaults.standard.bool(forKey: "status")
    
    @Binding var newPostView: Bool
    @State var storeImages: [UIImage?] = []
    
    @State var userId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    @State var userPost: String = ""
    
    @ObservedObject var post = PostObserver()
    
    var body: some View
    {
        VStack
            {
                HStack
                    {
                        Button(action: {
                            self.newPostView = false
                            print(String(storeImages.count))
                            storeImages.removeAll()
                        })
                        {
                            Text("Cancel")
                            Image(systemName: "xmark.circle.fill")
                        }
                        .foregroundColor(.red)
                        
                        Spacer()
                        
                        Button(action: {
                            
                            self.newPostView = false
                            userPost = NSUUID().uuidString      // creating unique identifier for each post
                            
                            print("\(storeImages.count) images uploaded")
                            
                            // Storing to images firebase Storage
                            
                            let storage = Storage.storage()
                            for i in 0..<storeImages.count
                            {
                                storage.reference().child("\(userId)/\(userPost)/image\(i)").putData((storeImages[i]!.jpegData(compressionQuality: 0.5))!, metadata: nil)
                                {   (url, err) in
                                    if err != nil
                                    {
                                        print((err?.localizedDescription)!)
                                        return
                                    }
                                    print("success uploading image\(i) to firebase")
                                    
                                    storage.reference().child("\(userId)/\(userPost)/image\(i)").downloadURL
                                    {   url, err in
                                        if err != nil
                                        {
                                            print((err?.localizedDescription)!)
                                            return
                                          } else
                                        {
                                            self.productImages.append(url!.absoluteString)
                                            print(url!)
                                          }
                                    }
                                }
                            }
                                // Storing post the firebase Cloud
                                DispatchQueue.main.asyncAfter(deadline: .now() + 15) {  // wait 15 second and upload everything
                                    // waiting 15 seconds will give time to save all images to firebase storage
                                    self.post.addPost(username: userEmail, userImage: userImage, productName: productName, productImage: productImages, productDescription: productDescription, productPrice: productPrice)
                                    print("DOne")
                                    
                                    storeImages.removeAll()
                                }
                        })
                        {
                            Image(systemName: "paperplane.fill")
                            Text("Post")
                        }
                }
                .font(.headline)
                .padding()
                .background(Color.secondary.opacity(0.3))
                
                Spacer()
                
            
                if self.loggedIn
                {
                    VStack
                    {
                    ScrollView(.vertical)
                    {
                        VStack(alignment: .leading, spacing: 20)
                        {
                            
                            PostUserInfoView(username: username, userEmail: userEmail, userImage: userImage)
                            
                            Text("Name")
                            TextField("Write the name of your product.", text: $productName)
                                .frame(width: UIScreen.main.bounds.width / 1.2, height: 50)
                                .padding()
                                .background(Color.secondary.opacity(0.1))
                                .cornerRadius(10)
                            
                            Text("Description")
                            TextField("Write the details of the product.", text: $productDescription)
                                .frame(width: UIScreen.main.bounds.width / 1.2, height: 300, alignment: .topLeading)
                                .padding()
                                .background(Color.secondary.opacity(0.1))
                                .cornerRadius(10)
                            
                            Text("Images")
                            PostImageView(image: self.$storeImages)
                            
                            Text("Price")
                            TextField("Input the price.", text: self.$productPrice)
                                .frame(width: UIScreen.main.bounds.width / 1.2, height: 30)
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color.secondary.opacity(0.1))
                                .cornerRadius(10)
                            
                        }
                        .padding()
                        .padding(.bottom, UIScreen.main.bounds.height / 3)
                    }
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                    }
                } else
                {
                    SignInView()    // if user is not signed in then tell them
                }
                
                Spacer()
        }
        .onAppear()
        {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main)
            { (_) in
                let loggedIn = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                let username: String = UserDefaults.standard.string(forKey: "username") ?? ""
                let userEmail: String = UserDefaults.standard.string(forKey: "userEmail") ?? ""
                let userImage: String = UserDefaults.standard.string(forKey: "userImage") ?? ""
                
                self.loggedIn = loggedIn
                self.username = username
                self.userEmail = userEmail
                self.userImage = userImage
            }
        }
    }
}
