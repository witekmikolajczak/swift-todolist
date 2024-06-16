import SwiftUI

struct StatusIndicator: View {
    var status: TodoStatus

    var body: some View {
        Text(status.rawValue.capitalized)
            .font(.caption)
            .padding(5)
            .background(status == .completed ? Color.green : Color.orange)
            .foregroundColor(.white)
            .cornerRadius(5)
    }
}
