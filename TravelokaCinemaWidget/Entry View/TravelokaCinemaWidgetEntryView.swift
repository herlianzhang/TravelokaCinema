//
//  EntryPoint.swift
//  TravelokaCinemaWidgetExtension
//
//  Created by Herlian Zhang on 11/01/22.
//

import SwiftUI
import WidgetKit

struct TravelokaCinemaWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    
    var body: some View {
        switch family {
        case .systemSmall:
            if entry.movie.id != Int.min {
                ZStack {
                    GenericImage(uiImage: entry.movie.image)
                }
                .widgetURL(entry.movie.deeplink)
            } else {
                Image("")
                    .resizable()
                    .background(Color.gray)
            }
        case .systemMedium:
            if entry.movie.id != Int.min {
                GeometryReader { geometry in
                    HStack(alignment: .center, spacing: 12) {
                        GenericImage(uiImage: entry.movie.image)
                                .frame(maxWidth: geometry.size.height / 1.5 - 16)
                                .cornerRadius(12)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(entry.movie.title)
                                .font(.title3)
                                .lineLimit(3)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(entry.movie.releaseDate)
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(8)
                }
                .frame(maxHeight: .infinity)
                .widgetURL(entry.movie.deeplink)
            } else {
                GeometryReader { geometry in
                    HStack(alignment: .center, spacing: 12) {
                        Image("")
                            .resizable()
                            .background(Color.gray)
                            .frame(maxWidth: geometry.size.height / 1.5 - 16)
                            .cornerRadius(12)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Movie Title Uwau")
                                .font(.title3)
                                .lineLimit(3)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .redacted(reason: .placeholder)
                            Text("release Date")
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .redacted(reason: .placeholder)
                        }
                    }
                    .padding(8)
                }
                .frame(maxHeight: .infinity)
            }
        default:
            Text("Family Not Found")
        }
        
    }
}

struct TravelokaCinemaWidget_Previews: PreviewProvider {
    static var previews: some View {
        TravelokaCinemaWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
