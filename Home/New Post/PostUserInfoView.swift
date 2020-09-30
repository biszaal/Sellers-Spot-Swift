//
//  PostUserInfoView.swift
//  Sellers Spot
//
//  Created by Bishal Aryal on 20/9/19.
//  Copyright © 2020 Bishal Aryal. All rights reserved.
//

import SwiftUI

struct PostUserInfoView: View
{
    var username: String
    var userEmail: String
    var userImage: String
    
    var body: some View
    {
        HStack
            {
                RemoteImage(url: userImage)
                    .frame(width: 40, height: 40)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .overlay(
                        Circle().stroke(Color.blue, lineWidth: 1))
                    .shadow(radius: 5)
                
                VStack(alignment: .leading)
                {
                    Text(username)
                    Text(userEmail)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
        }
    }
}
