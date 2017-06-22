//
//  AppDelegate.swift
//  ApplicationSante
//
//  Created by Admin on 20/06/2017.
//  Copyright © 2017 AirOne. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //var dataModel: DataModel
    
    let apiUrl: String = "http://10.1.0.100:3000/persons"
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //dataModel = DataModel()
        
        loadPatients()
        
        refreshFromServer()
        
        return true
    }
    
    //If data not already loaded -> we create defaults data
    func loadPatients() {
        let dataImported = UserDefaults.standard.value(forKey: "dataImported") as? Bool ?? false
        
        if !dataImported {
            //Loading data file
            let fileUrl = Bundle.main.url(forResource: "names", withExtension: "plist")
            
            guard let url = fileUrl, let array = NSArray(contentsOfFile: url.path) else {
                return
            }
            
            loadFromDictionnary(array: array as! [[String : Any]])
        }
    }
    
    func loadFromDictionnary(array: [[String: Any]], keyIsSurname: Bool = false) {
        for dict in array {
            if let dictionnary = dict as? [String:Any] {
                //Getting person datas from file
                let firstname: String
                if keyIsSurname {
                    firstname = dictionnary["surname"] as? String ?? "Error"
                }
                else {
                    firstname = dictionnary["name"] as? String ?? "Error"
                }
                let lastname = dictionnary["lastname"] as? String ?? "Error"
                let isFemale = dictionnary["isFemale"] as? Bool ?? true
                let pictureUrl = dictionnary["pictureUrl"] as? String ?? nil
                let id = dictionnary["id"] as? Int64
                
                //Creating core object
                let personData = Person(entity: Person.entity(), insertInto: persistentContainer.viewContext)
                personData.firstName = firstname
                personData.name = lastname
                personData.isFemale = isFemale
                
                if pictureUrl != nil {
                    personData.pictureUrl = pictureUrl
                }
                
                if id != nil {
                    personData.serverId = id!
                }
            }
        }
        
        //Insert CoreData
        if persistentContainer.commit() {
            //We save that data are now imported
            UserDefaults.standard.set(true, forKey: "dataImported")
        }
    }
    
    func refreshFromServer() {
        let url = URL(string: apiUrl)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            let dictionnary = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            
            guard let jsonDict = dictionnary as? [[String: Any]] else {
                return
            }
            
            //Deleting all datas in local database
            let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
            do {
                let personsInLocalDatabase = try self.persistentContainer.viewContext.fetch(fetchRequest) as [Person]
                
                for person in personsInLocalDatabase {
                    self.persistentContainer.viewContext.delete(person)
                }
                
                self.persistentContainer.commit()
            }
            catch {
                print(error)
            }

            
            
            self.loadFromDictionnary(array: jsonDict, keyIsSurname: true)
        }
        task.resume()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
}

extension NSPersistentContainer {
    func commit() -> Bool {
        do {
            try self.viewContext.save()
            return true
        }
        catch {
            print(error)
            return false
        }
    }
}

extension UIViewController {
    var persistentContainer: NSPersistentContainer {
        get {
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            return appdelegate.persistentContainer
        }
    }
}
