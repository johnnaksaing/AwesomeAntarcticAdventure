class AwesomeMissile extends Projectile
    placeable;

//StaticMesh'phystest_resources.RemadePhysBarrel'

/*  Begin Object Class=SkeletalMeshComponent Name=AwesomePlayerCharacterSkelMeshComponent
            SkeletalMesh=SkeletalMesh'UTExampleCrowd.Mesh.SK_Crowd_Robot'
            //AnimTreeTemplate=
            Scale=3.5
     */
var() StaticMeshComponent SM_Mesh;

var ParticleSystemComponent PSC;
var ParticleSystemComponent Boom;

//Rotation of Projectile(wanted Tilting toward Target : Handleded with AwesomeEnemy when spawned)
var rotator InitialRotation;
var vector Direction;
var bool m_bIsHit;

var SoundCue LaunchSound;
var SoundCue HitSound;
//var CylinderComponent Collision; 

//gets touch() or untouch notifications
var Actor AssociatedActor;

var bool bIsLogged;

//var class SphereComponent Collision;
//http://z3moon.com/엔진/언리얼엔진3/projectile

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    PlaySound(LaunchSound);
}

event TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    Destroy();
}


/*
simulated event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
    //super.Touch(Other, OtherComp, HitLocation,HitNormal);
	//AssociatedActor.Touch(Other, OtherComp, HitLocation, HitNormal);
	if(AwesomePlayerCharacter(Other)!=none)
    {
        `log("PROJECTILEHITPROJECTILEHIT");
        PlaySound(HitSound);
    }
    else
    {
        `log("ELSE__PROJECTILEHIT__ELSE__PROJECTILEHIT");
    }
}
 */

function Tick(float DeltaTime)
{

    local vector NewLocation;
    //local vector ClosestPoint;
    
    //local float HeightDiffernece;
    //local Pawn PC;
    
    //thrusting
    NewLocation = Location + speed * Normal(Direction);

    /*
    if(!bIsLogged){
        `log("MISSILE:::::::::::::::::Directed toward" @ NewLocation);
        bIsLogged=true;    
    } 
    PC = GetALocalPlayerController().Pawn;
    
    
    //check collision
    //HeightDiffernece : Height.(Missile + Character)/2
    HeightDiffernece = 60.0f;
    if( abs(Location.Z - PC.Location.Z) > HeightDiffernece)
    {
        m_bIsHit = false;
    }
    else
    {
        //vector ClosestPoint;
        //PointDistToLine(Target.Location, Direction,Location,ClosestPoint);
        //bDoTouch = ( ClosestPoint - TargetPawn->Location ).Size2D() < TargetPawn->CylinderComponent->CollisionRadius - EffectiveRadius;
    }

    if(m_bIsHit)
    {
        `log("@@@____@@@@__MISSILE__@@___TICK");
        Touch( PC, none, Location, Normal(Location - PC.Location));
        Destroy();
    }
    */

    SetLocation(NewLocation);
}

event Bump(Actor Other, PrimitiveComponent OtherComp, vector HitNormal)
{
    //local PlayerController PC;
    if(AwesomePlayerCharacter(Other) != none)
    {
        PlaySound(HitSound);
        
		//////////////add particle spawning here/////////////
        Boom = WorldInfo.MyEmitterPool.SpawnEmitter(
            ParticleSystem'WP_RocketLauncher.Effects.P_WP_RocketLauncher_RocketExplosion',
            Location,
            rotator(HitNormal)
        );

        `log("Missile Hits PlayerCharacter.");

        // PC = GetALocalPlayerController();
        // PC.ConsoleCommand("Restartlevel");
    }
}

defaultproperties
{
    
    bIsLogged=false
    Speed=2.0f
    bBlockActors=True
    bCollideActors=True
    InitialRotation=(Yaw=32768)
    m_bIsHit=false
    LaunchSound=SoundCue'MyPackage.A_Missile_Launch'
    HitSound=SoundCue'MyPackage.A_Missile_Hit'

    Begin Object Class=StaticMeshComponent Name=AwesomeMissileStaticMeshComponent
            StaticMesh=StaticMesh'phystest_resources.RemadePhysBarrel'
            Scale=1.8
    End Object
    SM_Mesh=AwesomeMissileStaticMeshComponent
    CollisionComponent=AwesomeMissileStaticMeshComponent
    Components.Add(AwesomeMissileStaticMeshComponent);

    Begin Object Class=ParticleSystemComponent Name=FireParticleSystemComponent
        Template=ParticleSystem'WP_RocketLauncher.Effects.P_WP_RocketLauncher_RocketTrail'
        bAutoActivate=true
        Scale=3.0f
    End Object
    PSC=FireParticleSystemComponent
    Components.add(FireParticleSystemComponent)


}
