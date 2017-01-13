//
//  HealthkitManager.swift
//  Step Champ
//
//  Created by Darien Sandifer on 8/13/16.
//  Copyright © 2016 Darien Sandifer. All rights reserved.
//

import Foundation
import HealthKit
import SwiftDate
import SwiftyJSON

class HealthkitManager{
    let storage = HKHealthStore()
    
    init(){
        checkAuthorization()
    }
    
    func checkAuthorization() -> Bool{
        // Default to assuming that we're authorized
        var isEnabled = true
        
        // Do we have access to HealthKit on this device?
        if HKHealthStore.isHealthDataAvailable(){
            
            // We have to request each data type explicitly
            let steps = NSSet(object: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!)
            
            // Now we can request authorization for step count data
            storage.requestAuthorization(toShare: nil, read: steps as? Set<HKObjectType>) { (success, error) -> Void in
                isEnabled = success
            }
        }
        else{
            isEnabled = false
        }
        
        return isEnabled
    }

    func recentSteps(completion: @escaping (Double, NSError?) -> () ){
        let today = Date() - 6.days
        let tomorrow = Date() + 1.days
        
        // The type of data we are requesting (this is redundant and could probably be an enumeration
        let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        
        // Our search predicate which will fetch data from now until a day ago
        // (Note, 1.day comes from an extension
        // You'll want to change that to your own NSDate
        let predicate = HKQuery.predicateForSamples(withStart: today, end: tomorrow, options: [])
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        // The actual HealthKit Query which will fetch all of the steps.
        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor]) { query, results, error in
            var steps: Double = 0
            print(results)
            if (results?.count)! > 0{
                for result in results as! [HKQuantitySample]{
                    steps += result.quantity.doubleValue(for: HKUnit.count())
                    
                }
            }
            
            completion(steps, error as NSError?)
        }
        
        storage.execute(query)
    }

    
    func getSteps(startDate: NSDate, endDate: NSDate, completion: @escaping ([JSON], Error?) -> ()) {
        var stepResults = [JSON]()
        var result: [String: AnyObject] = ["date": "" as AnyObject, "steps": 0.0 as AnyObject]
        
        let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        let interval = NSDateComponents()
        interval.day = 1
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate as Date, end: endDate as Date, options: .strictStartDate)
        let query = HKStatisticsCollectionQuery(quantityType: type!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate as Date, intervalComponents:interval as DateComponents)

        query.initialResultsHandler = { query, results, error in
            if let myResults = results{
                myResults.enumerateStatistics(from: startDate as Date, to: endDate as Date) {
                    statistic, stop in
                    
                    if let quantity = statistic.sumQuantity() {
                        let date = statistic.startDate.string(format: DateFormat.custom("yyyy-MM-dd"))
                        let steps = quantity.doubleValue(for: HKUnit.count())
                        
                        result["date"] = date as AnyObject?
                        result["steps"] = steps as AnyObject?
                        stepResults.append(JSON(result))
                    }
                }
                completion(stepResults, error)
            }
        }
        
        storage.execute(query)
    }
}
