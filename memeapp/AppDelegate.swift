//
//  AppDelegate.swift
//  memeapp
//
//  Created by Khoa on 01/03/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var memes: [Meme] {
            get {
                if let array = UserDefaults.standard.data(forKey: "memes"),
                   let decodedMemes = try? JSONDecoder().decode([Meme].self, from: array) {
                    return decodedMemes
                } else {
                    return []
                }
            }
            set {
                if let encodedMemes = try? JSONEncoder().encode(newValue) {
                    UserDefaults.standard.set(encodedMemes, forKey: "memes")
                } else {
                    print("Failed to encode memes array.")
                }
            }
        }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

