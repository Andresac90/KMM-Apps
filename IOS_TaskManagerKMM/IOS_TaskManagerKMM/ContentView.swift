import SwiftUI
import shared

struct ContentView: View {
    @StateObject private var viewModel = TaskViewModel()
    @State private var showingAddTask = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Platform greeting from shared KMM code!
                Text(Greeting().greet())
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)

                // Stats
                HStack(spacing: 20) {
                    StatView(value: viewModel.pendingCount, label: "Pending", color: .blue)
                    StatView(value: viewModel.completedCount, label: "Done", color: .green)
                    StatView(value: viewModel.tasks.count, label: "Total", color: .purple)
                }
                .padding()

                // Task List
                if viewModel.tasks.isEmpty {
                    Spacer()
                    Text("📭")
                        .font(.system(size: 60))
                    Text("No tasks yet!")
                        .font(.title2)
                    Text("Tap + to add your first task")
                        .foregroundColor(.secondary)
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.tasks, id: \.id) { task in
                            TaskRow(task: task) {
                                viewModel.toggleTask(taskId: task.id)
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                viewModel.deleteTask(taskId: viewModel.tasks[index].id)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("📋 KMM Tasks")
            .toolbar {
                Button(action: { showingAddTask = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView { title, description in
                    viewModel.addTask(title: title, description: description)
                    showingAddTask = false
                }
            }
        }
    }
}

// MARK: - Stat View
struct StatView: View {
    let value: Int
    let label: String
    let color: Color

    var body: some View {
        VStack {
            Text("\(value)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(width: 80)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Task Row
struct TaskRow: View {
    let task: Task
    let onToggle: () -> Void

    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .strikethrough(task.isCompleted)
                    .foregroundColor(task.isCompleted ? .secondary : .primary)

                if !task.description_.isEmpty {
                    Text(task.description_)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Add Task View
struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var description = ""

    let onAdd: (String, String) -> Void

    var body: some View {
        NavigationView {
            Form {
                TextField("Task title", text: $title)
                TextField("Description (optional)", text: $description)
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") { onAdd(title, description) }
                        .disabled(title.isEmpty)
                }
            }
        }
    }
}

// MARK: - View Model
class TaskViewModel: ObservableObject {
    private let repository = TaskRepository()

    @Published var tasks: [Task] = []

    var pendingCount: Int { tasks.filter { !$0.isCompleted }.count }
    var completedCount: Int { tasks.filter { $0.isCompleted }.count }

    init() {
        // Add sample tasks
        repository.addTask(title: "Learn KMM basics", description: "Watch tutorials")
        repository.addTask(title: "Build Task Manager", description: "Follow the guide")
        repository.addTask(title: "Show to Professor Jin", description: "Demo the app")
        refreshTasks()
    }

    func addTask(title: String, description: String) {
        _ = repository.addTask(title: title, description: description)
        refreshTasks()
    }

    func toggleTask(taskId: String) {
        repository.toggleTask(taskId: taskId)
        refreshTasks()
    }

    func deleteTask(taskId: String) {
        repository.deleteTask(taskId: taskId)
        refreshTasks()
    }

    private func refreshTasks() {
        // Simple approach - in production use Combine or async/await
        tasks = repository.tasks.value as? [Task] ?? []
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}