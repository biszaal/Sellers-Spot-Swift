//
//  HomeMain.swift
//  Sellers Spot
//
//  Created by Bishal Aryal on 20/9/8.
//
import SwiftUI
import Combine

struct HomeMain: View
{
    @State var searchTextField: String = ""
    @State var newPostView: Bool = false
    @State var photoUplodingProgress: Float = 0
    @State var isUploading: Bool = false
    
    var body: some View
    {
        VStack(alignment: .leading)
        {
            HStack
                {
                    HStack
                        {
                            Image(systemName: "magnifyingglass")
                                .padding()
                                .foregroundColor(.secondary)
                        TextField("Search", text: $searchTextField)
                            .onReceive(Just(searchTextField)) { (newValue: String) in
                                self.searchTextField = String(newValue.prefix(20))
                                        }
                            
                    }
                    .frame(width: UIScreen.main.bounds.width / 1.5, height: 50, alignment: .leading)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(Color.gray, lineWidth: 1))
                        .shadow(radius: 5)
                    
                    Spacer()
                    
                    Button(action: {
                        self.newPostView.toggle()
                    })
                    {
                        Image(systemName: "plus")
                            .padding()
                            .font(.title)
                            .foregroundColor(.primary)
                            .colorInvert()
                            .background(Color(UIColor.systemOrange))
                            .clipShape(Circle())
                    }
            }
            .padding()
            
            if isUploading
            {
                ProgressView("Uploading...", value: photoUplodingProgress, total: 1)
            }
            
            if searchTextField != ""    // if searching
            {
                PostGroup(searchTextField: searchTextField)
            }
            else
            {
                PostGroup()
            }
        }
        .sheet(isPresented: $newPostView, content: {
            NewPostView(newPostView: self.$newPostView, photoUplodingProgress: self.$photoUplodingProgress, isUploading: self.$isUploading)
        })
    }
}
