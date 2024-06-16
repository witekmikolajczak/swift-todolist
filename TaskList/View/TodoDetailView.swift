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
