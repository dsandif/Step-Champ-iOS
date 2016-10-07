//
//  DashboardViewController.swift
//  Step Champ
//
//  Created by Darien Sandifer on 7/4/16.
//  Copyright © 2016 Darien Sandifer. All rights reserved.
//

import Foundation
import UIKit
import Material
import Charts
import HealthKit
import SwiftDate
import SwiftyJSON

class DashboardViewController: UIViewController {
    @IBOutlet weak var navbar: UINavigationItem!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var dataChart: BarChartView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var previousBtn: FabButton!
    @IBOutlet weak var nextBtn: FabButton!
    @IBOutlet weak var syncbutton: UIBarButtonItem!
    
    var days: [String] = []
    var xValues: [Double] = []
    var stepEntries: [JSON] = []
    var dataEntries: [BarChartDataEntry] = []
    var selectedEntry: BarChartDataEntry = BarChartDataEntry()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        addChartSettings()
        prepareData()
//        runTest()
//        let refreshControl = UIRefreshControl()
//        userFeed.addSubview(refreshControl)
        
    }
    
    private func loadChart(dataPoints: [String], values: [Double]) {
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        selectedEntry = dataEntries.last!
        dataChart.delegate = self
        dataChart.leftAxis.axisMinValue = 0.0
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Steps")
        chartDataSet.colors = [setColor("007AFF")]
        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        dataChart.data = chartData
        dataChart.descriptionText = ""
        let goalLine = ChartLimitLine(limit: 1200.0, label: "Goal")
        goalLine.lineColor = setColor("109C48")
        dataChart.rightAxis.addLimitLine(goalLine)
        dataChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)

    }
    
   private func addChartSettings() {
        dataChart.noDataText = "Please add HealthKit data for the chart.\nTo enable HealthKit, go to:\nSettings->Privacy->Health->Step Champ"
        dataChart.xAxis.labelPosition = .Bottom
        dataChart.xAxis.drawGridLinesEnabled = false
        dataChart.rightAxis.enabled = false
        dataChart.extraBottomOffset = 30.0
        dataChart.legend.yOffset = 30.0
    }
    
   private func prepareData(){
        let startDate = NSDate.today() - 21.days
        let endDate =  NSDate()
    
        HealthkitManager().getSteps(startDate, endDate: endDate) { results, error in
           // print(results)
            self.stepEntries = results
            if results.count > 0{
                for result in results{
                    let dayOfMonth = result["date"].stringValue.toDate(DateFormat.Custom("yyyy/MM/dd"))
                    self.days.append(String(dayOfMonth!.day))
                    self.xValues.append(Double(result["steps"].double!))
                }
                self.initStepLabels(results.last!)
                self.loadChart(self.days, values: self.xValues)
            }
        }
    }
    
    private func setupNavBar(){
        navbar.title = "Home"
        navbar.titleLabel.textColor = setColor("ffffff")
        navigationController?.tabBarItem.setTitleColor(setColor("78A942"), forState: .Focused)
    }
    
    private func initStepLabels(stepEntry: JSON){
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            dispatch_async(dispatch_get_main_queue()) {
                self.stepLabel.text = String(Int(self.xValues[self.xValues.count-1])) + " Steps"
                self.dateLabel.text = self.getStepDate(stepEntry)
            }
        }
    }
    
    private func getStepDate(stepEntry: JSON) -> String{
        let labelDate = stepEntry["date"].stringValue
        let newDate = labelDate.toDate(DateFormat.Custom(("yyyy-MM-dd")))!
        return  ("\(newDate.monthName) \(newDate.day) \(newDate.year)")
    }
    
   private func runTest () {
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        loadChart(months, values: unitsSold)
    }
    
    @IBAction func previousDay(sender: FabButton) {
        let previousIndex = selectedEntry.xIndex - 1
        
        stepLabel.text = String(Int(dataEntries[previousIndex].value)) + " Steps"
        selectedEntry = dataEntries[previousIndex]
        dateLabel.text = getStepDate(stepEntries[previousIndex])
        dataChart.highlightValue(xIndex: previousIndex, dataSetIndex: 0, callDelegate: false)
        
        if selectedEntry.xIndex == dataEntries.startIndex{
            previousBtn.hidden = true
            previousBtn.enabled = false
        }else{
            previousBtn.hidden = false
            previousBtn.enabled = true
        }
        
        if selectedEntry.xIndex == dataEntries.endIndex - 1{
            nextBtn.hidden = true
            nextBtn.enabled = false
        }else{
            nextBtn.hidden = false
            nextBtn.enabled = true
        }
    }
    
    @IBAction func nextDay(sender: FabButton) {
        let nextIndex = selectedEntry.xIndex + 1
        stepLabel.text = String(Int(dataEntries[nextIndex].value)) + " Steps"
        selectedEntry = dataEntries[nextIndex]
        dateLabel.text = getStepDate(stepEntries[nextIndex])
        dataChart.highlightValue(xIndex: nextIndex, dataSetIndex: 0, callDelegate: false)
        
        if selectedEntry.xIndex == dataEntries.endIndex - 1{
            nextBtn.hidden = true
            nextBtn.enabled = false
        }else{
            nextBtn.hidden = false
            nextBtn.enabled = true
        }
        
        if selectedEntry.xIndex == dataEntries.startIndex{
            previousBtn.hidden = true
            previousBtn.enabled = false
        }else{
            previousBtn.hidden = false
            previousBtn.enabled = true
        }
    }
    
    @IBAction func syncButtonPressed(sender: UIBarButtonItem) {

        Endpoints.apiManager.syncSteps(steps: stepEntries){
            response in
            print(response)
        }
    }
    
    @IBAction func logoutButtonPressed(sender: UIBarButtonItem) {
        SharingManager.sharedInstance.keychain["username"] = nil
        SharingManager.sharedInstance.keychain["password"] = nil
        SharingManager.sharedInstance.keychain["authtoken"] = nil
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
        
        // Load search scene
        self.presentViewController(loginViewController, animated: true, completion: nil)
        
    }
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        //LightContent
        return UIStatusBarStyle.LightContent
        
        //Default
        //return UIStatusBarStyle.Default
        
    }
}

//Delegate methods for the chartview
extension DashboardViewController: ChartViewDelegate{
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        stepLabel.text = String(Int(entry.value)) + " Steps"
        self.dateLabel.text = self.getStepDate(stepEntries[entry.xIndex])
        selectedEntry = dataEntries[entry.xIndex]
    }
    
}