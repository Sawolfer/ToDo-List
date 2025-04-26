//
//  AppSettings.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 26.04.2025.
//

import Foundation

class AppSettings {
    private enum Keys {
        static let hasLoadedInitialTasks = "hasLoadedInitialTasks"
    }

    static var hasLoadedInitialTasks: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.hasLoadedInitialTasks)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.hasLoadedInitialTasks)
        }
    }

    static var isFirstLaunch: Bool {
        return !hasLoadedInitialTasks
    }
}
