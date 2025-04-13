import Metal
import MetalKit

class MagicMetalView: MTKView {
    var commandQueue: MTLCommandQueue!
    var pipelineState: MTLRenderPipelineState!
    var effect: String!
    var time: Float = 0
    var texture: MTLTexture?

    let vertices: [SIMD2<Float>] = [
        SIMD2<Float>(0, 0),
        SIMD2<Float>(1, 0),
        SIMD2<Float>(0, 1),
        SIMD2<Float>(1, 1)
    ]

    init(effect: String, frame: CGRect) {
        self.effect = effect
        super.init(frame: frame, device: MTLCreateSystemDefaultDevice())

        self.commandQueue = device!.makeCommandQueue()
        self.setupPipeline()

        let displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink.add(to: .current, forMode: .default)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupPipeline() {
        let library = device!.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertexShader")
        let fragmentFunction = library?.makeFunction(name: effect)

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm

        do {
            pipelineState = try device!.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error {
            print("Failed to create pipeline state: \(error)")
        }
    }

    @objc func update() {
        self.time += 1.0 / Float(self.preferredFramesPerSecond)
        self.setNeedsDisplay()
    }

    func loadTexture(from image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        let textureLoader = MTKTextureLoader(device: device!)
        do {
            texture = try textureLoader.newTexture(cgImage: cgImage, options: nil)
        } catch {
            print("Failed to load texture: \(error)")
        }
    }

    override func draw(_ rect: CGRect) {
        guard let drawable = currentDrawable else { return }
        let renderPassDescriptor = currentRenderPassDescriptor!
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!

        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBytes(vertices, length: vertices.count * MemoryLayout<SIMD2<Float>>.size, index: 0)

        renderEncoder.setFragmentBytes(&time, length: MemoryLayout<Float>.size, index: 0)
        var resolution = SIMD2<Float>(Float(drawable.texture.width), Float(drawable.texture.height))
        renderEncoder.setFragmentBytes(&resolution, length: MemoryLayout<SIMD2<Float>>.size, index: 1)

        if let texture = texture {
            renderEncoder.setFragmentTexture(texture, index: 0)
        }

        renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)

        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
