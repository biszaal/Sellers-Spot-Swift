//
//  ContentView.swift
//  Tokyo Sellers spot
//
//  Created by Bishal Aryal on 20/9/7.
//

import SwiftUI

struct ProductGroup: View
{
    
    var body: some View
    {
        ScrollView(showsIndicators: false)
            {
                ForEach(productsList)
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
