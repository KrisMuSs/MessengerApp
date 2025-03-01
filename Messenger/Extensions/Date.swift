
import Foundation

extension Date {
    // Форматирует время в формате "HH:mm" (например, "14:30")
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    // Форматирует дату в формате "MM/dd/yy" (например, "02/29/25")
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateFormat = "MM/dd/yy"
        return formatter
    }
    // Возвращает текущее время в "HH:mm"
    private func timeString() -> String {
        return timeFormatter.string(from: self)
    }
   // Возвращает текущую дату в "MM/dd/yy".
    private func dateString() -> String {
        return dayFormatter.string(from: self)
    }
    
    func timestampString() -> String {
        // Если дата отправки сегодня, вернет время (например, "14:30").
        if Calendar.current.isDateInToday(self){
            return timeString()
        // Если дата отправки вчера, вернет "Yesterday".
        } else if Calendar.current.isDateInYesterday(self){
            return "Yesterday"
        } else {
        // В остальных случаях вернет дату (например, "02/29/25").
            return dateString()
        }
    }
    
    }
