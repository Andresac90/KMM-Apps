package com.example.taskmanagerkmm

// We expect each platform to tell us its name
expect fun getPlatformName(): String

// We expect each platform to give us the current time
expect fun getCurrentTimeMillis(): Long

// We expect each platform to generate unique IDs
expect fun randomUUID(): String