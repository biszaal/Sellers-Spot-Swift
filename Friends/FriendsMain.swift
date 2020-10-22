//
//  FriendsMain.swift
//  Sellers Spot
//
//  Created by Bishal Aryal on २०/१०/१२.
//  Copyright © 2020 Bishal Aryal. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct FriendsMain: View
{
    @ObservedObject var user = UserDataObserver()
    
    var body: some View
    {
        NavigationView
        {
            List(user.userData)
            {   each in
                HStack
                {
                    WebImage(url: URL(string: each.image))
                        .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .overlay(
                        Circle().stroke(Color.blue, lineWidth: 1))
                    .shadow(radius: 5)
                    
                    Text(each.name)
                        .font(.body)
                }
            }
            .navigationTitle("Friends")
        }
        .onAppear()
        {
            user.fetchData()
        }
    }
}

struct FriendsMain_Previews: PreviewProvider {
    static var previews: some View {
        FriendsMain()
    }
}
