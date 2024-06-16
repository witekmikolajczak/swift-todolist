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
