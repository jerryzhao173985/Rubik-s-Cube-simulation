import SwiftUI

struct ControlPanelView: View {
    @ObservedObject var cubeManager: CubeManager
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                GameButton(title: "U") { cubeManager.performMove(.U, record: true) }
                GameButton(title: "U'") { cubeManager.performMove(.UPrime, record: true) }
                GameButton(title: "D") { cubeManager.performMove(.D, record: true) }
                GameButton(title: "D'") { cubeManager.performMove(.DPrime, record: true) }
            }
            HStack(spacing: 12) {
                GameButton(title: "L") { cubeManager.performMove(.L, record: true) }
                GameButton(title: "L'") { cubeManager.performMove(.LPrime, record: true) }
                GameButton(title: "R") { cubeManager.performMove(.R, record: true) }
                GameButton(title: "R'") { cubeManager.performMove(.RPrime, record: true) }
            }
            HStack(spacing: 12) {
                GameButton(title: "F") { cubeManager.performMove(.F, record: true) }
                GameButton(title: "F'") { cubeManager.performMove(.FPrime, record: true) }
                GameButton(title: "B") { cubeManager.performMove(.B, record: true) }
                GameButton(title: "B'") { cubeManager.performMove(.BPrime, record: true) }
            }
            HStack(spacing: 12) {
                GameButton(title: "Scramble") { cubeManager.scramble() }
                GameButton(title: "Solve") { cubeManager.startUnscramble() }
            }
        }
    }
}

struct ControlPanelView_Previews: PreviewProvider {
    static var previews: some View {
        ControlPanelView(cubeManager: CubeManager())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
