class AwesomePlayerController extends PlayerController;

    enum E_LandType
    {
        Ty_ICE,
        Ty_WATER,
        Ty_LOSE,
        Ty_WIN
    };

var() vector PlayerCameraOffset;
var rotator CurrentCameraRotation;

var float speed;
var float BumpSpeed_missile;
var float BumpSpeed_blocking;
//handling inputs, camera location/rotation, controls, etc.

event PlayerTick( float DeltaTime )
{
    if(Pawn != none)
    {
        super.PlayerTick(DeltaTime);
    }
}

/*
    DeathLocation = vect(0,0,0);
    SetLocation(DeathLocation);
    PlayerCameraOffset=vect(200,0,0);
 */

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    Pawn.GroundSpeed = speed;
    `log("AwesomePlayerController Spawned.........");
}

simulated event GetPlayerViewPoint(out vector out_Location, out Rotator out_Rotation)
{
    super.GetPlayerViewPoint(out_Location, out_Rotation);
    
    if(Pawn != none)
    {
        out_Location = Pawn.Location + PlayerCameraOffset;// + (PlayerCameraOffset >> Pawn.Rotation);
        out_Rotation = rotator(Pawn.Location - out_Location); // rotator((out_Location * vect(1,1,0)) - out_Location);
    }
    CurrentCameraRotation = out_Rotation;
}

reliable client function ClientSetHud(class<HUD> newHUDType)
{
    if(myHUD != none)
        myHUD.Destroy();

    myHUD = spawn(class'AwesomeHUD', self);
}


function UpdateRotation( float DeltaTime )
{
	local Rotator DeltaRot, newRotation, ViewRotation;

	ViewRotation = Rotation;
	if (Pawn!=none)
	{
		Pawn.SetDesiredRotation(ViewRotation);
	}

	// Calculate Delta to be applied on ViewRotation
	//DeltaRot.Yaw	= PlayerInput.aStrafe;
    DeltaRot.Yaw	= PlayerInput.aTurn;
	DeltaRot.Pitch	= Rotation.Pitch;

	ProcessViewRotation( DeltaTime, ViewRotation, DeltaRot );

	SetRotation(ViewRotation);
	ViewShake( deltaTime );

	NewRotation = ViewRotation;
	NewRotation.Roll = Rotation.Roll;

	if ( Pawn != None )
		Pawn.FaceRotation(NewRotation, deltatime);
}

state PlayerWalking
{
    function ProcessMove(float DeltaTime, vector newAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
    {
        local vector X, Y, Z, AltAccel;
        local vector VelocityDirectionWithoutZ;
        local vector IceOffset;
        if(AwesomePlayerCharacter(Pawn).bIsWin){return;}
        if(AwesomePlayerCharacter(Pawn).bInvulnerable)
        {
            //`log("=====PlayerController : AwesomePlayerCharacter(Pawn).bInvulnerable========");
            GetAxes(CurrentCameraRotation,X,Y,Z);
            Pawn.SetRotation(Rotator( AwesomePlayerCharacter(Pawn).BumpOffset) );
            AltAccel = Normal(AwesomePlayerCharacter(Pawn).BumpOffset) * -BumpSpeed_missile; // * speed;

            super.ProcessMove(DeltaTime, AltAccel, DoubleClickMove, DeltaRot);
        }
        else if(AwesomePlayerCharacter(Pawn).bBlocked)
        {
            GetAxes(CurrentCameraRotation,X,Y,Z);
            Pawn.SetRotation(Rotator( AwesomePlayerCharacter(Pawn).BumpOffset) );
            AltAccel = Normal(AwesomePlayerCharacter(Pawn).BumpOffset) * -BumpSpeed_blocking; // * speed;

            super.ProcessMove(DeltaTime, AltAccel, DoubleClickMove, DeltaRot);
        }
        else
        {
            VelocityDirectionWithoutZ = Pawn.Velocity;
            VelocityDirectionWithoutZ.Z = 0.0;
            Pawn.SetRotation(Rotator(VelocityDirectionWithoutZ));

            GetAxes(CurrentCameraRotation,X,Y,Z);
            AltAccel = PlayerInput.aForward * Z + PlayerInput.aStrafe * Y;
        
            AltAccel.Z = 0;
            IceOffset = vect(0,0,0);
            
            if(AwesomePlayerCharacter(Pawn).CurrentLandInformation == Ty_WATER)
            {
                //`log("AAAA");
                Pawn.GroundSpeed = 512.0f;
                if(AwesomePlayerCharacter(Pawn).AssociatedVolume != none)
                {
                    //add (volume.location - self.location) vector
                    IceOffset = Normal(AwesomePlayerCharacter(Pawn).AssociatedVolume.Location - Pawn.Location);
                    //`log(IceOffset);                    
                }
            }
            else
            {
                //`log("BBBB");
                Pawn.GroundSpeed = speed;
            }
            AltAccel -= IceOffset * speed * 0.6;
            
            AltAccel = Pawn.AccelRate * Normal(AltAccel) * speed;

                        
            super.ProcessMove(DeltaTime, AltAccel, DoubleClickMove, DeltaRot);
        }
    }
}

state GameEnd
{

}

defaultproperties
{
    speed=900.0f
    PlayerCameraOffset=(X=960,Y=64,Z=960)
    BumpSpeed_blocking=9000.0f
    BumpSpeed_missile=3000.0f    
}