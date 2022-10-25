import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let tabBarController = UITabBarController()
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        tabBarController.viewControllers = [homeVC]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

}

