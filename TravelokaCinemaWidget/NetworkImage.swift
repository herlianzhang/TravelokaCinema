//
//  NetworkImage.swift
//  TravelokaCinema
//
//  Created by Herlian Zhang on 10/01/22.
//

import SwiftUI

struct NetworkImage: View {

    let url: URL?

    var body: some View {

    Group {
        if let url = url, let imageData = try? Data(contentsOf: url),
            let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            else {
                Color(.gray)
            }
        }
    }
}
