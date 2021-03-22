//
//  SceneDelegate.swift
//  Reminders
//
//  Created by Максим Громов on 19.03.2021.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?


  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let contentView = ContentView().environment(\.managedObjectContext, context)
    if let windowScene = scene as? UIWindowScene {
        let window = UIWindow(windowScene: windowScene)
      window.rootViewController = UIHostingController(rootView: contentView.environmentObject(IconNames()))
        self.window = window
        window.makeKeyAndVisible()
    }
  }

  func sceneDidDisconnect(_ scene: UIScene) {
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
  }

  func sceneWillResignActive(_ scene: UIScene) {
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
  }


}


class IconNames: ObservableObject {
  
  var iconNames: [String?] = [nil]
  @Published var currentIndex = 0
  
  init() {
    getAlternateIconNames()
    if let currentIcon = UIApplication.shared.alternateIconName {
      self.currentIndex = iconNames.firstIndex(of: currentIcon) ?? 0
    }
  }
  
  func getAlternateIconNames() {
    if let icons = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
       let alternateIcons = icons["CFBundleAlternateIcons"] as? [String: Any] {
      for (_, value) in alternateIcons {
        guard let iconList = value as? Dictionary<String,Any> else { return }
        guard let iconFiles = iconList["CFBundleIconFiles"] as? [String] else { return }
        guard let icon = iconFiles.first else { return }
        iconNames.append(icon)
      }
    }
  }
}

