//
//  ContentView.swift
//  Sellers Spot
//
//  Created by Bishal Aryal on 20/9/9.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack
        {
        TabView
        {
            HomeMain().tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            
            MessagesMain().tabItem {
                Image(systemName: "message.fill")
                Text("Messages")
            }
            
            AccountMain().tabItem {
                Image(systemName: "person.fill")
                Text("Account")
            }
        }
    }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
