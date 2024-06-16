1. **Specyfikację**
2. **Warstwę funkcjonalną**
3. **Warstwę widoku**
4. **Konwencje nazewnicze i formatowanie kodu**
5. **Dokumentację techniczną i przegląd kodu**

### 1. Specyfikacja

#### i. Wymagania funkcjonalne

1. **Dodanie nowego zadania**: System powinien pozwalać użytkownikom na dodawanie nowych zadań z tytułem, opisem, datą realizacji i statusem.
2. **Edycja zadania**: Użytkownicy powinni móc edytować istniejące zadania.
3. **Usuwanie zadania**: Użytkownicy powinni móc usuwać zadania.
4. **Wyświetlanie szczegółów zadania**: Użytkownicy powinni móc przeglądać szczegóły każdego zadania.
5. **Lista zadań**: System powinien wyświetlać listę wszystkich zadań.

#### ii. Wymagania pozafunkcjonalne

1. **Użyteczność**: System powinien mieć intuicyjny interfejs użytkownika, który jest łatwy w nawigacji.
2. **Wydajność**: System powinien szybko ładować i wyświetlać zadania.

#### iii. Opis projektu

Projekt TaskList to aplikacja do zarządzania zadaniami, zbudowana przy użyciu SwiftUI. Pozwala użytkownikom na zarządzanie codziennymi zadaniami poprzez dodawanie, edytowanie, usuwanie i przeglądanie zadań. Każde zadanie zawiera tytuł, opis, datę realizacji i status. Aplikacja ma na celu dostarczenie prostego, ale skutecznego sposobu na organizowanie zadań i zwiększenie produktywności.

#### iv. Potencjalni odbiorcy

1. **Studenci**: Do śledzenia zadań domowych, projektów i terminów.
2. **Profesjonaliści**: Do zarządzania zadaniami w pracy, spotkaniami i terminami.

#### v. Potencjalne korzyści

1. **Lepsza organizacja**: Pomaga użytkownikom utrzymać porządek w zadaniach w jednym miejscu.
2. **Zwiększona produktywność**: Pozwala użytkownikom efektywnie zarządzać czasem i zadaniami.

### 2. Warstwa funkcjonalna

Wymagania funkcjonalne zostały zaimplementowane w następujący sposób:

1. **Dodanie nowego zadania**: Zrealizowane za pomocą `TodoAddView`, które pozwala użytkownikom wprowadzać szczegóły zadania i zapisać nowe zadanie.
2. **Edycja zadania**: Zrealizowane za pomocą `TodoEditView`, które pozwala użytkownikom modyfikować istniejące zadania.
3. **Usuwanie zadania**: Zrealizowane w `ContentView`, gdzie użytkownicy mogą przesunąć, aby usunąć zadania.
4. **Wyświetlanie szczegółów zadania**: Zrealizowane za pomocą `TodoDetailView`, które pokazuje szczegóły zadania.
5. **Lista zadań**: Zrealizowane w `ContentView`, które wyświetla listę zadań.

### 3. Warstwa widoku

#### i. Zgodność z warstwą kliencką

Warstwa kliencka jest zgodna z wymaganiami funkcjonalnymi, zapewniając przyjazny dla użytkownika interfejs do dodawania, edytowania, przeglądania i usuwania zadań.

#### ii. Separacja logiki od widoku

Logika została oddzielona od komponentów widoku w następujący sposób:

- **TodoFormSections.swift**: Reużywalny komponent dla sekcji formularza używanych zarówno w `TodoAddView`, jak i `TodoEditView`.
- **ContentView.swift**: Zarządza listą zadań i nawigacją.
- **UserDefaults.swift**: Obsługuje przechowywanie i pobieranie zadań.

### 4. Konwencje nazewnicze i formatowanie kodu

Kod jest zgodny z konwencjami nazewniczymi i zasadami formatowania typowymi dla Swift, w tym użyciem camelCase dla zmiennych i funkcji oraz PascalCase dla typów. Bloki kodu są odpowiednio wcięte i skomentowane tam, gdzie jest to konieczne.

### 5. Dokumentacja techniczna i przegląd kodu

Ta sekcja zapewnia przegląd komponentów technicznych i przegląd kodu.

#### TaskListApp.swift

```swift


import SwiftUI

@main
struct TaskListApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

Ten plik zawiera główny punkt wejścia aplikacji, ustawiając `ContentView` jako widok początkowy.

#### UserDefaults.swift

```swift
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
```

Ten plik dostarcza metody do zapisywania i ładowania zadań za pomocą `UserDefaults`.

#### Todo.swift

```swift
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
```

Ten plik definiuje model `Todo` i jego właściwości.

#### ContentView.swift

```swift
import SwiftUI

struct ContentView: View {
    @State private var todos: [Todo] = []
    @State private var isAddingNewTodo = false
    @State private var selectedTodo: Todo?

    init() {
        _todos = State(initialValue: UserDefaults.standard.loadTodos())
    }

    var body: some View {
        NavigationView {
            VStack {
                todoList
            }
            .navigationTitle("Todo List")
            .navigationBarItems(leading: EditButton(), trailing: addButton)
            .sheet(isPresented: $isAddingNewTodo, content: addTodoView)
            .sheet(item: $selectedTodo, content: editTodoView)
        }
    }

    private var todoList: some View {
        List {
            ForEach($todos) { $todo in
                NavigationLink(destination: TodoDetailView(todo: $todo, onEdit: {
                    onEdit(todo: todo)
                })) {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Text(todo.title)
                                .font(.title3)
                            Text(formatDate(todo.date))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        StatusIndicator(status: todo.status)
                    }
                }
            }
            .onDelete(perform: deleteTodos)
            .onMove(perform: moveTodos)
        }
        .listStyle(InsetListStyle())
        .padding()
    }

    private var addButton: some View {
        Button(action: showAddNewTodoView) {
            Image(systemName: "plus")
        }
    }

    private func addTodoView() -> some View {
        NavigationView {
            TodoAddView(onSave: saveNewTodo)
                .navigationTitle("Add Todo")
        }
    }

    private func editTodoView(todo: Todo) -> some View {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            return AnyView(
                NavigationView {
                    TodoEditView(
                        todo: $todos[index],
                        title: "Edit Todo",
                        onSave: saveEditedTodo)
                        .navigationTitle("Edit Todo")
                }
            )
        } else {
            return AnyView(EmptyView())
        }
    }

    private func showAddNewTodoView() {
        isAddingNewTodo = true
    }

    private func onEdit(todo: Todo) {
        selectedTodo = todo
    }

    private func saveNewTodo(newTodo: Todo) {
        if !newTodo.title.isEmpty {
            todos.append(newTodo)
            UserDefaults.standard.saveTodos(todos)
        }
        isAddingNewTodo = false
    }

    private func saveEditedTodo() {
        UserDefaults.standard.saveTodos(todos)
    }

    private

 func deleteTodos(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
        UserDefaults.standard.saveTodos(todos)
    }

    private func moveTodos(from source: IndexSet, to destination: Int) {
        todos.move(fromOffsets: source, toOffset: destination)
        UserDefaults.standard.saveTodos(todos)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```

Ten plik zawiera główny widok aplikacji, zarządzając listą zadań i nawigacją do innych widoków.

#### StatusIndicator.swift

```swift
import SwiftUI

struct StatusIndicator: View {
    var status: TodoStatus

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 10, height: 10)
    }

    private var color: Color {
        switch status {
        case .pending:
            return .yellow
        case .completed:
            return .green
        }
    }
}
```

Ten plik dostarcza wizualny wskaźnik statusu zadania.

#### TodoAddView.swift

```swift
import SwiftUI

struct TodoAddView: View {
    @State private var newTodo = Todo(
        id: UUID(),
        title: "",
        description: "",
        date: Date(),
        status: .pending)
    var onSave: (Todo) -> Void
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            TodoFormSections(todo: $newTodo)
        }
        .navigationTitle("Add Todo")
        .navigationBarItems(leading: Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        }, trailing: Button("Save") {
            onSave(newTodo)
            presentationMode.wrappedValue.dismiss()
        })
    }
}
```

Ten plik dostarcza widok do dodawania nowego zadania.

#### TodoDetailView.swift

```swift
import SwiftUI

struct TodoDetailView: View {
    @Binding var todo: Todo
    var onEdit: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(todo.title)
                .font(.title)
                .bold()
            Text(todo.description)
                .font(.title2)
            Text(formatDate(todo.date))
                .font(.subheadline)
                .foregroundColor(.gray)
            StatusIndicator(status: todo.status)
            Spacer()
            Button("Edit") {
                onEdit()
            }
            .padding()
        }
        .padding()
        .navigationTitle("Todo Details")
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
```

Ten plik dostarcza widok do wyświetlania szczegółów zadania.

#### TodoEditView.swift

```swift
import SwiftUI

struct TodoEditView: View {
    @Binding var todo: Todo
    var title: String
    var onSave: () -> Void
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            TodoFormSections(todo: $todo)
        }
        .navigationTitle(title)
        .navigationBarItems(
            leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            },
            trailing: Button("Save") {
                onSave()
                presentationMode.wrappedValue.dismiss()
            }
        )
    }
}
```

Ten plik dostarcza widok do edytowania istniejącego zadania.

#### TodoFormSections.swift

```swift
import SwiftUI

struct TodoFormSections: View {
    @Binding var todo: Todo

    var body: some View {
        Section(header: Text("Title")) {
            TextField("Title", text: $todo.title)
        }
        Section(header: Text("Description")) {
            TextField("Description", text: $todo.description)
        }
        Section(header: Text("Date")) {
            DatePicker("Date", selection: $todo.date, displayedComponents: [.date, .hourAndMinute])
        }
        Section(header: Text("Status")) {
            Picker("Status", selection: $todo.status) {
                ForEach(TodoStatus.allCases, id: \.self) { status in
                    Text(status.rawValue.capitalized).tag(status)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}
```
