class AwesomeParticle extends AwesomeActor
    placeable;

var ParticleSystemComponent FirePSC;

function PostBeginPlay()
{
    SetCollisionType(COLLIDE_TouchAll);
}

event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
    `log("Particle Touch Event Detected");
}

defaultproperties
{
    Begin Object Class=ParticleSystemComponent Name=FireParticleSystemComponent
        Template=ParticleSystem'VH_Scorpion.Effects.P_Scorpion_Bounce_Projectile'
        bAutoActivate=true
        Scale=3.0f
    End Object
    FirePSC=FireParticleSystemComponent
    Components.add(FireParticleSystemComponent)

    Begin Object Class=SpriteComponent Name=Sprite_Particle
        Sprite=Texture2D'EditorResources.S_NavP'
        HiddenGame=true
        HiddenEditor=false
    End Object

    Begin Object Class=CylinderComponent Name=CollisionCylinder
        HiddenEditor=false
    End Object
    CollisionComponent=CollisionCylinder
    Components.add(CollisionCylinder)
}