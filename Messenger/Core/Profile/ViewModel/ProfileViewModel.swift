

import SwiftUI
import PhotosUI

final class ProfileViewModel: ObservableObject {
    // Переменная для хранения выбранного изображения из PhotosPicker
    // PhotosPickerItem — это объект, который содержит информацию о выбранном медиафайле (фото или видео)
    var selectedItem: PhotosPickerItem? {
        didSet { Task { try await loadImage() } }
    }
    
    // Переменная для хранения загруженного изображения в формате SwiftUI Image
    var profileImage: Image?
    
    private var userID: String = ""

    func configure(with user: User) {
        userID = user.id
        profileImage = ImageFileManager.shared.loadImage(for: userID)
    }
    
    func loadImage() async throws {
        // Проверяем, есть ли выбранное изображение
        guard let item = selectedItem else { return }
        
        guard let imageData = try await item.loadTransferable(type: Data.self),
              let uiImage = UIImage(data: imageData) else {
            return
        }
        // Сохраняем изображение локально
        ImageFileManager.shared.saveImage(uiImage, for: userID)
        
        // Конвертируем UIImage в родной SwiftUI Image и сохраняем в profileImage
        self.profileImage = Image(uiImage: uiImage)
    }
}

