class AwesomeKillVolume extends AwesomeLandVolume
    placeable;

// E_LandType(↓) deprecated. we dont use here :)
//var() E_LandType m_Type;

function PostBeginPlay()
{
}

event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
    local AwesomePlayerController PC;
    local AwesomeHUD UI;

	if(AwesomePlayerCharacter(Other)!=none)
    {
        AwesomePlayerCharacter(Other).VolumeRotationOffset = Rotation;
        AwesomePlayerCharacter(Other).bIsWin=false;
        PC = AwesomePlayerController(AwesomePlayerCharacter(Other).Controller);
        if(PC != none)
        {
            UI = AwesomeHUD(PC.myHUD);
            if(UI != none)
            {
                UI.YouLose();
                //TODO : UI -> GameInfo
            }
        }            
    
    }
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
