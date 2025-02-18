

import SwiftUI
import PhotosUI

@Observable
final class ProfileViewModel {
    // Переменная для хранения выбранного изображения из PhotosPicker
    // PhotosPickerItem — это объект, который содержит информацию о выбранном медиафайле (фото или видео)
       var selectedItem: PhotosPickerItem? {
           // Когда пользователь выбирает новое изображение, вызывается метод loadImage(), который загружает его
           didSet { Task { try await loadImage() } }
       }
       
    
    // Переменная для хранения загруженного изображения в формате SwiftUI Image
        var profileImage: Image?
 
    func loadImage() async throws{
        
        // Проверяем, есть ли выбранное изображение
        guard let item = selectedItem else { return }
        
        // Загружаем данные изображения в формате Data
        guard let imageData = try await item.loadTransferable(type: Data.self) else { return }
        
        // Преобразуем полученные данные в объект UIImage
        // Это необходимо, так как SwiftUI Image не умеет работать напрямую с Data
        guard let uiImage = UIImage(data: imageData) else { return }
        
        // Конвертируем UIImage в родной SwiftUI Image и сохраняем в profileImage
        self.profileImage = Image(uiImage: uiImage)
    }
    
}
