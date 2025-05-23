import Foundation
import SwiftUI
import Combine

// Менеджер для сохранения и загрузки изображений пользователя, локально на устройстве
final class ImageFileManager: ObservableObject {
    static let shared = ImageFileManager()
    
    // Это способ отправлять сигналы другим частям приложения, когда что-то произошло (в моем случае, когда у пользователя обновилось изображение профиля)
    // PassthroughSubject - тип "издателя", который может отправлять события (значения) подписчикам вручную
    // <String, Never>
    // String — тип данных, который передаётся при событии (в моем случае userID)
    // Never - тип ошибки, которая может случиться. Never значит, что ошибок не будет
    
    let imageDidChange = PassthroughSubject<String, Never>() // Уведомления по userID
                  
    // Имя папки, в которой будут храниться изображения
       private let folderName = "ProfileImages"
    
    // Проверяет, существует ли папка, и создаёт её при необходимости
    private func createFolderIfNeeded() {
        let folderURL = getFolderURL()
        if !FileManager.default.fileExists(atPath: folderURL.path) {
            // Пытаемся создать папку, но если ошибка — просто игнорируем (без краша)
            try? FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
        }
    }
    // Возвращает URL к папке хранения изображений в папке документов
    private func getFolderURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(folderName)
    }
    // Получает URL конкретного изображения пользователя по его ID
    private func getImageURL(for id: String) -> URL {
        getFolderURL().appendingPathComponent("\(id).png")
    }
    
    // Сохраняет изображение пользователя в PNG формате по его userID
    func saveImage(_ image: UIImage, for userID: String) {
            createFolderIfNeeded()
            
            // Преобразуем картинку в формат PNG
            guard let data = image.pngData() else { return }
            
            // Получаем путь для сохранения файла
            let url = getImageURL(for: userID)
            
            // Пытаемся записать данные картинки в файл
            try? data.write(to: url)
            
            // Сообщаем всем, что фото этого пользователя обновилось
            imageDidChange.send(userID)
        }
    
    // Загружает изображение для данного userID, если оно есть
    func loadImage(for userID: String) -> Image? {
        let url = getImageURL(for: userID)
        
        // Пытаемся прочитать данные файла, если не получилось возвращаем nil
        guard let data = try? Data(contentsOf: url) else { return nil }
            
        // Создаём UIImage из данных, если не удалось возвращаем nil
        guard let uiImage = UIImage(data: data) else { return nil }
               
        // Создаём SwiftUI Image из UIImage и возвращаем
        return Image(uiImage: uiImage)
    }
}
