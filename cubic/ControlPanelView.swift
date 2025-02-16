import SwiftUI

struct ControlPanelView: View {
    @ObservedObject var cubeManager: CubeManager
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                GameButton(title: "U", isActive: cubeManager.activeMove == .U) {
                    cubeManager.performMove(.U, record: true)
                }
                GameButton(title: "U'", isActive: cubeManager.activeMove == .UPrime) {
                    cubeManager.performMove(.UPrime, record: true)
                }
                GameButton(title: "D", isActive: cubeManager.activeMove == .D) {
                    cubeManager.performMove(.D, record: true)
                }
                GameButton(title: "D'", isActive: cubeManager.activeMove == .DPrime) {
                    cubeManager.performMove(.DPrime, record: true)
                }
            }
            HStack(spacing: 12) {
                GameButton(title: "L", isActive: cubeManager.activeMove == .L) {
                    cubeManager.performMove(.L, record: true)
                }
                GameButton(title: "L'", isActive: cubeManager.activeMove == .LPrime) {
                    cubeManager.performMove(.LPrime, record: true)
                }
                GameButton(title: "R", isActive: cubeManager.activeMove == .R) {
                    cubeManager.performMove(.R, record: true)
                }
                GameButton(title: "R'", isActive: cubeManager.activeMove == .RPrime) {
                    cubeManager.performMove(.RPrime, record: true)
                }
            }
            HStack(spacing: 12) {
                GameButton(title: "F", isActive: cubeManager.activeMove == .F) {
                    cubeManager.performMove(.F, record: true)
                }
                GameButton(title: "F'", isActive: cubeManager.activeMove == .FPrime) {
                    cubeManager.performMove(.FPrime, record: true)
                }
                GameButton(title: "B", isActive: cubeManager.activeMove == .B) {
                    cubeManager.performMove(.B, record: true)
                }
                GameButton(title: "B'", isActive: cubeManager.activeMove == .BPrime) {
                    cubeManager.performMove(.BPrime, record: true)
                }
            }
            HStack(spacing: 12) {
                GameButton(title: "Scramble", isActive: false) { cubeManager.scramble() }
                GameButton(title: "Solve", isActive: false) { cubeManager.startUnscramble() }
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
