package com.example.taskmanagerkmm

import java.util.UUID

actual fun getPlatformName(): String = "Android"

actual fun getCurrentTimeMillis(): Long = System.currentTimeMillis()

actual fun randomUUID(): String = UUID.randomUUID().toString()