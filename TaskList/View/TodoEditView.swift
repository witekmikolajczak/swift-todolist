import SwiftUI

struct TodoEditView: View {
    @Binding var todo: Todo
    var title: String
    var onSave: () -> Void
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
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
