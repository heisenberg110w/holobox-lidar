import UIKit
import ARKit
import RealityKit

/// Full-screen LiDAR scanner that captures mesh and exports to OBJ.
@available(iOS 13.4, *)
class LidarScannerViewController: UIViewController, ARSessionDelegate {
    
    var onComplete: ((String?) -> Void)?
    
    private var arView: ARView!
    private var meshAnchors: [ARMeshAnchor] = []
    
    // UI Elements
    private let captureButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    private let instructionLabel = UILabel()
    private let progressView = UIProgressView(progressViewStyle: .default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupARView()
        setupUI()
        startSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arView.session.pause()
    }
    
    private func setupARView() {
        arView = ARView(frame: view.bounds)
        arView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        arView.session.delegate = self
        view.addSubview(arView)
    }
    
    private func setupUI() {
        // Instruction Label
        instructionLabel.text = "Move around the object slowly"
        instructionLabel.textColor = .white
        instructionLabel.textAlignment = .center
        instructionLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        instructionLabel.layer.cornerRadius = 8
        instructionLabel.clipsToBounds = true
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(instructionLabel)
        
        // Progress View
        progressView.progressTintColor = UIColor(red: 0.48, green: 0.30, blue: 1.0, alpha: 1.0)
        progressView.trackTintColor = UIColor.white.withAlphaComponent(0.3)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressView)
        
        // Cancel Button
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        cancelButton.layer.cornerRadius = 25
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        // Capture Button
        captureButton.setTitle("Capture", for: .normal)
        captureButton.setTitleColor(.white, for: .normal)
        captureButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        captureButton.backgroundColor = UIColor(red: 0.48, green: 0.30, blue: 1.0, alpha: 1.0)
        captureButton.layer.cornerRadius = 35
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        captureButton.addTarget(self, action: #selector(captureTapped), for: .touchUpInside)
        view.addSubview(captureButton)
        
        NSLayoutConstraint.activate([
            // Instruction Label
            instructionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            instructionLabel.heightAnchor.constraint(equalToConstant: 44),
            
            // Progress View
            progressView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 12),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            progressView.heightAnchor.constraint(equalToConstant: 4),
            
            // Cancel Button
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            cancelButton.widthAnchor.constraint(equalToConstant: 100),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Capture Button
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            captureButton.widthAnchor.constraint(equalToConstant: 140),
            captureButton.heightAnchor.constraint(equalToConstant: 70),
        ])
    }
    
    private func startSession() {
        let config = ARWorldTrackingConfiguration()
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        config.environmentTexturing = .automatic
        arView.session.run(config)
    }
    
    // MARK: - ARSessionDelegate
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if let meshAnchor = anchor as? ARMeshAnchor {
                meshAnchors.append(meshAnchor)
                updateProgress()
            }
        }
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            if let meshAnchor = anchor as? ARMeshAnchor {
                if let index = meshAnchors.firstIndex(where: { $0.identifier == meshAnchor.identifier }) {
                    meshAnchors[index] = meshAnchor
                }
            }
        }
        updateProgress()
    }
    
    private func updateProgress() {
        let progress = min(Float(meshAnchors.count) / 20.0, 1.0)
        DispatchQueue.main.async {
            self.progressView.setProgress(progress, animated: true)
            if progress >= 1.0 {
                self.instructionLabel.text = "Ready! Tap Capture to save"
                self.instructionLabel.backgroundColor = UIColor(red: 0.06, green: 0.73, blue: 0.51, alpha: 0.8)
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func cancelTapped() {
        arView.session.pause()
        onComplete?(nil)
    }
    
    @objc private func captureTapped() {
        captureButton.isEnabled = false
        captureButton.setTitle("Saving...", for: .normal)
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            let objPath = self.exportMeshToOBJ()
            DispatchQueue.main.async {
                self.arView.session.pause()
                self.onComplete?(objPath)
            }
        }
    }
    
    // MARK: - OBJ Export
    
    private func exportMeshToOBJ() -> String? {
        guard !meshAnchors.isEmpty else { return nil }
        
        var objContent = "# Holobox LiDAR Scan\n"
        objContent += "# Vertices and faces from ARMeshAnchor\n\n"
        
        var vertexOffset = 0
        
        for meshAnchor in meshAnchors {
            let geometry = meshAnchor.geometry
            let vertices = geometry.vertices
            let faces = geometry.faces
            let transform = meshAnchor.transform
            
            // Export vertices
            for i in 0..<vertices.count {
                let vertex = vertices[i]
                let localPos = SIMD4<Float>(vertex.0, vertex.1, vertex.2, 1.0)
                let worldPos = transform * localPos
                objContent += "v \(worldPos.x) \(worldPos.y) \(worldPos.z)\n"
            }
            
            // Export faces
            let faceBuffer = faces.buffer.contents().bindMemory(to: UInt32.self, capacity: faces.count * 3)
            for i in 0..<faces.count {
                let i0 = Int(faceBuffer[i * 3]) + 1 + vertexOffset
                let i1 = Int(faceBuffer[i * 3 + 1]) + 1 + vertexOffset
                let i2 = Int(faceBuffer[i * 3 + 2]) + 1 + vertexOffset
                objContent += "f \(i0) \(i1) \(i2)\n"
            }
            
            vertexOffset += vertices.count
        }
        
        // Save to temp file
        let fileName = "scan_\(UUID().uuidString).obj"
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent(fileName)
        
        do {
            try objContent.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL.path
        } catch {
            print("Failed to write OBJ: \(error)")
            return nil
        }
    }
}

// MARK: - ARMeshGeometry Extension

@available(iOS 13.4, *)
extension ARMeshGeometry {
    var vertices: [(Float, Float, Float)] {
        var result: [(Float, Float, Float)] = []
        let buffer = self.vertices.buffer.contents()
        let stride = self.vertices.stride
        for i in 0..<self.vertices.count {
            let ptr = buffer.advanced(by: i * stride).assumingMemoryBound(to: SIMD3<Float>.self)
            let v = ptr.pointee
            result.append((v.x, v.y, v.z))
        }
        return result
    }
}
