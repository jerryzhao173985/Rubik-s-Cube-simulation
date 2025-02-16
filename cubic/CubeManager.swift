import SceneKit
import SwiftUI

// MARK: – Cubie Data Model
class Cubie {
    let id = UUID()
    let node: SCNNode
    var logicalPosition: (x: Int, y: Int, z: Int)
    let solvedPosition: (x: Int, y: Int, z: Int)
    var netRotation: SCNQuaternion
    
    init(node: SCNNode, position: (x: Int, y: Int, z: Int)) {
        self.node = node
        self.logicalPosition = position
        self.solvedPosition = position
        self.netRotation = SCNQuaternion(0, 0, 0, 1)
    }
}

// MARK: – Cube Moves
enum CubeMove: String, CaseIterable {
    case U, UPrime, D, DPrime, L, LPrime, R, RPrime, F, FPrime, B, BPrime
    
    var axis: SCNVector3 {
        switch self {
        case .U, .UPrime, .D, .DPrime:
            return SCNVector3(0, 1, 0)
        case .L, .LPrime, .R, .RPrime:
            return SCNVector3(1, 0, 0)
        case .F, .FPrime, .B, .BPrime:
            return SCNVector3(0, 0, 1)
        }
    }
    
    var angle: Float {
        switch self {
        case .U, .D, .L, .R, .F, .B:
            return Float.pi / 2
        case .UPrime, .DPrime, .LPrime, .RPrime, .FPrime, .BPrime:
            return -Float.pi / 2
        }
    }
    
    var affectedLayer: (axis: String, value: Int) {
        switch self {
        case .U, .UPrime:
            return ("y", 1)
        case .D, .DPrime:
            return ("y", -1)
        case .L, .LPrime:
            return ("x", -1)
        case .R, .RPrime:
            return ("x", 1)
        case .F, .FPrime:
            return ("z", 1)
        case .B, .BPrime:
            return ("z", -1)
        }
    }
    
    func rotateCoordinate(_ coord: (x: Int, y: Int, z: Int)) -> (x: Int, y: Int, z: Int) {
        switch self {
        case .U:
            return (x: coord.z, y: coord.y, z: -coord.x)
        case .UPrime:
            return (x: -coord.z, y: coord.y, z: coord.x)
        case .D:
            return (x: -coord.z, y: coord.y, z: coord.x)
        case .DPrime:
            return (x: coord.z, y: coord.y, z: -coord.x)
        case .L:
            return (x: coord.x, y: coord.z, z: -coord.y)
        case .LPrime:
            return (x: coord.x, y: -coord.z, z: coord.y)
        case .R:
            return (x: coord.x, y: -coord.z, z: coord.y)
        case .RPrime:
            return (x: coord.x, y: coord.z, z: -coord.y)
        case .F:
            return (x: coord.y, y: -coord.x, z: coord.z)
        case .FPrime:
            return (x: -coord.y, y: coord.x, z: coord.z)
        case .B:
            return (x: -coord.y, y: coord.x, z: coord.z)
        case .BPrime:
            return (x: coord.y, y: -coord.x, z: coord.z)
        }
    }
    
    var quaternion: SCNQuaternion {
        let halfAngle = angle / 2
        let sinHalf = sin(halfAngle)
        let cosHalf = cos(halfAngle)
        let a = axis
        return SCNQuaternion(a.x * sinHalf, a.y * sinHalf, a.z * sinHalf, cosHalf)
    }
    
    var inverse: CubeMove {
        switch self {
        case .U: return .UPrime
        case .UPrime: return .U
        case .D: return .DPrime
        case .DPrime: return .D
        case .L: return .LPrime
        case .LPrime: return .L
        case .R: return .RPrime
        case .RPrime: return .R
        case .F: return .FPrime
        case .FPrime: return .F
        case .B: return .BPrime
        case .BPrime: return .B
        }
    }
}

// MARK: – CubeManager
class CubeManager: ObservableObject {
    let scene: SCNScene
    let cubeNode: SCNNode
    var cubies: [Cubie] = []
    let offset: Float = 1.1
    var moveHistory: [CubeMove] = []
    var isAnimating = false
    var unscrambleTimer: Timer?
    
    // **New published property to indicate which move is active**
    @Published var activeMove: CubeMove? = nil
    
    init() {
        scene = SCNScene()
        cubeNode = SCNNode()
        scene.rootNode.addChildNode(cubeNode)
        setupScene()
        buildCube()
    }
    
    func setupScene() {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(7, 7, 7)
        let constraint = SCNLookAtConstraint(target: cubeNode)
        constraint.isGimbalLockEnabled = true
        cameraNode.constraints = [constraint]
        scene.rootNode.addChildNode(cameraNode)
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(10, 10, 10)
        scene.rootNode.addChildNode(lightNode)
        
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLight)
    }
    
    func buildCube() {
        for x in -1...1 {
            for y in -1...1 {
                for z in -1...1 {
                    let cubieNode = createCubie()
                    let pos = SCNVector3(Float(x) * offset, Float(y) * offset, Float(z) * offset)
                    cubieNode.position = pos
                    cubeNode.addChildNode(cubieNode)
                    let cubie = Cubie(node: cubieNode, position: (x, y, z))
                    cubies.append(cubie)
                }
            }
        }
    }
    
    func createCubie() -> SCNNode {
        let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0.05)
        let front = SCNMaterial(); front.diffuse.contents = UIColor.red
        let right = SCNMaterial(); right.diffuse.contents = UIColor.blue
        let back = SCNMaterial(); back.diffuse.contents = UIColor.orange
        let left = SCNMaterial(); left.diffuse.contents = UIColor.green
        let top = SCNMaterial(); top.diffuse.contents = UIColor.white
        let bottom = SCNMaterial(); bottom.diffuse.contents = UIColor.yellow
        box.materials = [front, right, back, left, top, bottom]
        return SCNNode(geometry: box)
    }
    
    func updateCubieTransform(_ cubie: Cubie) {
        let newPos = SCNVector3(Float(cubie.logicalPosition.x) * offset,
                                Float(cubie.logicalPosition.y) * offset,
                                Float(cubie.logicalPosition.z) * offset)
        cubie.node.position = newPos
        cubie.node.orientation = cubie.netRotation
    }
    
    // **Modified performMove: set activeMove before animation and clear it after**
    func performMove(_ move: CubeMove, record: Bool = true, completion: (() -> Void)? = nil) {
        guard !isAnimating else { return }
        isAnimating = true
        // Set the active move so that the corresponding button can animate.
        DispatchQueue.main.async {
            self.activeMove = move
        }
        
        let layer = move.affectedLayer
        let affectedCubies = cubies.filter { cubie in
            switch layer.axis {
            case "x": return cubie.logicalPosition.x == layer.value
            case "y": return cubie.logicalPosition.y == layer.value
            case "z": return cubie.logicalPosition.z == layer.value
            default: return false
            }
        }
        
        let groupNode = SCNNode()
        cubeNode.addChildNode(groupNode)
        for cubie in affectedCubies {
            cubie.node.removeFromParentNode()
            groupNode.addChildNode(cubie.node)
        }
        
        let rotationAction = SCNAction.rotate(by: CGFloat(move.angle), around: move.axis, duration: 0.3)
        groupNode.runAction(rotationAction) { [weak self] in
            guard let self = self else { return }
            for cubie in affectedCubies {
                cubie.logicalPosition = move.rotateCoordinate(cubie.logicalPosition)
                let oldQuat = cubie.netRotation
                let moveQuat = move.quaternion
                cubie.netRotation = self.multiplyQuaternion(q1: moveQuat, q2: oldQuat)
                
                let worldTransform = cubie.node.worldTransform
                cubie.node.transform = self.cubeNode.convertTransform(worldTransform, from: nil)
                self.cubeNode.addChildNode(cubie.node)
                self.updateCubieTransform(cubie)
            }
            groupNode.removeFromParentNode()
            if record { self.moveHistory.append(move) }
            self.isAnimating = false
            // Clear the active move to remove highlight.
            DispatchQueue.main.async {
                self.activeMove = nil
            }
            completion?()
        }
    }
    
    func multiplyQuaternion(q1: SCNQuaternion, q2: SCNQuaternion) -> SCNQuaternion {
        let w1 = q1.w, x1 = q1.x, y1 = q1.y, z1 = q1.z
        let w2 = q2.w, x2 = q2.x, y2 = q2.y, z2 = q2.z
        let w = w1 * w2 - x1 * x2 - y1 * y2 - z1 * z2
        let x = w1 * x2 + x1 * w2 + y1 * z2 - z1 * y2
        let y = w1 * y2 - x1 * z2 + y1 * w2 + z1 * x2
        let z = w1 * z2 + x1 * y2 - y1 * x2 + z1 * w2
        return SCNQuaternion(x, y, z, w)
    }
    
    // ... (Scramble and Solve functionality remains the same)
    
    func scramble() {
        guard !isAnimating else { return }
        let moves = CubeMove.allCases
        let scrambleCount = 20
        var count = 0
        
        func performNext() {
            if count >= scrambleCount { return }
            let move = moves.randomElement()!
            self.performMove(move, record: true) {
                count += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    performNext()
                }
            }
        }
        performNext()
    }
    
    func startUnscramble() {
        unscrambleTimer?.invalidate()
        unscrambleTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
            self?.applyNextUnscrambleMove()
        }
    }
    
    func applyNextUnscrambleMove() {
        guard !isAnimating else { return }
        if let lastMove = moveHistory.popLast() {
            self.performMove(lastMove.inverse, record: false) {
                if self.moveHistory.isEmpty && self.isSolved() {
                    self.unscrambleTimer?.invalidate()
                    self.unscrambleTimer = nil
                    print("Cube solved!")
                }
            }
        } else {
            unscrambleTimer?.invalidate()
            unscrambleTimer = nil
            if isSolved() { print("Cube solved!") }
        }
    }
    
    func isSolved() -> Bool {
        let tolerance: Float = 0.001
        for cubie in cubies {
            if cubie.logicalPosition != cubie.solvedPosition { return false }
            let q = cubie.netRotation
            if abs(q.x) > tolerance || abs(q.y) > tolerance || abs(q.z) > tolerance || abs(q.w - 1) > tolerance {
                return false
            }
        }
        return true
    }
}
