//
//  MessagesMain.swift
//  Tokyo Sellers spot
//
//  Created by Bishal Aryal on 20/9/8.
//

import SwiftUI

struct MessagesMain: View
{
    var body: some View
    {
        NavigationView
        {
            VStack(alignment: .leading)
            {
                Text("Messages")
                    .padding()
                    .font(.title)
                
                List(0 ..< data.count)
                { i in
                    NavigationLink(destination: ChatBoxView(username: data[i].username, userImage: data[i].userImage))
                    {
                        MessagesListView(data: data[i])
                    }
                }
                .background(Color.secondary)
                .cornerRadius(10)
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}
struct MessagesMain_Previews: PreviewProvider {
    static var previews: some View {
        MessagesMain()
    }
}
