//
//  TravelokaCinemaWidgetLargeEntryView.swift
//  TravelokaCinemaWidgetExtension
//
//  Created by Herlian Zhang on 11/01/22.
//

import SwiftUI
import WidgetKit

struct TravelokaCinemaWidgetLargeEntryView : View {
    var entry: LargeProvider.Entry
    
    var body: some View {
        if let selectedMovie = (entry.movies.filter { $0.id == entry.selectedId }).first {
            let averageColor: UIColor = selectedMovie.image?.averageColor ?? .clear
            let tintColor: Color = selectedMovie.image?.averageColor?.isDarkColor == true ? .white : .black
            VStack(spacing: 8) {
                Link(destination: selectedMovie.deeplink, label: {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(selectedMovie.title)
                            .font(.title3)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(tintColor)
                        Text(selectedMovie.overview)
                            .font(.subheadline)
                            .lineLimit(4)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .foregroundColor(tintColor)
                        Text(selectedMovie.releaseDate)
                            .font(.caption2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(tintColor)
                    }
                    .padding(12)
                    .frame(maxHeight: .infinity)
                    .background(Color(averageColor))
                    .cornerRadius(24)
                    .widgetURL(selectedMovie.deeplink)
                })
                
                GeometryReader { geometry in
                    HStack(alignment: .center, spacing: 12) {
                        ForEach(entry.movies) { movie in
                            Link(destination: movie.deeplink, label: {
                                GenericImage(uiImage: movie.image)
                                    .frame(maxWidth: geometry.size.height / 1.5 - 16)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(movie.id == entry.selectedId ? averageColor : .clear), lineWidth: 4)
                                    )
                            })
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxHeight: .infinity)
            }
            .padding(8)
        } else {
            VStack {
                VStack(spacing: 8) {
                    Text("Mantap Jiwa")
                        .font(.title3)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .redacted(reason: .placeholder)
                    Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
                        .font(.subheadline)
                        .lineLimit(4)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .redacted(reason: .placeholder)
                    Text("12-12-12")
                        .font(.caption2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .redacted(reason: .placeholder)
                }
                .padding(12)
                .frame(maxHeight: .infinity)
                
                GeometryReader { geometry in
                    HStack(alignment: .center, spacing: 12) {
                        ForEach(0..<3) { movie in
                            Image("")
                                .resizable()
                                .background(Color.gray)
                                .frame(maxWidth: geometry.size.height / 1.5 - 16)
                                .cornerRadius(12)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxHeight: .infinity)
            }
            .padding(8)
        }
    }
}

struct TravelokaCinemaLargeWidget_Previews: PreviewProvider {
    static var previews: some View {
        TravelokaCinemaWidgetLargeEntryView(entry: LargeEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
