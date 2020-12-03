//
//  BatteryWidget.swift
//  FastCleanWidget14Extension
//
//  Created by 惊小鱼 on 2020/12/2.
//  Copyright © 2020 Rzk. All rights reserved.
//

import Foundation
import WidgetKit
import SwiftUI
import Intents

let BatterWidgetKind: String = "BatteryWidget"

struct BatterProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) ->  BatterEntry {
        let batter = getBatterInformation()
        return BatterEntry(date: Date(), batteryCharge: batter.batteryCharge, batteryLevel: batter.batteryLevel)
    }

    func getSnapshot(for configuration: BatteryWidgetIntent, in context: Context, completion: @escaping (BatterEntry) -> Void) {
        let batter = getBatterInformation()
        completion (BatterEntry(date: Date(), batteryCharge: batter.batteryCharge, batteryLevel: batter.batteryLevel))
    }

    func getTimeline(for configuration: BatteryWidgetIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let batter = getBatterInformation()
        let entry = BatterEntry(date: Date(), batteryCharge: batter.batteryCharge, batteryLevel: batter.batteryLevel)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

func getBatterInformation() -> (batteryCharge:Bool,batteryLevel:String) {
    let device = UIDevice.current
    device.isBatteryMonitoringEnabled = true
    let batteryLevel = device.batteryLevel
    let batteryCharge = !(device.batteryState == UIDevice.BatteryState.unplugged || device.batteryState == UIDevice.BatteryState.unknown)
    return (batteryCharge,String(format: "%0.f%%",  batteryLevel * 100))
}

struct BatterEntry: TimelineEntry {
    var date: Date
    var batteryCharge: Bool
    var batteryLevel: String
}


struct BatteryWidgetEntryView : View {
    var entry: BatterProvider.Entry
    @Environment(\.widgetFamily) var family
    var body: some View {
        BatteryWidgetView(entry: entry)
    }
}

struct BatteryWidgetView: View {
    var entry: BatterProvider.Entry
    var body: some View {
        Text(String(format: "电量 %@,是否正在充电: %@,\n时间%f",entry.batteryLevel,entry.batteryCharge ? "是":"否",entry.date.timeIntervalSince1970))
    }
}


struct BatteryWidget: Widget {
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: BatterWidgetKind, intent: BatteryWidgetIntent.self, provider: BatterProvider()) { entry in
            BatteryWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("电量")
        .description("")
    }
}


