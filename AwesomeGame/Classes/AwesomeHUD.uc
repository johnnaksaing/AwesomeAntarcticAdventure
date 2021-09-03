class AwesomeHUD extends HUD;

var Texture2D DefaultTexture;


simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    `log("AwesomeHUD Spawned");
}

//PlayerCharacter의 상태를 띄울 수 있다. 디버깅에 참고할 것.
function CharacterInformation()
{
    Canvas.DrawColor = GreenColor;
    Canvas.Font = class'Engine'.Static.GetSmallFont();
    Canvas.SetPos(Canvas.ClipX * 0.3, Canvas.ClipY * 0.8);
    Canvas.DrawText(PlayerOwner.Pawn.Velocity);
}

function RestartWorld()
{
    local PlayerController PC;
    PC = GetALocalPlayerController();

    if(PC != none)
    {
        PC.ConsoleCommand("RestartLevel");
    }
}


/**
 * Called when the player owner has died.
 */
function PlayerOwnerDied()
{
    
    Canvas.DrawColor = RedColor;
    Canvas.Font = class'Engine'.Static.GetLargeFont();
    Canvas.SetPos(Canvas.ClipX * 0.1, Canvas.ClipY * 0.5);
    Canvas.DrawText("Too Bad.. :( \nPress BackSpace to Restart");
    
    if(PlayerOwner.Pawn != none)
    {
        PlayerOwner.Pawn.FellOutOfWorld(none);
    }
    // if(!bGameRestarted)
    //     SetTimer(1.5, false, 'RestartWorld');
}


function PlayerOwnerWin()
{
    Canvas.DrawColor = RedColor;
    Canvas.Font = class'Engine'.Static.GetLargeFont();
    Canvas.SetPos(Canvas.ClipX * 0.1, Canvas.ClipY * 0.5);
    Canvas.DrawText("Congratulations! YOU MADE IT!");

    if(PlayerOwner.Pawn != none)
    {
        //PlayerOwner.Pawn.Velocity = vect(0.0,0.0,0.0);
        PlayerOwner.Pawn.GroundSpeed = 0.0f;
        PlayerOwner.Pawn.AirSpeed = 0.0f;
    }

    //play some sounds or images if you like
    AwesomeGame(WorldInfo.Game).BackgroundMusic.Stop();
    AwesomeGame(WorldInfo.Game).YouWin();

}

function DrawShieldCapacity()
{
    local AwesomePlayerCharacter PC;
    PC = AwesomePlayerCharacter(PlayerOwner.Pawn);
    if(PC != none && PC.ShieldCapacity > 0)
    {
        Canvas.DrawColor = WhiteColor;
        Canvas.Font = class'Engine'.Static.GetLargeFont();
        Canvas.SetPos(Canvas.ClipX * 0.8, Canvas.ClipY * 0.3);
        Canvas.DrawText("Shield : " @ PC.ShieldCapacity );    
    }    
}

state GameMenu
{
    event DrawHUD()
    {
        //draw mainmenu image with texture
    }
}

event YouWin()
{
    `log("Default YouWin() called.");
}

event YouLose()
{
    `log("Default YouLose() called.");
}

event YouAreInTrashZone()
{
    `log("Default YouAreInTrashZone() called.");
}

event YouAreInIceZone()
{
    `log("Default YouAreInIceZone() called.");
}

auto state DuringGame
{
    event DrawHUD()
    {
        super.DrawHUD();

        if(PlayerOwner.Pawn != none)
        {
            Canvas.DrawColor = WhiteColor;
            Canvas.Font = class'Engine'.Static.GetLargeFont();
            Canvas.SetPos(Canvas.ClipX * 0.1, Canvas.ClipY * 0.2);
            Canvas.DrawText("WASD to move, SPACE to jump");

            //이거 왜 업데이트가 안돼
            //Canvas.DrawText(AwesomePlayerController(PlayerOwner).speed);
        }

        //CharacterInformation();
        DrawShieldCapacity();
    }

    event YouWin()
    {
        `log("YouWin() called.");
        GotoState('GameOver');        
    }

    event YouLose()
    {
        GotoState('GameOver');
    }
}

state GameOver
{
    event DrawHUD()
    {
        super.DrawHUD();
        
        // TODO : 이거 로직 GameInfo 쪽에 짬때리기
        if (AwesomeKillVolume(AwesomePlayerCharacter(PlayerOwner.Pawn).AssociatedVolume) != none)
        {
            PlayerOwnerDied();
        }
        else if (AwesomeWinVolume(AwesomePlayerCharacter(PlayerOwner.Pawn).AssociatedVolume) != none)
        {
            PlayerOwnerWin();
        }
    }
}

defaultproperties
{
}
