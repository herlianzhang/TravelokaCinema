//
//  TravelokaCinemaWidget.swift
//  TravelokaCinemaWidget
//
//  Created by Herlian Zhang on 04/01/22.
//

import WidgetKit
import SwiftUI

@main
struct TravelokaCinemaWidgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        NormalWidget()
        LargeWidget()
    }
}

struct NormalWidget: Widget {
    let kind: String = "TravelokaCinemaNormalWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TravelokaCinemaWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("1 Upcoming Movie")
        .description("data from themoviedb")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct LargeWidget: Widget {
    let kind: String = "TravelokaCinemaLargeWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LargeProvider()) { entry in
            TravelokaCinemaWidgetLargeEntryView(entry: entry)
        }
        .configurationDisplayName("3 Upcoming Movie")
        .description("data from themoviedb")
        .supportedFamilies([.systemLarge])
    }
}
