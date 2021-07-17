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
    
    @Binding var selectedTab: Int
    @State var searchTextField: String = ""
    @State var showSearchBar: Bool = true
    
    var body: some View
    {
        ZStack(alignment: .top)
        {
            if showSearchBar
            {
                HStack
                {
                    HStack
                    {
                        Image(systemName: "magnifyingglass")
                            .padding()
                            .foregroundColor(.secondary)
                        
                        TextField("Search", text: $searchTextField, onCommit:
                                    {
                                        UIApplication.shared.endEditing()
                                    })
                            .onReceive(Just(searchTextField))
                            { (newValue: String) in
                                self.searchTextField = String(newValue.prefix(20))
                            }
                        
                    }
                    .frame(width: UIScreen.main.bounds.width / 1.5, height: 50, alignment: .leading)
                    .background(Color.primary.colorInvert().opacity(0.6))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(Color.gray, lineWidth: 1))
                    .shadow(radius: 5)
                    
                    Spacer()
                    
                    // Add a button next to search
                }
                .zIndex(1)
                .padding()
                .padding(.top, (UIApplication.shared.windows.last?.safeAreaInsets.top)! - 10)
                .background(Color.primaryColor.opacity(0.9))
                .edgesIgnoringSafeArea(.top)
                
                .animation(.default)
                .transition(.move(edge: .top))
            }
            
            // Custom design for iPad and iPhone
            if UIDevice.current.userInterfaceIdiom == .pad
            {
                PostGroup(selectedTab: self.$selectedTab, searchTextField: self.$searchTextField)
            }
            else {
                HomePostView( selectedTab: self.$selectedTab, searchTextField: self.$searchTextField, showSearchBar: self.$showSearchBar)
            }
        }
    }
}
