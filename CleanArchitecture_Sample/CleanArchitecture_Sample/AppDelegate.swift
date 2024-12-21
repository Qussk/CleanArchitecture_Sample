//
//  AppDelegate.swift
//  CleanArchitecture_Sample
//
//  Created by 변윤나 on 12/18/24.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("====================")
      //  print("accessToken: \(UserDefaults.accessToken)")

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
    
    //MARK: -Cole Data stack
    /*
     extension으로 빼지 못하는 이유 : extension은 저장 프로퍼티를 정의할 수 없고, 계산 프로퍼티만 정의할 수 있음.
     lazy var = 저장 프로퍼티
     계산 프로퍼티로 변경하면 동작은 가능하나, 계산 프로퍼티는 호출 할 때마다 값을 생성하기 때문에 CoreData의 NSPersistentContainer처럼 한번만 초기화 해야하는 경우에는 적합하지 않음. 그래서 저장 프로퍼티가 맞음.
     구조상 싱글톤으로 정의하거나 AppDelegate내부에서 관리하는 방법이 적합.
     */
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CleanArchitecture_Sample")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolver error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

}

