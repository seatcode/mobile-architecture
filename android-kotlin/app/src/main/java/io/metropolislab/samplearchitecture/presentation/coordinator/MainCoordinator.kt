package io.metropolislab.samplearchitecture.presentation.coordinator

import io.metropolislab.samplearchitecture.architecture.Coordinator
import io.metropolislab.samplearchitecture.extensions.weak
import io.metropolislab.samplearchitecture.presentation.main.MainActivity
import io.metropolislab.samplearchitecture.presentation.main.MainViewModel


class MainCoordinator: Coordinator(), MainNavigator {


    override fun open() {
        val mainViewModel = MainViewModel()
        mainViewModel.navigator = this.weak()

        setMainViewModel(MainActivity::class.java, mainViewModel)
    }

    override fun onMainActivityCreated() {
        // From this point on you can use the `topActivity`
    }

    override fun onMainActivityLaunched() {
        // From this point on you know `topActivity` was already started
    }

}