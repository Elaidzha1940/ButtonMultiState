//  /*
//
//  Project: ButtonMultiState
//  File: ContentView.swift
//  Created by: Elaidzha Shchukin
//  Date: 24.04.2023
//
//  */

import SwiftUI
 
struct ButtonMultiState: View {
    var body: some View {
        
        ZStack {
            Color.red
            VStack{
                Button("Solid"){}
                    .buttonStyle(ButtonMultiStateStyle(primaryOption: .right, style: .solid))
                Button("OutLine"){}
                    .buttonStyle(ButtonMultiStateStyle(primaryOption: .right, style: .outline))
                Button("OutLine + Left"){}
                    .buttonStyle(ButtonMultiStateStyle(primaryOption: .left, style: .solid))
                Button("OutLine + Right"){}
                    .buttonStyle(ButtonMultiStateStyle(primaryOption: .right, style: .solid))
                Button("OutLine only text"){}
                    .buttonStyle(ButtonMultiStateStyle(primaryOption: .onlyText, style: .solid))
                Button("Secondary only text"){}
                    .buttonStyle(ButtonMultiStateStyle(secondaryOption: .onlyText))
            }
        }
        .ignoresSafeArea()
    }
}

struct ButtonMultiState_Preview: PreviewProvider {
    static var previews: some View {
            ButtonMultiState()
    }
}

public struct ButtonMultiStateStyle : ButtonStyle {
    init(secondaryOption option: Self.Option, corenerRadius: CGFloat = 4, height: CGFloat = 48) {
        self.init(.secondary, .none, option, height, corenerRadius)
    }
    init(primaryOption option: Self.Option, style: Self.Style, corenerRadius: CGFloat = 4, height: CGFloat = 48) {
        self.init(.primary, style, option, height, corenerRadius)
    }
    
    internal init(
        _ buttonType: Self.Buttontype,
        _ style: Self.Style?,
        _ option: Self.Option,
        _ height: CGFloat,
        _ corenerRadius: CGFloat
    ) {
        self.buttonType = buttonType
        self.style = style
        self.option = option
        self.height = height
        self.corenerRadius = corenerRadius
    }
    
    @Environment(\.isEnabled) var isEnabled
    
    private let buttonType: Self.Buttontype
    private let style: Self.Style?
    private let option: Self.Option
    private let height: CGFloat
    private let corenerRadius: CGFloat
    
    public func makeBody(configuration: Configuration) -> some View {
        
        let animation = Animation.easeInOut(duration: 0.3)
        let bColor = self.isEnabled ?
        configuration.isPressed ? self.bodyColor.pressed : self.bodyColor.default :
        self.bodyColor.disabled
        
        let eColor = self.isEnabled ?
        configuration.isPressed ? self.elementColors.pressed : self.elementColors.default :
        self.elementColors.disabled
        
        let label = ZStack {
            self._makeRectangle(animation: animation, color: bColor)
            
            HStack {
                if self.option == .left || self.option == .left {
                    self._makeElement()
                }
                configuration.label
                    .foregroundColor(eColor)
                    .animation(animation, value: eColor)
                if self.option == .right || self.option == .right {
                    self._makeElement()
                }
            }
        }
            .frame(height: self.height)
        return label
    }
}



extension ButtonMultiStateStyle {
    
   private func _makeElement() -> some View {
        Rectangle()
            .fill(
                Color.brown
                )
            .frame(width: 20, height: 20)
   }
    
    @ViewBuilder
    func _makeRectangle(animation: Animation, color: Color?) -> some View {
        switch self.style {
        case .outline:
            let border: CGFloat = 2
            RoundedRectangle(cornerRadius: self.corenerRadius, style: .continuous)
                .foregroundColor(color)
                .animation(animation, value: color)
                .mask(
                    ZStack {
                        Rectangle()
                        RoundedRectangle(cornerRadius: self.corenerRadius - border, style: .continuous)
                            .padding(border)
                            .blendMode(.destinationOut)

                    }
                )
        case .solid:
            RoundedRectangle(cornerRadius: self.corenerRadius, style: .continuous)
                .foregroundColor(color)
                .animation(animation, value: color)

        default:
            EmptyView()
        }
    }
}

extension ButtonMultiStateStyle {
    
    var bodyColor: (default: Color?, pressed: Color?, disabled: Color?) {
        switch self.buttonType {
        case .primary:
            return(.red, .red.opacity(0.5), .green)
        case .secondary:
            return(nil, nil, nil)
        }
    }
    
    var elementColors: (default: Color?, pressed: Color?, disabled: Color?) {
        let bool = self.buttonType == .secondary || self.style == .outline
        
        if bool {
            return(.black, .black.opacity(0.5), .green)
        }
        return(.white, .white.opacity(0.5), .green)
    }
}


extension ButtonMultiStateStyle {
    enum Buttontype {
        case primary, secondary
    }
}

extension ButtonMultiStateStyle {
    enum Style {
        case outline, solid
    }
}

extension ButtonMultiStateStyle {
    enum Option {
        case onlyText, left, right
    }
}
