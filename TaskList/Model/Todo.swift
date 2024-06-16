import Foundation

enum TodoStatus: String, CaseIterable, Codable {
    case pending
    case completed
}

struct Todo: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var description: String
    var date: Date
    var status: TodoStatus
}

// Helper function to create Date instances from components
func createDate(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    components.hour = hour
    components.minute = minute
    components.timeZone = TimeZone.current
    let calendar = Calendar.current
    return calendar.date(from: components)!
}
