import SwiftUI

struct ContentView: View {
    @StateObject private var cubeManager = CubeManager()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Modern dynamic background gradient
                LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray.opacity(0.8)]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Minimal title
                    Text("Rubik's Cube")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.top, geometry.safeAreaInsets.top + 20)
                        .padding(.bottom, 10)
                    
                    // The 3D cube view: occupies ~70% of the vertical space
                    RubiksCubeView(cubeManager: cubeManager)
                        .frame(width: geometry.size.width,
                               height: geometry.size.height * 0.70)
                        .padding(.horizontal, 10)
                    
                    // Control Panel: occupies the rest of the space
                    ControlPanelView(cubeManager: cubeManager)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                        .padding(.bottom, geometry.safeAreaInsets.bottom + 10)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

