class AwesomeEnemy extends AwesomeActor
    placeable;


var() SkeletalMeshComponent Mesh;

var int CurrentLocation;

//Player Character
var Pawn Target;

//location
var() vector InitialLocation;

//distance threshold
var() float FollowingDistance;
var() float ShootingDistance;
var() float GuardingMaxDistance;
var() float GuardingMinDistance;

var bool  bIsReloadingDone;
var float ReloadingTime;

//true when hunting playercharacter, false when is-going-back condition.
var bool bIsGoingBackDone;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    InitialLocation = Location;
    `log("Location " @ self @ InitialLocation);
}

function Tick(float DeltaTime)
{
    local AwesomePlayerController PC;
    local vector NewLocation;
    local rotator NewRotation;
    //not detected Pawn yet : find it.
    if(Target == none){
        foreach LocalPlayerControllers(class'AwesomePlayerController', PC)
        {
            if(PC.Pawn != none)
            {
                Target = PC.Pawn;
                `log("Target Found."@self @Target);
            }
        }
    }
    
    //I am too far : going back.
    if(VSize(InitialLocation - Location) > GuardingMaxDistance || !bIsGoingBackDone)
    {   
        if(VSize(InitialLocation - Location) < GuardingMinDistance)
        {
            bIsGoingBackDone = true;
        }
        else
        {
            bIsGoingBackDone=false;

            NewRotation = rotator(InitialLocation - Location);
            NewLocation = Location;
            NewLocation += (InitialLocation - Location) * DeltaTime;

            //spawn particle DISAPPEAR
            //TODO: make state
            // if(!bIsGoingBackDone) ~~~~~ ......
            

            SetLocation(NewLocation);
            SetRotation(NewRotation);
        }
    }
   
    //Target Pawn(PlayerCharacter) is not too far
    else 
    {
        if(VSize(Location - Target.Location) < FollowingDistance && VSize(Location - Target.Location) > ShootingDistance + 20.0f)
        {
            NewRotation = rotator(Target.Location - Location);

            NewLocation = Location;
            NewLocation += (Target.Location - Location) * DeltaTime * 0.5;

            if(VSize(Location - Target.Location) > ShootingDistance)
            {
                LaunchMissile();
                //inside Missile Collision dicision : if(distance < threshold) Target.HIT();
            }

            SetLocation(NewLocation);
            SetRotation(NewRotation);
        }
            // else : move backward(slowly if possible)
        else if(VSize(Location - Target.Location) < ShootingDistance)
        {
            NewRotation = rotator(Target.Location - Location);

            NewLocation = Location;
            NewLocation -= (Target.Location - Location) * DeltaTime * 0.3;
            NewLocation.Z = Location.Z;

            if(VSize(Location - Target.Location) > ShootingDistance)
            {
                LaunchMissile();
                //inside Missile Collision dicision : if(distance < threshold) Target.HIT();
            }
            SetLocation(NewLocation);
            SetRotation(NewRotation);
        }
    }


}

function LaunchMissile()
{
    local AwesomeMissile projectile;
    //projectile.Init();
    local vector AimDir;
    AimDir = Target.Location - Location;
   
    if(bIsReloadingDone)
    {
        bIsReloadingDone=false;
        SetTimer(ReloadingTime, false, 'ReloadMissile');

        `log("PEW!! PEW!! PEW!! PEW!!");
        projectile = Spawn(class'AwesomeMissile',Self,,Location);

        if( projectile != None && !projectile.bDeleteMe )
		{
			projectile.Init( AimDir );
		}
    }

}

function ReloadMissile()
{
    bIsReloadingDone = true;
}

/**
 * Fires a projectile.
 * Spawns the projectile, but also increment the flash count for remote client effects.
 * Network: Local Player and Server


simulated function Projectile ProjectileFire()
{
	local vector		StartTrace, EndTrace, RealStartLoc, AimDir;
	local ImpactInfo	TestImpact;
	local Projectile	SpawnedProjectile;

	// tell remote clients that we fired, to trigger effects
	//IncrementFlashCount();

	if( Role == ROLE_Authority )
	{
		// This is where we would start an instant trace. (what CalcWeaponFire uses)
		StartTrace = Instigator.GetWeaponStartTraceLocation();
		AimDir = Vector(GetAdjustedAim( StartTrace ));

		// this is the location where the projectile is spawned.
		RealStartLoc = GetPhysicalFireStartLoc(AimDir);

		if( StartTrace != RealStartLoc )
		{
			// if projectile is spawned at different location of crosshair,
			// then simulate an instant trace where crosshair is aiming at, Get hit info.
			EndTrace = StartTrace + AimDir * GetTraceRange();
			TestImpact = CalcWeaponFire( StartTrace, EndTrace );

			// Then we realign projectile aim direction to match where the crosshair did hit.
			AimDir = Normal(TestImpact.HitLocation - RealStartLoc);
		}

		// Spawn projectile
		SpawnedProjectile = Spawn(GetProjectileClass(), Self,, RealStartLoc);
		if( SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe )
		{
			SpawnedProjectile.Init( AimDir );
		}

		// Return it up the line
		return SpawnedProjectile;
	}

	return None;
}
 */

defaultproperties
{
    bBlockActors=True
    bCollideActors=True
    FollowingDistance=1024.0
    ShootingDistance=640.0
    
    GuardingMaxDistance=4000.0
    GuardingMinDistance=64.0


    bIsReloadingDone=true
    ReloadingTime=0.9

    Begin Object Class=SkeletalMeshComponent Name=AwesomeEnemySkelMeshComponent
            SkeletalMesh=SkeletalMesh'VH_Manta.Mesh.SK_VH_Manta'
            //AnimTreeTemplate=
            Scale=1.075
    End Object
    Mesh=AwesomeEnemySkelMeshComponent
    Components.Add(AwesomeEnemySkelMeshComponent);
}

//SkeletalMesh'VH_Manta.Mesh.SK_VH_Manta'
//SkeletalMesh=SkeletalMesh'UTExampleCrowd.Mesh.SK_Crowd_Robot'