package io.metropolislab.samplearchitecture.application

import android.app.Application

class SampleApplication: Application() {

    lateinit var appCoordinator: AppCoordinator

    override fun onCreate() {
        super.onCreate()


        appCoordinator = AppCoordinator()
        appCoordinator.openMain(this)
    }
}