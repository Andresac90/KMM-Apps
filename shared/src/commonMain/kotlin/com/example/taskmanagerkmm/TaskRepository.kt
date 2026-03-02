package com.example.taskmanagerkmm

import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow

/**
 * TaskRepository - Manages all task operations
 */
class TaskRepository {

    // Private mutable list
    private val _tasks = MutableStateFlow<List<Task>>(emptyList())

    // Public read-only flow (UI observes this)
    val tasks: StateFlow<List<Task>> = _tasks.asStateFlow()

    //add new task
    fun addTask(title: String, description: String = ""): Task {
        val newTask = Task(
            id = randomUUID(),
            title = title,
            description = description,
            isCompleted = false,
            createdAt = getCurrentTimeMillis()
        )
        _tasks.value = _tasks.value + newTask
        return newTask
    }

    fun toggleTask(taskId: String) {
        _tasks.value = _tasks.value.map { task ->
            if (task.id == taskId) {
                task.copy(isCompleted = !task.isCompleted)
            } else {
                task
            }
        }
    }

    fun deleteTask(taskId: String) {
        _tasks.value = _tasks.value.filter { it.id != taskId }
    }

    fun getPendingCount(): Int = _tasks.value.count { !it.isCompleted }

    fun getCompletedCount(): Int = _tasks.value.count { it.isCompleted }

    fun clearCompleted() {
        _tasks.value = _tasks.value.filter { !it.isCompleted }
    }
}