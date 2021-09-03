class AwesomeBlocking extends AwesomeParticle
    placeable;

function PostBeginPlay()
{
    SetCollisionType(COLLIDE_BlockAll);
}

event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
    `log("Blocking Touch Event Detected at "@ self);
}


event Bump(Actor Other, PrimitiveComponent OtherComp, vector HitNormal)
{
    if(AwesomePlayerCharacter(Other) != none)
    {
		//////////////add particle spawning here/////////////
        WorldInfo.MyEmitterPool.SpawnEmitter(
            ParticleSystem'FX_VehicleExplosions.Effects.P_FX_VehicleDeathExplosion',
            Location,
            rotator(HitNormal)
        );

        `log(self @ " : PlayerCharacter Hits Me.");
    }
}

defaultproperties
{
    Begin Object Class=ParticleSystemComponent Name=ViewFireParticleSystemComponent
        Template=ParticleSystem'VH_Scorpion.Effects.P_Scorpion_Bounce_Projectile_Red'
        bAutoActivate=true
        Scale=3.0f
    End Object
    FirePSC=ViewFireParticleSystemComponent
    Components.add(ViewFireParticleSystemComponent)
}

    //collision already in A.particle.uc
    /**    Begin Object Class=CylinderComponent Name=CollisionCylinder
        HiddenEditor=false
    End Object
    CollisionComponent=CollisionCylinder
    Components.add(CollisionCylinder)
     */