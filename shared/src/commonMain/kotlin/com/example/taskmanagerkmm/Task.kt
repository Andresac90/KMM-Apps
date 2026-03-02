package com.example.taskmanagerkmm

/**
 * Task data class / code runs on android and ios
 */
data class Task(
    val id: String,
    val title: String,
    val description: String = "",
    val isCompleted: Boolean = false,
    val createdAt: Long
)

enum class Priority {
    LOW, MEDIUM, HIGH
}