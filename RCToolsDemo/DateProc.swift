//
//  DateProc.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 1/7/16.
//  Copyright (c) 2016 rexcao. All rights reserved.
//

import Foundation

class DateProc {
    
    class func nowGregorianNoPrefix(dateFormatter: String) -> String {
        let nowDate = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = dateFormatter
        return formatter.stringFromDate(nowDate)
    }
    
    // Get specific unix time's formated string
    class func formatUnixTime(dateFormatter: String, interval: Int) -> String {
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(interval))
        var formatter = NSDateFormatter()
        formatter.dateFormat = dateFormatter
        return formatter.stringFromDate(date)
    }
    
    class func timeIntervalSince1970() -> Int {
        let date = NSDate()
        //        var formatter = NSDateFormatter()
        //        formatter.timeZone = NSTimeZone.localTimeZone()
        //        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        //        let strDate = formatter.stringFromDate(date)
        
        // Why here is correct, because this return the seconds since 1970 and 1970 also use UTC time zone,
        // so their time zone is same.
        let seconds = date.timeIntervalSince1970;
        return Int(seconds)
    }
    
    class func addPreZero(number: Int) -> String {
        var res = "0"
        if(number < 10) {
            res = res + String(number)
        } else {
            res = String(number)
        }
        return res
    }
    
    class func ymdhisTimeToUnixTime(ymdhisTime: String) -> NSTimeInterval {
        let fmt = NSDateFormatter()
        fmt.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let timeZone = NSTimeZone(name: "Asia/Shanghai")
        fmt.timeZone = timeZone
        var date = fmt.dateFromString(ymdhisTime)!
        return date.timeIntervalSince1970
    }
    
    class func ymdTime(date: NSDate) -> String {
        let timeZone = NSTimeZone(name: "Asia/Shanghai")
        let fmt = NSDateFormatter()
        fmt.dateFormat = "YYYY-MM-dd"
        fmt.timeZone = timeZone
        return fmt.stringFromDate(date)
    }
}

// Extend DateProc to add Chinese Lunar processing
extension DateProc {
    class ChineseLunar {
        static let lunarNumber = ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十"]
        
        class func nowChineseLunarDate() -> String {
            let fmt = NSDateFormatter()
            fmt.locale = NSLocale(localeIdentifier: "zh_CN")
            fmt.dateStyle = NSDateFormatterStyle.MediumStyle
            
            let chineseCal = NSCalendar(calendarIdentifier: NSCalendarIdentifierChinese)
            fmt.calendar = chineseCal
            fmt.dateFormat = "MMMdd"
            let date = fmt.stringFromDate(NSDate())
            return date
            //            return self.monthDateToChineseLunar(date)
        }
        
        class func specificChineseLunarDate(date: NSDate) -> String {
            let fmt = NSDateFormatter()
            fmt.locale = NSLocale(localeIdentifier: "zh_CN")
            fmt.dateStyle = NSDateFormatterStyle.MediumStyle
            
            let chineseCal = NSCalendar(calendarIdentifier: NSCalendarIdentifierChinese)
            fmt.calendar = chineseCal
            fmt.dateFormat = "MMMdd"
            let date = fmt.stringFromDate(date)
            return date
            //            return self.monthDateToChineseLunar(date)
        }
        
        // Trun month date to Chinese Lunar, need  monthDate style is like: 09-11
        class func monthDateToChineseLunar(shortDate: String) -> String {
            let tmp = shortDate.componentsSeparatedByString("-")
            let res = DateProc.ChineseLunar.monthToLunar(tmp[0].toInt()!)+DateProc.ChineseLunar.dayToLunar(tmp[1].toInt()!)
            return res
        }
        
        // Turn day number to Chinese Lunar day.
        class func dayToLunar(day: Int) -> String {
            var res = "err"
            if day <= 10 {
                res = "初"+self.lunarNumber[day-1]
            } else if day > 10 && day <= 20 {
                if day == 20 {
                    res = "二十"
                } else {
                    let m = day % 10
                    res = "十"+self.lunarNumber[m-1]
                }
            } else if day > 20 && day < 30 {
                let m = day % 20
                res = "廿"+self.lunarNumber[m-1]
            } else {
                if day == 30 {
                    res = "三十"
                } else {
                    let m = day % 30
                    res = "三十"+self.lunarNumber[m-1]
                }
            }
            return res
        }
        
        // Turn month number to Chinese Lunar month.
        class func monthToLunar(month: Int) -> String {
            var res = "err"
            if month == 1 {
                res = "正"
            } else if month == 12 {
                res = "腊"
            } else if month == 11 {
                res = "十一"
            } else {
                res = self.lunarNumber[month-1]
            }
            res = res+"月"
            return res
        }
    }
}