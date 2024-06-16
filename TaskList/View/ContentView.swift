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
