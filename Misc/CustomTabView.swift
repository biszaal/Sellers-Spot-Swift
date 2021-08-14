//
//  CustomTabView.swift
//  Sellers Spot
//
//  Created by Bishal Aryal on 24/10/2020.
//  Copyright © 2020 Bishal Aryal. All rights reserved.
//

import SwiftUI

struct CustomTabView: View
{
    
    @Binding var selectedIndex: Int
    @Binding var newPostView: Bool
    
    var body: some View
    {
        HStack(spacing: 0)
        {
            Button(action:
                    {
                        selectedIndex = 1
                    })
            {
                VStack
                {
                    Image(systemName: "house.fill")
                        .font(.system(size: 25))
                    Text("Home")
                        .font(.system(size: 10))
                }
            }
            .foregroundColor(self.selectedIndex == 1 ? .primaryColor : .secondary)
            .offset(y: self.selectedIndex == 1 ? -5 : 0)
            
            Spacer(minLength: 0)
            
            Button(action:
                    {
                        selectedIndex = 2
                    })
            {
                VStack
                {
                    Image(systemName: "message.fill")
                        .font(.system(size: 25))
                    Text("Messages")
                        .font(.system(size: 10))
                }
            }
            .foregroundColor(self.selectedIndex == 2 ? .primaryColor : .secondary)
            .offset(y: self.selectedIndex == 2 ? -5 : 0)
            
            Spacer(minLength: 0)
            
            //MARK: Add New Post
            Button(action:
                    {
                        self.newPostView.toggle()
                    })
            {
                Image(systemName: "plus")
                    .padding()
                    .frame(width: 60, height: 60)
                    .font(.system(size: 30, design: .rounded))
                    .foregroundColor(.primary).colorInvert()
                    .background(Color.buttonColor)
                    .clipShape(Circle())
            }
            .shadow(radius: 5, y: 3)
            .offset(y: -15)
            
            Spacer(minLength: 0)
            
            Button(action:
                    {
                        selectedIndex = 3
                    })
            {
                VStack
                {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 25))
                    Text("Notifications")
                        .font(.system(size: 10))
                }
            }
            .foregroundColor(self.selectedIndex == 3 ? .primaryColor : .secondary)
            .offset(y: self.selectedIndex == 3 ? -5 : 0)
            
            Spacer(minLength: 0)
            
            Button(action:
                    {
                        selectedIndex = 4
                    })
            {
                VStack
                {
                    Image(systemName: "person.fill")
                        .font(.system(size: 25))
                    Text("Account")
                        .font(.system(size: 10))
                }
            }
            .foregroundColor(self.selectedIndex == 4 ? .primaryColor : .secondary)
            .offset(y: self.selectedIndex == 4 ? -5 : 0)
        }
        .animation(.default)
        .padding(.horizontal, 35)
        .padding(.bottom, 20)
        .frame(height: 80)
        .background(Color(UIColor.secondarySystemBackground))
    }
}
