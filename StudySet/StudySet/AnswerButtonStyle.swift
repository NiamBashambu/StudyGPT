//
//  AnswerButtonStyle.swift
//  StudySet
//
//  Created by Niam Bashambu on 10/17/24.
//


import SwiftUI

struct AnswerButtonStyle: ButtonStyle {
    var color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(color)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
