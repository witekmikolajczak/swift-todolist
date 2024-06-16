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
