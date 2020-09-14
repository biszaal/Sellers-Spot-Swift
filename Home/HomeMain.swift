//
//  HomeMain.swift
//  Sellers Spot
//
//  Created by Bishal Aryal on 20/9/8.
//

import SwiftUI

struct HomeMain: View
{
    @State var searchTextField: String = ""
    
    var body: some View
    {
        VStack(alignment: .leading)
        {
            HStack
            {
                HStack
                {
                    Image(systemName: "magnifyingglass")
                        .padding()
                        .foregroundColor(.secondary)
                    TextField("Search", text: $searchTextField)
                    
                }
                .frame(width: UIScreen.main.bounds.width / 1.5, height: 50, alignment: .leading)
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(Color.gray, lineWidth: 1))
                .shadow(radius: 5)
                
                Spacer()
                
                Button(action: {
                    
                })
                {
                    Image(systemName: "plus")
                        .padding()
                        .font(.title)
                        .background(Color(UIColor.systemBlue))
                        .foregroundColor(.primary).colorInvert()
                        .clipShape(Circle())
                }
            }
            .padding()
            
            ProductGroup()
        }
    }
}

struct HomeMain_Previews: PreviewProvider {
    static var previews: some View {
        HomeMain()
    }
}
