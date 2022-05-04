//
//  AppDelegate.swift
//  QRker
//
//  Created by  Mr.Ki on 04.05.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let onboardingContainerViewController = OnboardingContainerViewController()
    let tabBarController = UITabBarController()
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = appBackGroundColor
        window?.overrideUserInterfaceStyle = .dark
        onboardingContainerViewController.delegate = self
        
        let vc1 = MainViewController()
        let vc2 = ListViewController()
      
        vc1.tabBarItem.image = UIImage(systemName: "qrcode.viewfinder")
        vc2.tabBarItem.image = UIImage(systemName: "list.bullet.rectangle")

        
        vc1.tabBarController?.tabBar.barTintColor = appBackGroundColor
        vc2.tabBarController?.tabBar.barTintColor = appBackGroundColor
        
        vc1.title = "QR scaner"
        vc2.title = "List"
        
        
        let nc1 = UINavigationController(rootViewController: vc1)
        let nc2 = UINavigationController(rootViewController: vc2)
      //  tabBarController.tabBar.barTintColor = appBackGroundColor
        tabBarController.tabBar.tintColor = appMainColor
        tabBarController.tabBar.unselectedItemTintColor = .lightGray
        tabBarController.viewControllers = [nc1, nc2]
        checkFirstLaunch()
        
        
        return true
    }
    
//
//
//    class ListViewController: UIViewController {
//        override func viewDidLoad() {
//            title = "List"
//            view.backgroundColor = .green
//        }
//    }
    
    // MARK: - Core Data stack

//    lazy var persistentContainer: NSPersistentContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//        */
//        let container = NSPersistentContainer(name: "ListModel")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//
//    // MARK: - Core Data Saving support
//
//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }

   
}

extension AppDelegate {
    func checkFirstLaunch() {
        if LocalState.hasOnboarded {
            setRootViewController(tabBarController)
        } else {
            setRootViewController(onboardingContainerViewController)
            
        }
    }
}

extension AppDelegate: OnboardingContainerViewControllerDelegate {
    func didFinishOnboarding() {
        LocalState.hasOnboarded = true
        setRootViewController(tabBarController)
        
    }
}

//MARK: - Slow transition
extension AppDelegate {
    func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard animated, let window = self.window else {
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            return
        }
        
        window.rootViewController = vc
        window.makeKeyAndVisible()
        UIView.transition(with: window,
                          duration: 0.8,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
}

