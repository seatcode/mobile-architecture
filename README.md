# mobile-architecture
Common app layer architecture for iOS and Android + Base code examples

This is the result of great, interesting and long dicussion on the [Metropolis:Lab](https://www.metropolis-lab.io/) about finding the path for a common architecture between platforms. We always loved native code but also believed that architectures could be similar. 

If you want to read about it or follow the general discussion about the architecture take a look at our [blog post on medium](https://medium.com/@elikohen/a-common-mobile-team-and-architecture-573013c59ba6). Also feel free to contribute to our humble project with Issues, Pull Requests or just comments.

- [Android Components](https://github.com/metrolab/mobile-architecture#android-components)
- [iOS Components](https://github.com/metrolab/mobile-architecture#ios-components)


## Android components

- **Coordinator** (Base abstract class): Receives all events from the system and results from the activities so it can manage all the flows.
- **CoordinatedActivity** (Base abstract class): Will receive injections from coordinator + send events to coordinator.
- **ActivityLifecycleObserver**: Implementation of the native observer that will receive lifecycle events of each activity. We will forward those events to the main coordinator and it will forward them to the child and so on.

### Root/initial/app coordinator


On this sample, we show you how to create the root coordinator (`AppCoordinator`) that will be hold by the application:

    override fun onCreate() {
        super.onCreate()

        appCoordinator = AppCoordinator()
        appCoordinator.openMain(this)
    }

That code will trigger the open function on the `AppCoordinator`, but as it is the Root of all, it cannot launch the first activity. It will just receive the one lunched by the system `MainActivity`. So it just needs to provide the viewModel:

    override fun open() {
        val mainViewModel = MainViewModel()
        mainViewModel.navigator = this.weak()

        setMainViewModel(MainActivity::class.java, mainViewModel)
    }
    
That viewModel will be ready to use on MainActivity's `onCreate` method.


### Navigators

Each Coordinator must implement the navigator interface of **all** viewModels it instantiates.

    override fun openYellow() {
        val viewModel = YellowViewModel()
        viewModel.navigator = this.weak() // App Coordinator implements YellowNavigator
        launchActivity(YellowActivity::class.java, viewModel)
    }

as it will be the one receiving each viewModel's navigation events.

#### Restricted navigation
The aim of the usage of Navigators is to restrict at it's minimum the navigation possibilities of each viewModel. We will provide only the navigation methods it makes sense for that view to move. That will avoid mistakes while developing and ugly code.

MainViewModel can only perform two navigation actions through its navigator:

    fun yellowButtonPressed() {
        navigator?.get()?.openYellow()
    }

    fun greenButtonPressed() {
        navigator?.get()?.openGreen()
    }

### Child coordinators

When a navigation flow becomes complex, or AppCoordinator becomes too big, we can decomponse coordinators into childs that will take care of a given flow, or part of a flow. You can see the example on the `GreenCoordinator`. 

Our AppCoordinator doesn't need to launch any green activity, it will just create the green coordinator that will handle all that and open it as a child:

    override fun openGreen() {
        val green = GreenCoordinator()
        openChild(green)
    }

Then GreenCoordinator, as a child, can launch any first activity:

    override fun open() {
        val viewModel = GreenViewModel()
        viewModel.navigator = this.weak()
        launchActivity(GreenActivity::class.java, viewModel)
    }

It just needs to implement GreenNavigator (to receive navigation events from GreenViewModel) and take care of calling `close()` when all navigation flow finishes:

    override fun greenDone() {
        close()
    }
    

## iOS Components

- **Coordinator** (Protocol with extensions): It's extensions add all methods to launch new childs, helpers and child->parent communication.
- **BaseViewController** (Base class with generics): Forces the usage of a viewModel that inherits from BaseViewModel. Will forward lifecycle events to viewModel

### Root/initial/app coordinator

On this sample, we show you how to create the root coordinator (`AppCoordinator`) that will be hold by the appDelegate:

    private var appCoordinator = AppCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            appCoordinator.openOn(window: window)
        }
        
        return true
    }

The root coordinator just implements Coordinator so there's no restriction on how to assign the first view controller to the window. But we thought this is pretty clean. Also it's counterpart on `AppCoordinator`.

The coordinator creates the main controller/s structure on init (could be done later):

    init() {
        let viewModel = MainViewModel()
        self.mainViewController = MainViewController(viewModel: viewModel)
        self.mainNavigationController = UINavigationController(rootViewController: mainViewController)
        viewModel.navigator = self
    }

then when appDelegate calls:

    func openOn(window: UIWindow) {
        window.rootViewController = mainNavigationController
        window.makeKeyAndVisible()
    }
    

### Navigators

Each Coordinator must implement the navigator interface of **all** viewModels it instantiates.

	extension AppCoordinator: MainNavigator {
	    func openYellowProcess() {
	        let viewModel = YellowViewModel()
	        viewModel.navigator = self
	        let viewController = YellowViewController(viewModel: viewModel)
	        mainNavigationController.pushViewController(viewController, animated: true)
	    }
	}

as it will be the one receiving each viewModel's navigation events.

#### Restricted navigation
The aim of the usage of Navigators is to restrict at it's minimum the navigation possibilities of each viewModel. We will provide only the navigation methods it makes sense for that view to move. That will avoid mistakes while developing and ugly code.

MainViewModel can only perform two navigation actions through its navigator:

    func yellowNavigationPressed() {
        navigator?.openYellowProcess()
    }
    
    func greenNavigationPressed() {
        navigator?.openGreenProcess()
    }

### Child coordinators

When a navigation flow becomes complex, or AppCoordinator becomes too big, we can decomponse coordinators into childs that will take care of a given flow, or part of a flow. You can see the example on the `GreenCoordinator`. 

Our AppCoordinator doesn't need to present/push any GreenViewController, it will just crete the green coordinator that will handle all that and open it as a child:

    func openGreenProcess() {
        let greenCoord = GreenCoordinator()
        openChild(coordinator: greenCoord, parent: mainNavigationController, animated: true, forceCloseChild: false, completion: nil)
    }

Then GreenCoordinator, as a child, can launch any first ViewController.
It just needs to implement GreenNavigator (to receive navigation events from GreenViewModel) and take care of calling close() when all navigation flow finishes:

	extension GreenCoordinator: GreenNavigator {
	    func greenFinished() {
	        closeCoordinator(animated: true, completion: nil)
	    }
	}

