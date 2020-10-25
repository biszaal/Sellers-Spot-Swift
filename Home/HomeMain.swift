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
    
    var body: some View
    {
        ZStack(alignment: .top)
        {
            HStack
            {
                HStack
                {
                    Image(systemName: "magnifyingglass")
                        .padding()
                        .foregroundColor(.secondary)
                    
                    TextField("Search", text: $searchTextField)
                        .onReceive(Just(searchTextField))
                        { (newValue: String) in
                            self.searchTextField = String(newValue.prefix(20))
                        }
                    
                }
                .frame(width: UIScreen.main.bounds.width / 1.5, height: 50, alignment: .leading)
                .background(Color.primary.colorInvert())
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
            .background(Color("AccentColor").opacity(0.9))
            .edgesIgnoringSafeArea(.top)
            
            if searchTextField != ""    // if searching
            {
                PostGroup(searchTextField: searchTextField)
            }
            else
            {
                PostGroup()
            }
        }
    }
}
