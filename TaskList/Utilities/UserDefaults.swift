import Foundation

extension UserDefaults {
    private enum Keys {
        static let todos = "todos"
    }
    
    func saveTodos(_ todos: [Todo]) {
        if let encoded = try? JSONEncoder().encode(todos) {
            set(encoded, forKey: Keys.todos)
        }
    }
    
    func loadTodos() -> [Todo] {
        if let savedTodos = data(forKey: Keys.todos) {
            if let decodedTodos = try? JSONDecoder().decode([Todo].self, from: savedTodos) {
                return decodedTodos
            }
        }
        return []
    }
}
