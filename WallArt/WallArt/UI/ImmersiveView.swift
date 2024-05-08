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
        RealityView { content in
            do {
               let immersiveEntity = try await Entity(named: "Immersive", in: realityKitContentBundle)
                characterEntity.addChild(immersiveEntity)
                    content.add(immersiveEntity)
                content.add(planeEntity)
            } catch {
                print("Error in RealityView's make: \(error)")
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
