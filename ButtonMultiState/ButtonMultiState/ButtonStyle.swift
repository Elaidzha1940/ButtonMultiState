//  /*
//
//  Project: ButtonMultiState
//  File: ButtonStyle.swift
//  Created by: Elaidzha Shchukin
//  Date: 24.04.2023
//
//  */

import SwiftUI

///Basic project button style
public struct GWorkButtonStyle : ButtonStyle {
    public init(
        secondaryOption option: Self.Option,
        cornerRadius: CGFloat = 13,
        height: CGFloat = 50,
        border: CGFloat = 2
    )
    {
        self.init(.secondary, .none, option, height, cornerRadius, border)
    }
    
    public init(
        primaryOption option: Self.Option,
        style: Self.Style,
        cornerRadius: CGFloat = 13,
        height: CGFloat = 50,
        border: CGFloat = 2
    )
    {
        self.init(.primary, style, option, height, cornerRadius, border)
    }
    
    private init(
        _ buttonType: Self.ButtonType,
        _ style: Self.Style?,
        _ option: Self.Option,
        _ height: CGFloat,
        _ cornerRadius: CGFloat,
        _ border: CGFloat
    )
    {
        self.buttonType = buttonType
        self.style = style
        self.option = option
        self.height = height
        self.cornerRadius = cornerRadius
        self.border = border
        self._isEnabled = .init(\.isEnabled)
    }
    
    //MARK: Properties
    private var _isEnabled: Environment<Bool>
    private let buttonType: Self.ButtonType
    private let style: Self.Style?
    private let option: Self.Option
    private let height: CGFloat
    private let cornerRadius: CGFloat
    private let border: CGFloat
    
    
    //MARK: MakeBody
    public func makeBody(configuration: Configuration) -> some View {
        let animation = Animation.easeOut(duration: 0.4)
        let bColor = self.isEnabled ?
        configuration.isPressed ? self.bodyColor.pressed : self.bodyColor.defaut :
        self.bodyColor.disable
        
        let eColor = self.isEnabled ?
        configuration.isPressed ? self.elementColors.pressed : self.elementColors.defaut :
        self.elementColors.disable
        
        let label = ZStack{
            self._makeRectangle(animation: animation, color: bColor)
            HStack{
                if self.option == .left || self.option == .all {
                    self._makeElement()
                }
                configuration.label
                    .foregroundColor(eColor)
                    .animation(animation, value: eColor)
                if self.option == .right || self.option == .all {
                    self._makeElement()
                }
            }
        }
        .frame(height: self.height)
        return label
    }
}

//MARK: SubViews
extension GWorkButtonStyle {
    
    private func _makeElement() -> some View {
        Rectangle()
            .fill(Color.yellow)
            .frame(width: 20, height: 20)
    }
    
    @ViewBuilder func _makeRectangle(animation: Animation, color: Color?) -> some View {
        switch self.style {
        case .outline:
            RoundedRectangle(cornerRadius: self.cornerRadius, style: .continuous)
                .foregroundColor(color)
                .animation(animation, value: color)
                .mask(
                    ZStack{
                        Rectangle()
                        RoundedRectangle(cornerRadius: self.cornerRadius - self.border, style: .continuous)
                            .padding(self.border)
                            .blendMode(.destinationOut)
                    }
                )
        case .solid:
            RoundedRectangle(cornerRadius: self.cornerRadius, style: .continuous)
                .foregroundColor(color)
                .animation(animation, value: color)
        default:
            EmptyView()
        }
    }
}

//MARK: Computed Properties
extension GWorkButtonStyle {
    
    private var isEnabled: Bool {
        self._isEnabled.wrappedValue
    }
    
    private var bodyColor: (defaut: Color?, pressed: Color?, disable: Color?) {
        switch self.buttonType {
        case .primary:
            return (.red, .red.opacity(0.5), .green)
        case .secondary:
            return (nil, nil, nil)
        }
    }
    
    private var elementColors: (defaut: Color?, pressed: Color?, disable: Color?) {
        self.buttonType == .secondary ||
        self.style == .outline ?
        (.black, .black.opacity(0.5), .green) :
        (.white, .white.opacity(0.5), .green)
    }
    
}

//MARK: ButtonStyle.Style
extension GWorkButtonStyle {
    public enum Style {
        case outline, solid
    }
}

//MARK: ButtonStyle.Option
extension GWorkButtonStyle {
    public enum Option {
        case onlyText, left, right, all
    }
}

//MARK: ButtonStyle.ButtonType
extension GWorkButtonStyle {
    private enum ButtonType {
        case primary, secondary
    }
}
