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
            let steps = NSSet(object: HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!)
            
            // Now we can request authorization for step count data
            storage.requestAuthorizationToShareTypes(nil, readTypes: steps as? Set<HKObjectType>) { (success, error) -> Void in
                isEnabled = success
            }
        }
        else{
            isEnabled = false
        }
        
        return isEnabled
    }

    func recentSteps(completion: (Double, NSError?) -> () ){
        let today = NSDate.today()-6.days
        let tomorrow = NSDate.tomorrow()
        
        // The type of data we are requesting (this is redundant and could probably be an enumeration
        let type = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        
        // Our search predicate which will fetch data from now until a day ago
        // (Note, 1.day comes from an extension
        // You'll want to change that to your own NSDate
        let predicate = HKQuery.predicateForSamplesWithStartDate(today, endDate: tomorrow, options: .None)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        // The actual HealthKit Query which will fetch all of the steps.
        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor]) { query, results, error in
            var steps: Double = 0
            print(results)
            if results?.count > 0{
                for result in results as! [HKQuantitySample]{
                    steps += result.quantity.doubleValueForUnit(HKUnit.countUnit())
                    
                }
            }
            
            completion(steps, error)
        }
        
        storage.executeQuery(query)
    }

    
    func getSteps(startDate: NSDate, endDate: NSDate, completion: ([JSON], ErrorType?) -> ()) {
        var stepResults = [JSON]()
        var result: [String: AnyObject] = ["date": "", "steps": 0.0]
        
        let type = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        let interval = NSDateComponents()
        interval.day = 1
        
        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: .StrictStartDate)
        let query = HKStatisticsCollectionQuery(quantityType: type!, quantitySamplePredicate: predicate, options: [.CumulativeSum], anchorDate: startDate, intervalComponents:interval)

        query.initialResultsHandler = { query, results, error in
            if let myResults = results{
                myResults.enumerateStatisticsFromDate(startDate, toDate: endDate) {
                    statistic, stop in
                    
                    if let quantity = statistic.sumQuantity() {
                        let date = statistic.startDate.toString(DateFormat.Custom("yyyy-MM-dd"))
                        let steps = quantity.doubleValueForUnit(HKUnit.countUnit())
                        
                        result["date"] = date
                        result["steps"] = steps
                        stepResults.append(JSON(result))
                    }
                }
                completion(stepResults, error)
            }
        }
        
        storage.executeQuery(query)
    }
}
