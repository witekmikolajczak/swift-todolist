import SwiftUI

struct ContentView: View {
    @State private var todos: [Todo] = []
    @State private var isAddingNewTodo = false
    @State private var newTodo = Todo(
        id: UUID(),
        title: "",
        description: "",
        date: Date(),
        status: .pending)
    @State private var isEditingTodo = false
    @State private var selectedTodo: Todo?

    init() {
        _todos = State(initialValue: UserDefaults.standard.loadTodos())
    }

    var body: some View {
        NavigationView {
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
            .listStyle(.inset)
            .padding()
            .navigationTitle("Todo List")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: showAddNewTodoView) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $isAddingNewTodo) {
                NavigationView {
                    TodoEditView(
                        todo: $newTodo,
                        title:"Create Todo",
                        onSave: saveNewTodo)
                        .navigationTitle("Add Todo")
                        .navigationBarItems(leading: Button("Cancel") {
                            isAddingNewTodo = false
                        })
                }
            }
            .sheet(item: $selectedTodo) { todo in
                if let index = todos.firstIndex(where: { $0.id == todo.id }) {
                    NavigationView {
                        TodoEditView(
                            todo: $todos[index],
                            title:"Edit Todo",
                            onSave: saveEditedTodo)
                            .navigationTitle("Edit Todo")
                            .navigationBarItems(leading: Button("Cancel") {
                                isEditingTodo = false
                            })
                    }
                }
            }
        }
    }

    private func showAddNewTodoView() {
        newTodo = Todo(id: UUID(), title: "", description: "", date: Date(), status: .pending)
        isAddingNewTodo = true
    }

    private func onEdit(todo: Todo) {
        selectedTodo = todo
        isEditingTodo = true
    }

    private func saveNewTodo() {
        if !newTodo.title.isEmpty {
            todos.append(newTodo)
            UserDefaults.standard.saveTodos(todos)
        }
        isAddingNewTodo = false
    }

    private func saveEditedTodo() {
        UserDefaults.standard.saveTodos(todos)
        isEditingTodo = false
    }

    private func deleteTodos(at offsets: IndexSet) {
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
