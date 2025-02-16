import SwiftUI

struct ContentView: View {
    @StateObject private var cubeManager = CubeManager()
    
    var body: some View {
        ZStack {
            // Modern dynamic background gradient
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray.opacity(0.8)]),
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // A minimal title with modern rounded font
                Text("Rubik's Cube")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 40)
                    .padding(.bottom, 10)
                
                // The 3D cube view (full screen, with minimal padding)
                RubiksCubeView(cubeManager: cubeManager)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 20)
                
                // Control Panel: buttons in a bottom sheet style
                ControlPanelView(cubeManager: cubeManager)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 30)
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
