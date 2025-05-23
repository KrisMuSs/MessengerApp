
import SwiftUI

// Все размеры, которые нам понадобятся для размера изображения в профиле
enum ProfileImageSize{
    case xxSmall
    case xSmall
    case small
    case medium
    case large
    case xLarge
    
    var dimension: CGFloat{
        switch self {
        case .xxSmall: return 28
        case .xSmall: return 32
        case .small: return 40
        case .medium: return 56
        case .large: return 64
        case .xLarge: return 80
        }
        }
    }

struct CircularProfileImageView: View {
    var user: User?
    let size: ProfileImageSize
    @State private var currentImage: Image?
    
    var body: some View {
        Group {
            if let currentImage {
                currentImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.dimension, height: size.dimension)
                    .clipShape(Circle())
                   }
                   else{
                       Image(systemName: "person.circle.fill")
                           .resizable()
                           .frame(width: size.dimension, height: size.dimension)
                           .foregroundStyle(Color(.systemGray4))
                   }
        }
        .onAppear {
            loadImage()
        }
        .onReceive(ImageFileManager.shared.imageDidChange) { changedUserID in
            if user?.id == changedUserID {
                loadImage()
            }
        }
    }
    
    private func loadImage() {
        guard let user = user else {
            currentImage = nil
            return
        }
        currentImage = ImageFileManager.shared.loadImage(for: user.id)
    }
}


#Preview {
    CircularProfileImageView(user: User.MOCK_USER, size: .xLarge)
}
