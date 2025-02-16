import SwiftUI
import SceneKit

/// A UIViewRepresentable that wraps an SCNView so SceneKit can be embedded within SwiftUI.
struct RubiksCubeView: UIViewRepresentable {
    let cubeManager: CubeManager
    
    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.scene = cubeManager.scene
        scnView.allowsCameraControl = true  // Let the user orbit/zoom.
        scnView.autoenablesDefaultLighting = false
        scnView.backgroundColor = UIColor.clear
        // Enable antialiasing for smoother edges.
        scnView.antialiasingMode = .multisampling4X
        return scnView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) { }
}

