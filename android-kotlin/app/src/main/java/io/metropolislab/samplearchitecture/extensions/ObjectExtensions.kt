package io.metropolislab.samplearchitecture.extensions

import android.support.v7.app.AppCompatActivity
import java.lang.ref.WeakReference

fun <T> T.weak(): WeakReference<T> = WeakReference(this)

inline fun <reified T> WeakReference<AppCompatActivity>.asClass(): T? {
    val weakRef = this.get()
    return if (weakRef is T) {
        weakRef
    } else {
        null
    }
}