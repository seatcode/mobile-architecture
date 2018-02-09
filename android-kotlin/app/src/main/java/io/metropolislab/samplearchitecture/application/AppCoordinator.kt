package io.metropolislab.samplearchitecture.application

import io.metropolislab.samplearchitecture.architecture.Coordinator
import io.metropolislab.samplearchitecture.extensions.weak
import io.metropolislab.samplearchitecture.presentation.green.GreenCoordinator
import io.metropolislab.samplearchitecture.presentation.main.MainActivity
import io.metropolislab.samplearchitecture.presentation.main.MainNavigator
import io.metropolislab.samplearchitecture.presentation.main.MainViewModel
import io.metropolislab.samplearchitecture.presentation.yellow.YellowActivity
import io.metropolislab.samplearchitecture.presentation.yellow.YellowNavigator
import io.metropolislab.samplearchitecture.presentation.yellow.YellowViewModel


class AppCoordinator : Coordinator(), MainNavigator, YellowNavigator {


    override fun open() {
        val mainViewModel = MainViewModel(this.weak())

        setMainViewModel(MainActivity::class.java, mainViewModel)
    }

    override fun onMainActivityCreated() {
        // From this point on, you can use the `topActivity`
    }

    override fun onMainActivityLaunched() {
        // From this point on, you know `topActivity` was already started
    }

    //region MAIN NAVIGATOR ---------------------------------------------------------

    override fun openYellow() {
        val viewModel = YellowViewModel(this.weak())
        launchActivity(YellowActivity::class.java, viewModel)
    }

    override fun openGreen() {
        val green = GreenCoordinator()
        openChild(green)
    }

    //endregion


    //region YELLOW NAVIGATOR ---------------------------------------------------------

    override fun yellowDone() {
        val yellow = topActivity as? YellowActivity ?: return
        yellow.finish()
    }

    //endregion
}