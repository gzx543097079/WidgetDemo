//
//  HomeWidet.swift
//  WidgetDemo
//
//  Created by 惊小鱼 on 2020/12/3.
//

import SwiftUI


@main
struct HomeWidet:WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        TimeWidget()
        BatteryWidget()
    }
}
