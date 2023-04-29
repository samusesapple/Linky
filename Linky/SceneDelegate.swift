//
//  SceneDelegate.swift
//  Linky
//
//  Created by Sam Sung on 2023/04/16.
//

import UIKit
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let sharedUserDefaults = UserDefaultsFileManager.shared

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let mainVC = UINavigationController(rootViewController: MainViewController())
        _ = UINavigationController(rootViewController: FolderViewController(folder: Folder()))
        
        window.rootViewController = mainVC
        window.makeKeyAndVisible()
        
        self.window = window
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        guard let sharedURL = sharedUserDefaults?.array(forKey: SharedUserDefaults.Keys.urlArray) else { return }
        
        for url in sharedURL {
            sendFileToRealm(url: url as! String)
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    // MARK: - send url data to realm
    func sendFileToRealm(url: String) {
        let newLink = Link()

        newLink.folderID = RealmNetworkManager.shared.getFolders()[0].folderID
        newLink.date = Date()
        newLink.urlString = url
        
        // 중복되는 데이터가 있는지 확인 후, 있는 경우 저장 x
        if RealmNetworkManager.shared.getLinks().filter({ link in
            link.urlString == newLink.urlString
        }).count > 0 { print("이미 존재하는 url"); return } else {
            // 저장이 완료된 후, UserDefault에 저장된 배열값 초기화
            RealmNetworkManager.shared.createLink(newLink: newLink)
            sharedUserDefaults?.removeObject(forKey: SharedUserDefaults.Keys.urlArray)
        }
        
    }
    
}
