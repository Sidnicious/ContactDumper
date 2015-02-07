//
//  AppDelegate.swift
//  ContactDumper
//
//  Created by Sidney San Martín on 1/28/15.
//  Copyright (c) 2015 OkCupid. All rights reserved.
//

import UIKit
import AddressBook

extension NSDate {
    
    var ISOString: String {
        get {
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            return dateFormatter.stringFromDate(self)
        }
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let addressBook: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
        
        ABAddressBookRequestAccessWithCompletion(addressBook) {
            if $0.0 == false { return }
            
            let people = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as [ABRecord]
            
            if let json = NSJSONSerialization.dataWithJSONObject(people.map { (person: ABRecord) -> [String: AnyObject] in
                var json = [String: AnyObject]()
                
                for (key, property) in [
                    ("FirstName", kABPersonFirstNameProperty),
                    ("LastName", kABPersonLastNameProperty),
                    ("MiddleName", kABPersonMiddleNameProperty),
                    ("Prefix", kABPersonPrefixProperty),
                    ("Suffix", kABPersonSuffixProperty),
                    ("Nickname", kABPersonNicknameProperty),
                    ("FirstNamePhonetic", kABPersonFirstNamePhoneticProperty),
                    ("LastNamePhonetic", kABPersonLastNamePhoneticProperty),
                    ("MiddleNamePhonetic", kABPersonMiddleNamePhoneticProperty),
                    ("Organization", kABPersonOrganizationProperty),
                    ("JobTitle", kABPersonJobTitleProperty),
                    ("Department", kABPersonDepartmentProperty),
                    ("Email", kABPersonEmailProperty),
                    ("Birthday", kABPersonBirthdayProperty),
                    ("Note", kABPersonNoteProperty),
                    ("CreationDate", kABPersonCreationDateProperty),
                    ("ModificationDate", kABPersonModificationDateProperty),
                    ("Address", kABPersonAddressProperty),
                    ("Date", kABPersonDateProperty),
                    ("Kind", kABPersonKindProperty),
                    ("Phone", kABPersonPhoneProperty),
                    ("InstantMessage", kABPersonInstantMessageProperty),
                    ("URL", kABPersonURLProperty),
                    ("RelatedNames", kABPersonRelatedNamesProperty),
                    ("SocialProfile", kABPersonSocialProfileProperty),
                    ("AlternateBirthday", kABPersonAlternateBirthdayProperty)
                ] {
                    if let val: AnyObject = ABRecordCopyValue(person, property).takeRetainedValue() as AnyObject? {
                        switch Int(ABPersonGetTypeOfProperty(property)) {
                        case kABDateTimePropertyType:
                            json[key] = (val as NSDate).ISOString
                        case kABMultiDateTimePropertyType:
                            if let vals = ABMultiValueCopyArrayOfAllValues(val) {
                                json[key] = (vals.takeRetainedValue() as [NSDate]).map { $0.ISOString }
                            }
                        case kABMultiStringPropertyType, kABMultiIntegerPropertyType, kABMultiRealPropertyType, kABMultiDictionaryPropertyType:
                            if let vals = ABMultiValueCopyArrayOfAllValues(val) {
                                json[key] = vals.takeRetainedValue()
                            }
                        default:
                            json[key] = val
                        }
                    }
                }
                
                return json
            }, options: nil, error: nil) {
                println(NSString(data: json, encoding: NSUTF8StringEncoding)!)
            }
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

