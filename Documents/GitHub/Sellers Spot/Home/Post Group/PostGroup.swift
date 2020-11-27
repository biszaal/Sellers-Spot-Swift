//
//  ContentView.swift
//  Tokyo Sellers spot
//
//  Created by Bishal Aryal on 20/9/7.
//

import SwiftUI
import Foundation

struct PostGroup: View
{
    @ObservedObject var postObserver = PostObserver()
    @State var posts = [PostDetails]()
    @State var isScrolled: Bool = false
    @State var refresh: Refresh = Refresh(started: false, release: false)
    
    @Binding var selectedTab: Int
    @Binding var searchTextField: String
    
    var body: some View
    {
        ScrollView
        {
            VStack
            {
                if posts.isEmpty
                {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .font(.largeTitle)
                        .offset(y: UIScreen.main.bounds.height / 2)
                }
                else
                {
                    Image(systemName: "arrow.down")
                        .font(.system(size: 16, weight: .heavy))
                        .foregroundColor(.black)
                        .rotationEffect(.init(degrees: refresh.started ? 180 : 0))
                        .offset(y: -30)
                        .animation(.easeIn)
                    
                    ForEach(posts)
                    { post in
                        EachPost(post: post, selectedTab: self.$selectedTab)
                    }
                    .offset(y: 50)
                    
                    GeometryReader
                    { reader -> AnyView in
                        refreshingPage(reader: reader)
                        
                        if !isScrolled
                        {
                            // when scrolled to the bottom it will fetch and wait 2 second to let the data fetch and load
                            // which will prevent fetching multiple copies
                            DispatchQueue.main.async
                            {
                                if (reader.frame(in: .global).minY) < 600
                                {
                                    batchFetching()
                                    self.isScrolled = true
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2)
                                    {
                                        self.isScrolled = false
                                    }
                                }
                            }
                        }
                        return AnyView(Color.black.frame(width: 0, height: 0))
                    }
                    .frame(width: 0, height: 0)
                }
            }
            Spacer(minLength: 80)   // prevent hiding behing tabbar
        }
        .onAppear()
        {
            batchFetching()
        }
        
        .onChange(of: searchTextField)
        { (_) in
            posts.removeAll()
            batchFetching()
        }
    }
    
    func batchFetching()
    {
        postObserver.fetchData(searchValue: self.searchTextField, posts: self.posts)
        { newPost in
            self.posts.append(contentsOf: newPost)
        }
    }
    
    func refreshingPage(reader: GeometryProxy)
    {
        DispatchQueue.main.async
        {
            if refresh.startOffset == 0
            {
                refresh.startOffset = reader.frame(in: .global).minY
            }
            
            refresh.offset = reader.frame(in: .global).minY
            
            if refresh.offset - refresh.startOffset > 90 && !refresh.started
            {
                refresh.started = true
            }
            
            if refresh.startOffset == refresh.offset && refresh.started && !refresh.release
            {
                refresh.release = true
                
                //Refreshing the page
                selectedTab = 0
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)
                {
                    selectedTab = 1
                }
            }
        }
    }
    
}

struct Refresh
{
    var startOffset: CGFloat = 0
    var offset: CGFloat = 0
    var started: Bool
    var release: Bool
}
