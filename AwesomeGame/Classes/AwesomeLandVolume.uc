class AwesomeLandVolume extends AwesomeVolume
    placeable;

//deprecated. no use here :)
//var() E_LandType m_Type;

var ParticleSystemComponent WhatAmIPSC;

function PostBeginPlay()
{
}

event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	if(AwesomePlayerCharacter(Other)!=none)
    {
        AwesomePlayerCharacter(Other).VolumeRotationOffset = Rotation;
    }
        //추가 : Enemy?
}

event untouch( Actor Other )
{
	if(AwesomePlayerCharacter(Other)!=none)
    {
        AwesomePlayerCharacter(Other).VolumeRotationOffset = rot(0.0,1.0,0.0);
    }
}

defaultproperties
{
}
