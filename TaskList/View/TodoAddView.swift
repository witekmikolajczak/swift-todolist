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
