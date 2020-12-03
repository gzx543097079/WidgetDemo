//
//  TimeWidget.swift
//  TimeWidget
//
//  Created by 惊小鱼 on 2020/12/3.
//

import WidgetKit
import SwiftUI
import Intents

struct TimeWidgetProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> TestSimpleEntry {
        TestSimpleEntry(date: Date(), configuration: TimeWidgetIntent())
    }

    func getSnapshot(for configuration: TimeWidgetIntent, in context: Context, completion: @escaping (TestSimpleEntry) -> ()) {
        let entry = TestSimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: TimeWidgetIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [TestSimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = TestSimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct TestSimpleEntry: TimelineEntry {
    let date: Date
    let configuration: TimeWidgetIntent
}

struct TimeWidgetEntryView : View {
    var entry: TimeWidgetProvider.Entry
    
    var body: some View {
        Text(entry.date, style: .time)
    }
}

struct TimeWidget: Widget {
    let kind: String = "TimeWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: TimeWidgetIntent.self, provider: TimeWidgetProvider()) { entry in
            TimeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Time Widget")
        .description("This is an example widget.")
    }
}
