class AwesomeParticleShield extends AwesomeParticle
    placeable;

var bool bCanAccess;
var float RespawningTime;

function PostBeginPlay()
{
    super.PostBeginPlay();
}

function Respawn()
{
    SetHidden(false);
    bCanAccess=true;
}

event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
    if(!bCanAccess) return;

    super.Touch(Other,OtherComp,HitLocation,HitNormal);

    if(AwesomePlayerCharacter(Other) != none)
    {
        bCanAccess=false;
        SetTimer(RespawningTime, false, 'Respawn');
        SetHidden(true);
        
    }
}

defaultproperties
{
    bCanAccess=true
    RespawningTime=2.0f;
}