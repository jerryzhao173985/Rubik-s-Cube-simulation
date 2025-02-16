import SwiftUI

struct ContentView: View {
    @StateObject private var cubeManager = CubeManager()
    
    var body: some View {
        ZStack {
            // Background: a modern, dynamic gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack {
                // Title at the top
                Text("Rubik's Cube Simulator")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                // The 3D cube view expands to fill available space
                RubiksCubeView(cubeManager: cubeManager)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                
                // Control Panel: buttons for manual moves, scramble and solve
                ControlPanelView(cubeManager: cubeManager)
                    .padding(.bottom, 20)
            }
        }
    }
}

struct ControlPanelView: View {
    @ObservedObject var cubeManager: CubeManager
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                CubeButton(title: "U") { cubeManager.performMove(.U, record: true) }
                CubeButton(title: "U'") { cubeManager.performMove(.UPrime, record: true) }
                CubeButton(title: "D") { cubeManager.performMove(.D, record: true) }
                CubeButton(title: "D'") { cubeManager.performMove(.DPrime, record: true) }
            }
            HStack(spacing: 12) {
                CubeButton(title: "L") { cubeManager.performMove(.L, record: true) }
                CubeButton(title: "L'") { cubeManager.performMove(.LPrime, record: true) }
                CubeButton(title: "R") { cubeManager.performMove(.R, record: true) }
                CubeButton(title: "R'") { cubeManager.performMove(.RPrime, record: true) }
            }
            HStack(spacing: 12) {
                CubeButton(title: "F") { cubeManager.performMove(.F, record: true) }
                CubeButton(title: "F'") { cubeManager.performMove(.FPrime, record: true) }
                CubeButton(title: "B") { cubeManager.performMove(.B, record: true) }
                CubeButton(title: "B'") { cubeManager.performMove(.BPrime, record: true) }
            }
            HStack(spacing: 12) {
                CubeButton(title: "Scramble") { cubeManager.scramble() }
                CubeButton(title: "Solve") { cubeManager.startUnscramble() }
            }
        }
    }
}

/// A custom button style for cube moves.
struct CubeButton: View {
    let title: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(minWidth: 60, minHeight: 44)
                .padding(.horizontal, 8)
                .background(Color.black.opacity(0.6))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 2, y: 2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

