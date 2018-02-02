package io.metropolislab.samplearchitecture.application

import android.app.Application
import io.metropolislab.samplearchitecture.presentation.coordinator.MainCoordinator

class SampleApplication: Application() {

    lateinit var mainCoordinator: MainCoordinator

    override fun onCreate() {
        super.onCreate()


        mainCoordinator = MainCoordinator()
        mainCoordinator.openMain(this)
    }
}