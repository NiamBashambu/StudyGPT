//
//  ProgressBar.swift
//  StudySet
//
//  Created by Niam Bashambu on 10/17/24.
//


import SwiftUI

struct ProgressBar: View {
    var progress: CGFloat

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: 10)
                    .opacity(0.3)
                    .foregroundColor(.gray)

                Rectangle()
                    .frame(width: geometry.size.width * progress, height: 10)
                    .foregroundColor(.blue)
            }
        }
        .frame(height: 10)
    }
}
