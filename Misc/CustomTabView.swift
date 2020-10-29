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
                        withAnimation(.spring())
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
                        .font(.system(size: 10))
                }
            }
            .foregroundColor(self.selectedIndex == 1 ? Color("ButtonColor") : .secondary)
            .offset(y: self.selectedIndex == 1 ? -10 : 0)
            
            Spacer(minLength: 0)
            
            Button(action:
                    {
                        withAnimation(.spring())
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
                        .font(.system(size: 10))
                }
            }
            .foregroundColor(self.selectedIndex == 2 ? Color("ButtonColor") : .secondary)
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
                    .foregroundColor(.secondary)
                    .colorInvert()
                    .background(
                        ZStack
                        {
                            
                            Circle()
                                .foregroundColor(Color(#colorLiteral(red: 0.01822857372, green: 0.2216099203, blue: 0.4166321754, alpha: 1)))
                                .blur(radius: 4)
                                .offset(y: 5)
                            
                            Circle()
                                .foregroundColor(Color("ButtonColor"))
                                .padding(3)
                                .blur(radius: 2)
                        })
                    .clipShape(Circle())
            }
            .shadow(color: Color("ButtonColor"), radius: 5, y: 3)
            .offset(y: -20)
            
            Spacer(minLength: 0)
            
            Button(action:
                    {
                        withAnimation(.spring())
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
                        .font(.system(size: 10))
                }
            }
            .foregroundColor(self.selectedIndex == 3 ? Color("ButtonColor") : .secondary)
            .offset(y: self.selectedIndex == 3 ? -10 : 0)
            
            Spacer(minLength: 0)
            
            Button(action:
                    {
                        withAnimation(.spring())
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
                        .font(.system(size: 10))
                }
            }
            .foregroundColor(self.selectedIndex == 4 ? Color("ButtonColor") : .secondary)
            .offset(y: self.selectedIndex == 4 ? -10 : 0)
        }
        .padding(.horizontal, 35)
        .padding(.bottom, 20)
        .background(Color.secondary.colorInvert())
    }
}
