import Foundation
import SwiftUI
import Combine

class ImageLoader: ObservableObject
{
    @Published var downloadImage: UIImage?
    
    func fetchImage(url: String)
    {
        guard let imageURL = URL(string: url)
        else {
            return
        }
        
        URLSession.shared.dataTask(with: imageURL)
        { data, response, error in
            guard let data = data, error == nil else
            {
                fatalError("error reading image")
            }
            
            DispatchQueue.main.async
                {
                self.downloadImage = UIImage(data: data)
            }
        }.resume()
    }
}
