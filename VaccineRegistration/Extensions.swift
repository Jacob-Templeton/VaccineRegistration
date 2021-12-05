//
//  Extensions.swift
//  VaccineRegistration
//
//  Created by Jacob Templeton on 11/28/21.
//

import SwiftUI

// MARK: - View Extensions
// Clips corners of a rectangle to be round
extension View
{
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View
    {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
     }
}

// Utility function to hide keyboard concisely
extension View
{
    func hideKeyboard()
    {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// A placeholder template
extension View
{
    func placeholder<Content: View>
    (
        when shouldShow: Bool,
        alignment: Alignment = .center,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment)
        {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

// A foreground gradient template
extension View
{
    public func foregroundGradient(stops: [Gradient.Stop], start: UnitPoint = UnitPoint.topLeading, end: UnitPoint = UnitPoint.bottomTrailing) -> some View
    {
        self.overlay(LinearGradient(gradient: Gradient(stops: stops),
            startPoint: start,
            endPoint: end))
            .mask(self)
    }
}

// A background gradient template
extension View
{
    public func backgroundGradient(stops: [Gradient.Stop], start: UnitPoint = UnitPoint.topLeading, end: UnitPoint = UnitPoint.bottomTrailing) -> some View
    {
        self.background(LinearGradient(gradient: Gradient(stops: stops),
            startPoint: start,
            endPoint: end))
    }
}

// Is an inverse mask (i.e., cuts away mask area instead of putting something in it)
extension View
{
    func inverseMask<Mask>(_ mask: Mask) -> some View where Mask: View
    {
        self.mask(mask
                    .foregroundColor(.black)
                    .background(Color.white)
                    .compositingGroup()
                    .luminanceToAlpha()
        )
    }
}

// MARK: - Type Extensions
// Returns true if only letters and spaces exist in the string
extension String
{
    var isAlpha: Bool
    {
        return !isEmpty && range(of: "[^a-zA-Z\\s]", options: .regularExpression) == nil
    }
}

// Returns a random CGFloat
extension CGFloat
{
    static func random() -> CGFloat
    {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

// Returns a random color
extension Color
{
    static var random: Color
    {
        return Color(red: .random(in: 0...1),
                     green: .random(in: 0...1),
                     blue: .random(in: 0...1))
    }
}

// Formats Dates
extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}

// MARK: - Structs
// Changes the navigation bar color & shadow

struct SearchBarModifier: ViewModifier
{
    init(backgroundColor: UIColor, tintColor: UIColor)
    {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = backgroundColor
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = tintColor
    }
    
    func body(content: Content) -> some View
    {
        content
    }
}

extension View
{
    func searchBarModifier(backgroundColor: UIColor, tintColor: UIColor) -> some View
    {
        self.modifier(SearchBarModifier(backgroundColor: backgroundColor, tintColor: tintColor))
    }
}

struct NavigationBarColor: ViewModifier
{
    init(backgroundColor: UIColor, tintColor: UIColor, shadowColor: UIColor?, shadowImage: String)
    {
        let customAppearance = UINavigationBarAppearance()
            customAppearance.configureWithOpaqueBackground()
        
            customAppearance.backgroundColor                  = backgroundColor
            customAppearance.titleTextAttributes              = [.foregroundColor: tintColor]
            customAppearance.largeTitleTextAttributes         = [.foregroundColor: tintColor]
            customAppearance.shadowColor                      = shadowColor
            customAppearance.shadowImage                      = UIImage(named: shadowImage)
                           
            UINavigationBar.appearance().standardAppearance   = customAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = customAppearance
            UINavigationBar.appearance().compactAppearance    = customAppearance
            UINavigationBar.appearance().tintColor            = tintColor
    }
    
    func body(content: Content) -> some View
    {
        content
    }
}

// Applies NavigationBarColor view modifier
extension View
{
    func navigationBarColor(backgroundColor: UIColor, tintColor: UIColor, shadowTint: UIColor? = nil, shadowImage: String) -> some View
    {
        self.modifier(NavigationBarColor(backgroundColor: backgroundColor, tintColor: tintColor, shadowColor: shadowTint, shadowImage: shadowImage))
    }
}

// Creates a drop shadow
extension UIView
{
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true)
    {
        layer.masksToBounds      = false
        layer.shadowColor        = color.cgColor
        layer.shadowOpacity      = opacity
        layer.shadowOffset       = offSet
        layer.shadowRadius       = radius

        layer.shadowPath         = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize    = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

// A more customizable rectangle - allows round corners and to choose which corners to round
struct RoundedCorner: InsettableShape
{
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    var insetAmount: CGFloat = 0.0
    
    func path(in rect: CGRect) -> Path
    {
        let path = UIBezierPath(roundedRect: rect,
            byRoundingCorners: corners, cornerRadii: CGSize(width:
            radius - insetAmount, height: radius - insetAmount))
        return Path(path.cgPath)
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape
    {
        var roundedCorner = self
        roundedCorner.insetAmount += amount
        return roundedCorner
    }
}

// Customizable button template -> overlays shapes to create full buttons instead of text based buttons
struct LargeButtonStyle: ButtonStyle
{
    
    let backgroundColor: Color
    let foregroundColor: Color
    let isDisabled: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View
    {

        let currentForegroundColor = isDisabled || configuration.isPressed ? foregroundColor.opacity(0.3) : foregroundColor
        return configuration.label
            .padding()
            .foregroundColor(currentForegroundColor)
            .background(isDisabled || configuration.isPressed ? backgroundColor.opacity(0.3) : backgroundColor)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(currentForegroundColor, lineWidth: 1)
            )
            .padding([.top, .bottom], 10)
            .font(Font.system(size: 19, weight: .semibold))
    }
}

// Applies the LargeButtonStyle format
struct LargeButton: View
{
    
    private static let buttonHorizontalMargins: CGFloat = 20
    
    var backgroundColor: Color
    var foregroundColor: Color
    
    private let title: String
    private let action: () -> Void
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    init(title: String,
         disabled: Bool = false,
         backgroundColor: Color = Color.green,
         foregroundColor: Color = Color.white,
         action: @escaping () -> Void)
    {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.title = title
        self.action = action
    }
    
    var body: some View
    {
        HStack
        {
            Spacer(minLength: LargeButton.buttonHorizontalMargins)
            Button(action: self.action)
            {
                Text(self.title)
                    .frame(maxWidth:.infinity)
            }
            .buttonStyle(LargeButtonStyle(backgroundColor: backgroundColor,
                                          foregroundColor: foregroundColor,
                                          isDisabled: !isEnabled))
                .disabled(!isEnabled)
            Spacer(minLength: LargeButton.buttonHorizontalMargins)
        }
        .frame(maxWidth:.infinity)
    }
}

// Template for gradient presets
struct aGradient: Identifiable
{
    var id: Int
    var name: String
    var stops: [Gradient.Stop]
}

// MARK: - Functions
// Getter for the topmost safe area of a window scene
func getSafeAreaTop() -> CGFloat
{
    let scenes      = UIApplication.shared.connectedScenes
    let windowScene = scenes.first as? UIWindowScene
    let window      = windowScene?.windows.first

    return (window?.safeAreaInsets.top)!
}

// Generates and draws a semi-random sine wave
func getSineWave(width: CGFloat, height: CGFloat) -> Path
{
    Path
    { path in
        path.move(to: CGPoint(x: 0, y: height/2 + CGFloat.random(in: (-100)...(100))))
        path.addCurve(
            to: CGPoint(x: width, y: height/2 + CGFloat.random(in: (-100)...(100))),
            control1: CGPoint(x: width * CGFloat.random(in: 0.1...0.9), y: CGFloat.random(in: (-100)...(100)) + height/2),
            control2: CGPoint(x: width * CGFloat.random(in: 0.1...0.9), y: CGFloat.random(in: (-100)...(100)) + height/2)
        )
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
    }
}


struct VisualEffectView: UIViewRepresentable
{
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}
