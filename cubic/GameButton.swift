import SwiftUI

struct GameButton: View {
    let title: String
    let isActive: Bool  // New: whether this button is active
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            action()
        }) {
            Text(title)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                                             startPoint: .topLeading,
                                             endPoint: .bottomTrailing))
                        .overlay(
                            isActive ? Color.gray.opacity(0.3) : Color.clear
                        )
                )
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 2, y: 2)
                .scaleEffect(isActive ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isActive)
        }
    }
}

struct GameButton_Previews: PreviewProvider {
    static var previews: some View {
        GameButton(title: "Test", isActive: true, action: {})
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
