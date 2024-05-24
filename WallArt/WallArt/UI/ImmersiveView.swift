//
//  ImmersiveView.swift
//  WallArt
//
//  Created by Briana Bayne on 5/8/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    
    // Adding a reference of the viewModel to the view
    @Environment(ViewModel.self) private var viewModel
    @State private var inputText = ""
    @State public var showTextField = false
    
    @State var characterEntity: Entity = {
        // This anchor is going to be positioned at the users head
        let headAnchor = AnchorEntity(.head)
        // position = X, Y, Zed access
        headAnchor.position = [0.70, -0.35, -1]
        // returning with the headAnchor
        let radians = -30 * Float.pi / 180
        ImmersiveView.rotateEntityAroundYAxis(entity: headAnchor, angle: radians)
        return headAnchor
    }()
    
    @State var planeEntity: Entity = {
        // anchoring it to a vertical plane
        let wallAnchor = AnchorEntity(.plane(.vertical, classification: .wall, minimumBounds: SIMD2<Float>(0.6, 0.6)))
        // creates a Mesh
        let planeMesh = MeshResource.generatePlane(width: 3.75, depth: 2.625, cornerRadius: 0.1)
        // creating a color
        let material = ImmersiveView.loadImageMaterial(imageURL: "thinkDifferent")
        let planeEntity = ModelEntity(mesh: planeMesh,materials: [material])
        planeEntity.name = "canvas"
        wallAnchor.addChild(planeEntity)
        return wallAnchor
    }()
    
    
    var body: some View {
        RealityView { content, attachments in
            do {
               let immersiveEntity = try await Entity(named: "Immersive", in: realityKitContentBundle)
                characterEntity.addChild(immersiveEntity)
                    content.add(immersiveEntity)
                content.add(planeEntity)
                
                guard let attachmentEntity = attachments.entity(for: "attachment") else {return}
                attachmentEntity.position = SIMD3<Float>(0,0.62,0)
                let radians = 30 * Float.pi / 180
                ImmersiveView.rotateEntityAroundYAxis(entity: attachmentEntity, angle: radians)
                characterEntity.addChild(attachmentEntity)
                
                
            } catch {
                print("Error in RealityView's make: \(error)")
            }
            /// Used to have the character wave 
        } attachments: {
            Attachment(id: "attachment") {
                VStack {
                    Text(inputText)
                        .frame(maxWidth: 600, alignment: .leading)
                        .font(.extraLargeTitle2)
                        .fontWeight(.regular)
                        .padding(40)
                        .glassBackgroundEffect()
//                        .tag("attachment") - Not sure if I need this??? 
                        .opacity(showTextField ? 1: 0)
            }
                    
            }
      
        }
        .gesture(SpatialTapGesture().targetedToAnyEntity().onEnded { _ in
            viewModel.flowState = .intro
        })
        .onChange(of: viewModel.flowState) { _, newValue in
            switch newValue {
            case.idle:
                break
            case.intro:
                break
            case.projectileFlying:
                break
            case.updatedWallArt:
                break
            }
        }
    }
    
    
    func playIntroSequence() {
        Task {
            if !showTextField {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showTextField.toggle()
                }
            }
        }
    }
    
    static func rotateEntityAroundYAxis(entity: Entity, angle: Float) {
        // Get the current transform of the entity
        var currentTransform = entity.transform
        
        // Create a quaternion representing a rotation around the Y-axis
        let rotation = simd_quatf(angle: angle, axis: [0,1,0])
        
        // Combine the rotation with a current transform
        currentTransform.rotation = rotation * currentTransform.rotation
        
        // Apply the new transform of the entity
        entity.transform = currentTransform
    }
    
    static func loadImageMaterial(imageURL: String) -> SimpleMaterial {
        do {
            let texture = try TextureResource.load(named: imageURL)
            var material = SimpleMaterial()
            let color = SimpleMaterial.BaseColor(texture: MaterialParameters.Texture(texture))
            material.color = color
            return material
        } catch {
           fatalError(String(describing: error))
        }
    }

}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
}
