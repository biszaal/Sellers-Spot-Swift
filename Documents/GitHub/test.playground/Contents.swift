//
//  Blocks.swift
//  biszaalGame
//
//  Created by Bishal Aryal on 2020/03/11.
//  Copyright © 2020 Bishal Aryal. All rights reserved.
//

import Foundation
import SwiftUI

var touchlocation = [[String]]()

struct Blocks: View
{
    
    var body: some View
    {
        
        VStack
            {
                
                HStack
                    {
                        
                        touchlocation [0][0] = randomIcon()
                        Image(touchlocation [0][0]).onTapGesture
                            {
                        }
                        
                        touchlocation [0][1] = randomIcon()
                        Image(touchlocation [0][1]).onTapGesture
                            {
                        }
                        
                        touchlocation [0][2] = randomIcon()
                        Image(touchlocation [0][2]).onTapGesture
                            {
                        }
                        
                        touchlocation [0][3] = randomIcon()
                        Image(touchlocation [0][3]).onTapGesture
                            {
                        }
                        
                        touchlocation [0][4] = randomIcon()
                        Image(touchlocation [0][4]).onTapGesture
                            {
                        }
                        
                }
                
                HStack
                    {
                        
                        touchlocation [1][0] = randomIcon()
                        Image(touchlocation [1][0]).onTapGesture
                            {
                        }
                        
                        touchlocation [1][1] = randomIcon()
                        Image(touchlocation [1][1]).onTapGesture
                            {
                        }
                        
                        touchlocation [1][2] = randomIcon()
                        Image(touchlocation [1][2]).onTapGesture
                            {
                        }
                        
                        touchlocation [1][3] = randomIcon()
                        Image(touchlocation [1][3]).onTapGesture
                            {
                        }
                        
                        touchlocation [1][4] = randomIcon()
                        Image(touchlocation [1][4]).onTapGesture
                            {
                        }
                        
                }
                
                HStack
                    {
                        
                        touchlocation [2][0] = randomIcon()
                        Image(touchlocation [2][0]).onTapGesture
                            {
                        }
                        
                        touchlocation [2][1] = randomIcon()
                        Image(touchlocation [2][1]).onTapGesture
                            {
                        }
                        
                        touchlocation [2][2] = randomIcon()
                        Image(touchlocation [2][2]).onTapGesture
                            {
                        }
                        
                        touchlocation [2][3] = randomIcon()
                        Image(touchlocation [2][3]).onTapGesture
                            {
                        }
                        
                        touchlocation [2][4] = randomIcon()
                        Image(touchlocation [2][4]).onTapGesture
                            {
                        }
                        
                }
                
                HStack
                    {
                        
                        touchlocation [3][0] = randomIcon()
                        Image(touchlocation [3][0]).onTapGesture
                            {
                        }
                        
                        touchlocation [3][1] = randomIcon()
                        Image(touchlocation [3][1]).onTapGesture
                            {
                        }
                        
                        touchlocation [3][2] = randomIcon()
                        Image(touchlocation [3][2]).onTapGesture
                            {
                        }
                        
                        touchlocation [3][3] = randomIcon()
                        Image(touchlocation [3][3]).onTapGesture
                            {
                        }
                        
                        touchlocation [3][4] = randomIcon()
                        Image(touchlocation [3][4]).onTapGesture
                            {
                        }
                }
                
                HStack
                    {
                        
                        touchlocation [4][0] = randomIcon()
                        Image(touchlocation [0][0]).onTapGesture
                            {
                        }
                        
                        touchlocation [4][1] = randomIcon()
                        Image(touchlocation [4][1]).onTapGesture
                            {
                        }
                        
                        touchlocation [4][2] = randomIcon()
                        Image(touchlocation [4][2]).onTapGesture
                            {
                        }
                        
                        touchlocation [4][3] = randomIcon()
                        Image(touchlocation [4][3]).onTapGesture
                            {
                        }
                        
                        touchlocation [4][4] = randomIcon()
                        Image(touchlocation [4][4]).onTapGesture
                            {
                        }
                }
                
                HStack
                    {
                        
                        touchlocation [5][0] = randomIcon()
                        Image(touchlocation [5][0]).onTapGesture
                            {
                        }
                        
                        touchlocation [5][1] = randomIcon()
                        Image(touchlocation [5][1]).onTapGesture
                            {
                        }
                        
                        touchlocation [5][2] = randomIcon()
                        Image(touchlocation [5][2]).onTapGesture
                            {
                        }
                        
                        touchlocation [5][3] = randomIcon()
                        Image(touchlocation [5][3]).onTapGesture
                            {
                        }
                        
                        touchlocation [5][4] = randomIcon()
                        Image(touchlocation [5][4]).onTapGesture
                            {
                        }
                }
                
                HStack
                    {
                        
                        touchlocation [6][0] = randomIcon()
                        Image(touchlocation [6][0]).onTapGesture
                            {
                        }
                        
                        touchlocation [6][1] = randomIcon()
                        Image(touchlocation [6][1]).onTapGesture
                            {
                        }
                        
                        touchlocation [6][2] = randomIcon()
                        Image(touchlocation [6][2]).onTapGesture
                            {
                        }
                        
                        touchlocation [6][3] = randomIcon()
                        Image(touchlocation [6][3]).onTapGesture
                            {
                        }
                        
                        touchlocation [6][4] = randomIcon()
                        Image(touchlocation [6][4]).onTapGesture
                            {
                        }
                }
        }
        .padding(.bottom, -250.0)
        
    }
    
}

func touchInput ()
{
    
    
    
}

func randomIcon () -> String
{
    let icons = ["facebook", "instagram", "snapchat", "youtube", "twitter"]
    return icons.randomElement()!
}

#if DEBUG

struct Blocks_Prievews: PreviewProvider {
    static var previews: some View {
        Blocks()
    }
}
#endif
