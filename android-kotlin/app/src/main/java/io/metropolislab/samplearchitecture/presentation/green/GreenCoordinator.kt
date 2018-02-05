package io.metropolislab.samplearchitecture.presentation.green

import io.metropolislab.samplearchitecture.architecture.Coordinator
import io.metropolislab.samplearchitecture.extensions.weak

class GreenCoordinator : Coordinator(), GreenNavigator {
    override fun open() {
        val viewModel = GreenViewModel()
        viewModel.navigator = this.weak()
        launchActivity(GreenActivity::class.java, viewModel)
    }

    override fun onMainActivityCreated() {
        // From this point on you can use the `topActivity` that will be the launched GreenActivity
    }

    override fun onMainActivityLaunched() {
        // From this point on you know `topActivity` (GreenActivity) was already started
    }

    //region YELLOW NAVIGATOR ---------------------------------------------------------

    override fun greenDone() {
        close()
    }

    //endregion
}