//
//  ContentView.swift
//  Tokyo Sellers spot
//
//  Created by Bishal Aryal on 20/9/7.
//

import SwiftUI
import Foundation

struct ProductGroup: View
{
    @ObservedObject var posts = PostObserver()
    
    var body: some View
    {
        ScrollView(showsIndicators: false)
            {
            ForEach(posts.posts.reversed())
                { product in
                    EachProduct(products: product)
                }
            }
    }
}

struct ProductGroup_Previews: PreviewProvider {
    static var previews: some View {
        ProductGroup()
    }
}

