import SwiftUI
import SceneKit

/// A UIViewRepresentable that wraps an SCNView so SceneKit can be embedded within SwiftUI.
struct RubiksCubeView: UIViewRepresentable {
    let cubeManager: CubeManager
    
    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.scene = cubeManager.scene
        scnView.allowsCameraControl = true  // Enable user orbit/zoom
        scnView.autoenablesDefaultLighting = false
        scnView.backgroundColor = UIColor.clear
        scnView.antialiasingMode = .multisampling4X  // Smoother edges
        return scnView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) { }
}
