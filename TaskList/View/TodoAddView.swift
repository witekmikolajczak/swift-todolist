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
            Section(header: Text("Title")) {
                TextField("Title", text: $newTodo.title)
            }
            Section(header: Text("Description")) {
                TextField("Description", text: $newTodo.description)
            }
            Section(header: Text("Date")) {
                DatePicker("Date", selection: $newTodo.date, displayedComponents: [.date, .hourAndMinute])
            }
            Section(header: Text("Status")) {
                Picker("Status", selection: $newTodo.status) {
                    ForEach(TodoStatus.allCases, id: \.self) { status in
                        Text(status.rawValue.capitalized).tag(status)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
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
