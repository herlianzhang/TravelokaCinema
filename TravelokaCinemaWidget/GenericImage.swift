//
//  NetworkImage.swift
//  TravelokaCinema
//
//  Created by Herlian Zhang on 10/01/22.
//

import SwiftUI

struct GenericImage: View {
    let uiImage: UIImage?
    
    var body: some View {
        if let uiImage = uiImage {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            Image("")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .background(Color.gray)
        }
    }
}
