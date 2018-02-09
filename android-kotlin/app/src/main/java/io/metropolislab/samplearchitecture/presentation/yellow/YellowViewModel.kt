package io.metropolislab.samplearchitecture.presentation.yellow

import io.metropolislab.samplearchitecture.architecture.BaseViewModel
import java.lang.ref.WeakReference

class YellowViewModel(val navigator: WeakReference<YellowNavigator>) : BaseViewModel() {

    fun onBackPressed() {
        navigator.get()?.yellowDone()
    }
}