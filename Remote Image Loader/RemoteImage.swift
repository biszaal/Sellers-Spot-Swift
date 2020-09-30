import SwiftUI

struct RemoteImage: View
{
    @ObservedObject var imageLoader = ImageLoader()
    
    var placeholder: Image
    
    init(url: String, placeholder: Image = Image(systemName: "photo"))
    {
        self.placeholder = placeholder
        imageLoader.fetchImage(url: url)
    }
    
    var body: some View
    {
        if let image = self.imageLoader.downloadImage
        {
            return Image(uiImage: image)
                .resizable()
        }
        
        return placeholder
    }
}
