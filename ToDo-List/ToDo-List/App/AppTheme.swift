//
//  AppTheme.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 24.04.2025.
//

import Foundation
import SwiftUI

final class AppTheme {
    // MARK: - Colors
    struct Colors {
        let primary: Color
        let secondary: Color
        let background: Color
        let text: Color
        let accent: Color
        let destructive: Color
        let toolbar: Color
        let dateText: Color

        init(primary: Color, secondary: Color, background: Color, text: Color, accent: Color, destructive: Color, toolbar: Color, dateText: Color) {
            self.primary = primary
            self.secondary = secondary
            self.background = background
            self.text = text
            self.accent = accent
            self.destructive = destructive
            self.toolbar = toolbar
            self.dateText = dateText
        }

        static let light = Colors(
            primary: .blue,
            secondary: .gray,
            background: .white,
            text: .black,
            accent: .orange,
            destructive: .red,
            toolbar: .white,
            dateText: .gray
        )

        static let dark = Colors(
            primary: .teal,
            secondary: .gray,
            background: .black,
            text: .white,
            accent: .yellow,
            destructive: .pink,
            toolbar: Color(white: 0.2),
            dateText: .gray
        )
    }
    // MARK: - Fonts
    struct Fonts {
        let largeTitle: Font
        let title: Font
        let headline: Font
        let body: Font
        let caption: Font
        let subheadline: Font

        init(
            largeTitle: Font,
            title: Font,
            headline: Font,
            body: Font,
            caption: Font,
            subheadline: Font
        ) {
            self.largeTitle = largeTitle
            self.title = title
            self.headline = headline
            self.body = body
            self.caption = caption
            self.subheadline = subheadline
        }

        static let main = Fonts(
            largeTitle: .system(.largeTitle, design: .rounded),
            title: .system(.title, design: .rounded),
            headline: .system(.headline, design: .rounded),
            body: .system(.body, design: .rounded),
            caption: .system(.caption, design: .rounded),
            subheadline: .system(.subheadline, design: .rounded)
        )
    }
    // MARK: - Dimensions
    struct Dimensions {
        let padding: CGFloat
        let cornerRadius: CGFloat
        let buttonHeight: CGFloat
        let shadowRadius: CGFloat

        init(
            padding: CGFloat,
            cornerRadius: CGFloat,
            buttonHeight: CGFloat,
            shadowRadius: CGFloat
        ) {
            self.padding = padding
            self.cornerRadius = cornerRadius
            self.buttonHeight = buttonHeight
            self.shadowRadius = shadowRadius
        }

        static let standard = Dimensions(
            padding: 16,
            cornerRadius: 10,
            buttonHeight: 44,
            shadowRadius: 2
        )
    }

    // MARK: - Properties
    let colors: Colors
    let fonts: Fonts
    let dimensions: Dimensions

    // MARK: - Initializers
    init(colors: Colors, fonts: Fonts, dimensions: Dimensions) {
        self.colors = colors
        self.fonts = fonts
        self.dimensions = dimensions
    }

    // MARK: - Theme Variants
    static var light: AppTheme {
        AppTheme(
            colors: .light,
            fonts: .main,
            dimensions: .standard
        )
    }

    static var dark: AppTheme {
        AppTheme(
            colors: .dark,
            fonts: .main,
            dimensions: .standard
        )
    }

    static func theme(for colorScheme: ColorScheme) -> AppTheme {
        colorScheme == .dark ? .dark : .light
    }
}
