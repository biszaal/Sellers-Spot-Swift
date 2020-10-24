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
                        withAnimation()
                        {
                            selectedIndex = 1
                        }
            })
            {
                VStack
                {
                    Image(systemName: "house.fill")
                        .font(.title)
                    Text("Home")
                        .font(.caption2)
                }
            }
            .foregroundColor(Color.primary.opacity(self.selectedIndex == 1 ? 1 : 0.2))
            .offset(y: self.selectedIndex == 1 ? -10 : 0)
            
            Spacer(minLength: 0)
            
            Button(action:
                    {
                        withAnimation()
                        {
                            selectedIndex = 2
                        }
            })
            {
                VStack
                {
                    Image(systemName: "message.fill")
                        .font(.title)
                    Text("Messages")
                        .font(.caption2)
                }
            }
            .foregroundColor(Color.primary.opacity(self.selectedIndex == 2 ? 1 : 0.2))
            .offset(y: self.selectedIndex == 2 ? -10 : 0)
            
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
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(Color("AccentColor"))
                    .background(
                        ZStack
                        {
                            Color("ButtonColor")
                            
                            Circle()
                                .foregroundColor(Color("ButtonColor"))
                                .blur(radius: 4)
                                .offset(x: -2, y: -2)
                            
                            Circle()
                                .padding(2)
                                .blur(radius: 2)
                        })
                    .clipShape(Circle())
            }
            .shadow(color: Color("ButtonColor"), radius: 5)
            .offset(y: -25)
            
            Spacer(minLength: 0)
            
            Button(action:
                    {
                        withAnimation()
                        {
                            selectedIndex = 3
                        }
            })
            {
                VStack
                {
                    Image(systemName: "person.3.fill")
                        .font(.title)
                    Text("Friends")
                        .font(.caption2)
                }
            }
            .foregroundColor(Color.primary.opacity(self.selectedIndex == 3 ? 1 : 0.2))
            .offset(y: self.selectedIndex == 3 ? -10 : 0)
            
            Spacer(minLength: 0)
            
            Button(action:
                    {
                        withAnimation()
                        {
                            selectedIndex = 4
                        }
            })
            {
                VStack
                {
                    Image(systemName: "person.fill")
                        .font(.title)
                    Text("Account")
                        .font(.caption2)
                }
            }
            .foregroundColor(Color.primary.opacity(self.selectedIndex == 4 ? 1 : 0.2))
            .offset(y: self.selectedIndex == 4 ? -10 : 0)
        }
        .padding(.horizontal, 35)
        .background(Color.primary.colorInvert())
    }
}
