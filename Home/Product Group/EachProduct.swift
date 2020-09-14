//
//  EachProduct.swift
//  Tokyo Sellers spot
//
//  Created by Bishal Aryal on 20/9/7.
//

import SwiftUI

struct EachProduct: View
{
    @State var buttonText: String = "Buy"
    @State var buttonColor: UIColor = UIColor.systemOrange
    
     var products: ProductDetails
    
    var body: some View
    {
        VStack(alignment: .leading)
        {
            HStack
                {
                    VStack(spacing: 2)
                    {
                        Image(products.userImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill) 
                            .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            .overlay(
                                Circle().stroke(Color.blue, lineWidth: 1))
                            .shadow(radius: 5)
                        
                        Text(products.userName)
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                    
                    Text(products.productName)
                        .font(.headline)
                        .fontWeight(.heavy)
                        .frame(alignment: .leading)
                        .padding()
            }
            
            Text(products.productDescription)
                .font(.subheadline)
                .padding()
            
            ScrollView(.horizontal, showsIndicators: false)
            {
                HStack
                    {
                        ForEach(0..<products.productImage.count)
                        { i in
                            Image(self.products.productImage[i])
                                .resizable()
                                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                }
            }
            
            Text("Price: $\(String(format: "%.2f", products.productPrice))")
                .padding()
                .font(.body)
            
            HStack
                {
                    Button(action: {
                        // when bought
                        self.buttonText = "Sold"
                        self.buttonColor = UIColor.gray
                    })
                    {
                        Text(self.buttonText)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width / 4)
                            .foregroundColor(.white)
                            .background(Color(self.buttonColor))
                            .cornerRadius(20)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // when click
                    })
                    {
                        Text("Message")
                            .padding()
                            .frame(width: UIScreen.main.bounds.width / 4)
                            .foregroundColor(.white)
                            .background(Color(self.buttonColor))
                            .cornerRadius(20)
                    }
            }
            .padding()
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)

    }
}

