//
//  EventDateAndDurationVC.swift
//  Eventperk
//
//  Created by Bhavik iOS Developer on 10/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class EventDateAndDurationVC: UIViewController {

    //MARK:- Outlet Declaration
    @IBOutlet var btnClear: UIButton!
    
    @IBOutlet var lblStartDateTime: UILabel!
    @IBOutlet var lblEndDateTime: UILabel!
    
    //MARK: CalendarView
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet var lblMonthYear: UILabel!
    
    //MARK: Calendar View Properties
    var shouldShowDaysOut = true
    var animationFinished = true
    
    var selectedDay:DayView!
    
    var currentCalendar: Calendar?
    
    override func awakeFromNib() {
        let timeZoneBias = 480 // (UTC+08:00)
        currentCalendar = Calendar.init(identifier: .gregorian)
        if let timeZone = TimeZone.init(secondsFromGMT: -timeZoneBias * 60) {
            currentCalendar?.timeZone = timeZone
        }
    }
    
    struct Color {
        static let selectedText = UIColor.black
        static let text = UIColor.black
        static let textDisabled = UIColor.gray
        static let selectionBackground = UIColor(red: 254.0/255.0, green: 196.0/255.0, blue: 161.0/255.0, alpha: 1.0)
        static let sundayText = UIColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0)
        static let sundayTextDisabled = UIColor(red: 1.0, green: 0.6, blue: 0.6, alpha: 1.0)
        static let sundaySelectionBackground = sundayText
    }
    
    //MARK: Other Objects
    var dictCreateEventDetail = NSMutableDictionary()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dictCreateEventDetail)
        self.initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
    }

    
    //MARK:- Initialization
    func initialization() {
        btnClear.layer.cornerRadius = 10.0
        
        if let currentCalendar = currentCalendar {
            lblMonthYear.text = CVDate(date: Date(), calendar: currentCalendar).globalDescription
        }
        
        if dictCreateEventDetail.value(forKey: "EventStartDate") != nil {
            lblStartDateTime.text = ProjectUtilities.changeDateFormate(strDate: dictCreateEventDetail.value(forKey: "EventStartDate") as! String, strFormatter1: "MMM dd, yyyy hh:mm a", strFormatter2: "dd/MM/yy, hh:mm a") as String
        }
        if dictCreateEventDetail.value(forKey: "EventEndDate") != nil {
            lblEndDateTime.text = ProjectUtilities.changeDateFormate(strDate: dictCreateEventDetail.value(forKey: "EventEndDate") as! String, strFormatter1: "MMM dd, yyyy hh:mm a", strFormatter2: "dd/MM/yy, hh:mm a") as String
        }
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnClearAction (_ sender: UIButton) {
        
        lblStartDateTime.text = "Date/Time"
        lblEndDateTime.text = "Date/Time"
        
        if dictCreateEventDetail.value(forKey: "EventStartDate") != nil {
            dictCreateEventDetail.removeObject(forKey: "EventStartDate")
            
        }
        if dictCreateEventDetail.value(forKey: "EventEndDate") != nil {
            dictCreateEventDetail.removeObject(forKey: "EventEndDate")
        }
    }
    
    @IBAction func btnDateAndTimeAction (_ sender: UIButton) {
        
        if sender.tag == 1 {
            if lblStartDateTime.text != "Date/Time" {
    
                ActionSheetDatePicker.show(withTitle: "Select start Time", datePickerMode: .time, selectedDate: Date(), doneBlock: { (picker,selectedDate,origin) in
                    
                    if self.selectedDay != nil {
                        self.lblStartDateTime.text = ProjectUtilities.stringFromDate(date: self.selectedDay.date.convertedDate()!, strFormatter: "dd/MM/yy") + ", " + ProjectUtilities.stringFromDate(date: selectedDate as! Date, strFormatter: "hh:mm a")
                        
                        self.dictCreateEventDetail.setValue(ProjectUtilities.stringFromDate(date: self.selectedDay.date.convertedDate()!, strFormatter: "MMM dd, yyyy") + " " + ProjectUtilities.stringFromDate(date: selectedDate as! Date, strFormatter: "hh:mm a"), forKey: "EventStartDate")
                    }else{
                        self.lblStartDateTime.text = (ProjectUtilities.changeDateFormate(strDate: self.lblStartDateTime.text!, strFormatter1: "dd/MM/yy, hh:mm a", strFormatter2: "dd/MM/yy") as String) + ", " + ProjectUtilities.stringFromDate(date: selectedDate as! Date, strFormatter: "hh:mm a")
                        
                        self.dictCreateEventDetail.setValue((ProjectUtilities.changeDateFormate(strDate: self.lblStartDateTime.text!, strFormatter1: "dd/MM/yy, hh:mm a", strFormatter2: "MMM dd, yyyy") as String) + " " + ProjectUtilities.stringFromDate(date: selectedDate as! Date, strFormatter: "hh:mm a"), forKey: "EventStartDate")
                    }
                    
                    
                    
                    EventProfile.insertUpdateEventData(dictEventDetail: self.dictCreateEventDetail) { (errors: [NSError]?) in
                    }
                    
                }, cancel: { (ActionSheetDatePicker) in
                    
                }, origin: sender)
            }
        }else{
            
            if lblEndDateTime.text != "Date/Time" {
                
                ActionSheetDatePicker.show(withTitle: "Select start Time", datePickerMode: .time, selectedDate: Date(), doneBlock: { (picker,selectedDate,origin) in
                    
                    if self.selectedDay != nil {
                        self.lblEndDateTime.text = ProjectUtilities.stringFromDate(date: self.selectedDay.date.convertedDate()!, strFormatter: "dd/MM/yy") + ", " + ProjectUtilities.stringFromDate(date: selectedDate as! Date, strFormatter: "hh:mm a")
                        
                        self.dictCreateEventDetail.setValue(ProjectUtilities.stringFromDate(date: self.selectedDay.date.convertedDate()!, strFormatter: "MMM dd, yyyy") + " " + ProjectUtilities.stringFromDate(date: selectedDate as! Date, strFormatter: "hh:mm a"), forKey: "EventEndDate")
                    }else{
                        self.lblEndDateTime.text = (ProjectUtilities.changeDateFormate(strDate: self.lblEndDateTime.text!, strFormatter1: "dd/MM/yy, hh:mm a", strFormatter2: "dd/MM/yy") as String) + ", " + ProjectUtilities.stringFromDate(date: selectedDate as! Date, strFormatter: "hh:mm a")
                        
                        self.dictCreateEventDetail.setValue((ProjectUtilities.changeDateFormate(strDate: self.lblStartDateTime.text!, strFormatter1: "dd/MM/yy, hh:mm a", strFormatter2: "MMM dd, yyyy") as String) + " " + ProjectUtilities.stringFromDate(date: selectedDate as! Date, strFormatter: "hh:mm a"), forKey: "EventEndDate")
                    }
                    
                    EventProfile.insertUpdateEventData(dictEventDetail: self.dictCreateEventDetail) { (errors: [NSError]?) in
                    }
                    
                }, cancel: { (ActionSheetDatePicker) in
                    
                }, origin: sender)
                
            }
        }
    }
    
    //MARK:- Date Validation
    
    func MinSelectionDate(_ from: Date) -> Date {
        let gregorian = NSCalendar(calendarIdentifier: .gregorian)
        var offsetComponents = DateComponents()
        offsetComponents.year = 200
        return gregorian!.date(byAdding: offsetComponents, to: from, options: [])!
    }
    
    func MaxSelectionDate(_ from: Date) -> Date
    {
        let gregorian = NSCalendar(calendarIdentifier: .gregorian)
        var offsetComponents = DateComponents()
        offsetComponents.year = 0
        return gregorian!.date(byAdding: offsetComponents, to: from, options: [])!
    }
}

// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate

extension EventDateAndDurationVC: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return .sunday
    }
    
    // MARK: Optional methods
    
    func calendar() -> Calendar? {
        return currentCalendar
    }
    
    func dayOfWeekTextColor(by weekday: Weekday) -> UIColor {
        return weekday == .sunday ? UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0) : UIColor.white
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        return shouldShowDaysOut
    }
    
    func shouldAnimateResizing() -> Bool {
        return true // Default value is true
    }
    
    private func shouldSelectDayView(dayView: DayView) -> Bool {
        return arc4random_uniform(3) == 0 ? true : false
    }
    
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        return false
    }
    
    func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
        selectedDay = dayView
        print(selectedDay.date.convertedDate()!)
        
        self.lblStartDateTime.text = ProjectUtilities.stringFromDate(date: self.selectedDay.date.convertedDate()!, strFormatter: "dd/MM/yy") + ", " + "12:00 AM"
        
        self.dictCreateEventDetail.setValue(ProjectUtilities.stringFromDate(date: self.selectedDay.date.convertedDate()!, strFormatter: "MMM dd, yyyy") + " " + "12:00 AM", forKey: "EventStartDate")
        
        self.lblEndDateTime.text = ProjectUtilities.stringFromDate(date: self.selectedDay.date.convertedDate()!, strFormatter: "dd/MM/yy") + ", " + "12:30 AM"
        
        self.dictCreateEventDetail.setValue(ProjectUtilities.stringFromDate(date: self.selectedDay.date.convertedDate()!, strFormatter: "MMM dd, yyyy") + " " + "12:30 AM", forKey: "EventEndDate")
        
        EventProfile.insertUpdateEventData(dictEventDetail: dictCreateEventDetail) { (errors: [NSError]?) in
        }
    }
    
    func shouldSelectRange() -> Bool {
        return false
    }
    
    func didSelectRange(from startDayView: DayView, to endDayView: DayView) {
        print("RANGE SELECTED: \(startDayView.date.commonDescription) to \(endDayView.date.commonDescription)")
    }
    
    func presentedDateUpdated(_ date: CVDate) {
        if lblMonthYear.text != date.globalDescription && self.animationFinished {
            let updatedlblMonthYear = UILabel()
            updatedlblMonthYear.textColor = lblMonthYear.textColor
            updatedlblMonthYear.font = lblMonthYear.font
            updatedlblMonthYear.textAlignment = .center
            updatedlblMonthYear.text = date.globalDescription
            updatedlblMonthYear.sizeToFit()
            updatedlblMonthYear.alpha = 0
            updatedlblMonthYear.center = self.lblMonthYear.center
            
            let offset = CGFloat(48)
            updatedlblMonthYear.transform = CGAffineTransform(translationX: 0, y: offset)
            updatedlblMonthYear.transform = CGAffineTransform(scaleX: 1, y: 0.1)
            
            UIView.animate(withDuration: 0.35, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.animationFinished = false
                self.lblMonthYear.transform = CGAffineTransform(translationX: 0, y: -offset)
                self.lblMonthYear.transform = CGAffineTransform(scaleX: 1, y: 0.1)
                self.lblMonthYear.alpha = 0
                
                updatedlblMonthYear.alpha = 1
                updatedlblMonthYear.transform = CGAffineTransform.identity
                
            }) { _ in
                
                self.animationFinished = true
                self.lblMonthYear.frame = updatedlblMonthYear.frame
                self.lblMonthYear.text = updatedlblMonthYear.text
                self.lblMonthYear.transform = CGAffineTransform.identity
                self.lblMonthYear.alpha = 1
                updatedlblMonthYear.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedlblMonthYear, aboveSubview: self.lblMonthYear)
        }
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .short
    }
    
    func selectionViewPath() -> ((CGRect) -> (UIBezierPath)) {
        return { UIBezierPath(rect: CGRect(x: 0, y: 0, width: $0.width, height: $0.height)) }
    }
    
    func shouldShowCustomSingleSelection() -> Bool {
        return false
    }
    
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: CVShape.circle)
        circleView.fillColor = .colorFromCode(0xCCCCCC)
        return circleView
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if (dayView.isCurrentDay) {
            return true
        }
        return false
    }
    
    func supplementaryView(viewOnDayView dayView: DayView) -> UIView {
        
        dayView.setNeedsLayout()
        dayView.layoutIfNeeded()
        
        let π = Double.pi
        
        let ringLayer = CAShapeLayer()
        let ringLineWidth: CGFloat = 4.0
        let ringLineColour = UIColor.blue
        
        let newView = UIView(frame: dayView.frame)
        
        let diameter = (min(newView.bounds.width, newView.bounds.height))
        let radius = diameter / 2.0 - ringLineWidth
        
        newView.layer.addSublayer(ringLayer)
        
        ringLayer.fillColor = nil
        ringLayer.lineWidth = ringLineWidth
        ringLayer.strokeColor = ringLineColour.cgColor
        
        let centrePoint = CGPoint(x: newView.bounds.width/2.0, y: newView.bounds.height/2.0)
        let startAngle = CGFloat(-π/2.0)
        let endAngle = CGFloat(π * 2.0) + startAngle
        let ringPath = UIBezierPath(arcCenter: centrePoint,
                                    radius: radius,
                                    startAngle: startAngle,
                                    endAngle: endAngle,
                                    clockwise: true)
        
        ringLayer.path = ringPath.cgPath
        ringLayer.frame = newView.layer.bounds
        
        return newView
    }
    
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        
        guard let currentCalendar = currentCalendar else {
            return false
        }
        var components = Manager.componentsForDate(Foundation.Date(), calendar: currentCalendar)
        
        /* For consistency, always show supplementaryView on the 3rd, 13th and 23rd of the current month/year.  This is to check that these expected calendar days are "circled". There was a bug that was circling the wrong dates. A fix was put in for #408 #411.
         
         Other month and years show random days being circled as was done previously in the Demo code.
         */
        
        if dayView.date.year == components.year &&
            dayView.date.month == components.month {
            
            if (dayView.date.day == 3 || dayView.date.day == 13 || dayView.date.day == 23)  {
                print("Circle should appear on " + dayView.date.commonDescription)
                return false//true
            }
            return false
        } else {
            
            if (Int(arc4random_uniform(3)) == 1) {
                return false//true
            }
            
            return false
        }
        
    }
    
    func dayOfWeekTextColor() -> UIColor {
        return UIColor.white
    }
    
    func dayOfWeekBackGroundColor() -> UIColor {
        return UIColor.orange
    }
    
    func disableScrollingBeforeDate() -> Date {
        return Date()
    }
    
    func maxSelectableRange() -> Int {
        return 14
    }
    
    func earliestSelectableDate() -> Date {
        return Date()
    }
    
//    func latestSelectableDate() -> Date {
//        var dayComponents = DateComponents()
//        dayComponents.day = 70
//        let calendar = Calendar(identifier: .gregorian)
//        if let lastDate = calendar.date(byAdding: dayComponents, to: Date()) {
//            return lastDate
//        } else {
//            return Date()
//        }
//    }
}


// MARK: - CVCalendarViewAppearanceDelegate

extension EventDateAndDurationVC: CVCalendarViewAppearanceDelegate {
    
    func dayLabelWeekdayDisabledColor() -> UIColor {
        return UIColor.lightGray
    }
    
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 0
    }
    
    func dayLabelFont(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIFont { return UIFont.systemFont(ofSize: 14) }
    
    func dayLabelColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        switch (weekDay, status, present) {
        case (_, .selected, _), (_, .highlighted, _): return Color.selectedText
        case (.sunday, .in, _): return Color.sundayText
        case (.sunday, _, _): return Color.sundayTextDisabled
        case (_, .in, _): return Color.text
        default: return Color.textDisabled
        }
    }
    
    func dayLabelBackgroundColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        switch (weekDay, status, present) {
        case (.sunday, .selected, _), (.sunday, .highlighted, _): return Color.sundaySelectionBackground
        case (_, .selected, _), (_, .highlighted, _): return Color.selectionBackground
        default: return nil
        }
    }
}

// MARK: - IB Actions

extension EventDateAndDurationVC {
    @IBAction func switchChanged(sender: UISwitch) {
        calendarView.changeDaysOutShowingState(shouldShow: sender.isOn)
        shouldShowDaysOut = sender.isOn
    }
    
    @IBAction func todayMonthView() {
        calendarView.toggleCurrentDayView()
    }
    
    /// Switch to WeekView mode.
    @IBAction func toWeekView(sender: AnyObject) {
        calendarView.changeMode(.weekView)
    }
    
    /// Switch to MonthView mode.
    @IBAction func toMonthView(sender: AnyObject) {
        calendarView.changeMode(.monthView)
    }
    
    @IBAction func loadPrevious(sender: AnyObject) {
        calendarView.loadPreviousView()
    }
    
    
    @IBAction func loadNext(sender: AnyObject) {
        calendarView.loadNextView()
    }
}

// MARK: - Convenience API Demo

extension EventDateAndDurationVC {
    func toggleMonthViewWithMonthOffset(offset: Int) {
        guard let currentCalendar = currentCalendar else {
            return
        }
        
        var components = Manager.componentsForDate(Foundation.Date(), calendar: currentCalendar) // from today
        
        components.month! += offset
        
        let resultDate = currentCalendar.date(from: components)!
        
        self.calendarView.toggleViewWithDate(resultDate)
    }
    
    
    func didShowNextMonthView(_ date: Date) {
        guard let currentCalendar = currentCalendar else {
            return
        }
        
        let components = Manager.componentsForDate(date, calendar: currentCalendar) // from today
        
        print("Showing Month: \(components.month!)")
    }
    
    
    func didShowPreviousMonthView(_ date: Date) {
        guard let currentCalendar = currentCalendar else {
            return
        }
        
        let components = Manager.componentsForDate(date, calendar: currentCalendar) // from today
        
        print("Showing Month: \(components.month!)")
    }
    
}
