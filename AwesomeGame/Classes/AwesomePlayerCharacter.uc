class AwesomePlayerCharacter extends AwesomePawn
        placeable;

    enum E_LandType
    {
        Ty_ICE,
        Ty_WATER,
        Ty_LOSE,
        Ty_WIN
    };

//informations for player character
var E_LandType CurrentLandInformation;

var rotator CurrentRotation;

// 0 : AnimIdle, 1 : AnimWalk, 2 : AnimDead
var AnimNodeSlot IDLE; // AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale' CC_Human_Male_Idle
var AnimNodeSlot Run_Fwd_DPi; // Run_Fwd_DPi
var AnimNodeSlot AnumDeadSlot; // Death_Stinger

//var AnimTreeTemplate Anim;
//var(SkelMesh) SkeletalMeshComponent SK_Bone;

//gets touch() or untouch notifications
var AwesomeVolume AssociatedVolume;

/////////////////NOT USING CURRENTLY///////////////
var SoundCue WalkingSound;
/////////////////NOT USING CURRENTLY///////////////

/////For Missile Collision
var bool bInvulnerable;
var float InvulnerableTime;

/////For Blockings
var bool bBlocked;
var float BlockedTime;

////////for double jump
var bool bCanDoubleJump;
var bool bIsSecondJump;

//collision direction
var vector BumpOffset;

//bool for having item
var bool bHasItem;

//for shield
var int ShieldCapacity;
var ParticleSystemComponent ShieldEffect;

//Check for Game Win
var bool bIsWin;

// for respawn time when died
var float RespawningTime;
var bool bIsDead;

//for NORM-style game
var rotator VolumeRotationOffset;

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	super.PostInitAnimTree(SkelComp);
	if(SkelComp == Mesh)
	{
		//`log("NOTHING WRONG TILL HERE");
		IDLE = AnimNodeSlot(Mesh.FindAnimNode('idle_ready_rif'));

		`log(IDLE);
	}
}

function Animation_Debug()
{
	local AnimNodeSequence TempNodeSequence;

	////////////////HERE////////////////////////////////
	TempNodeSequence = AnimNodeSequence(Mesh.Animations);
	////////////////HERE////////////////////////////////

	if(TempNodeSequence != none)
	{
		`log("Animation_Debug : =========================================|||||||||||||||||||");
		TempNodeSequence.SetAnim('Slither');
		TempNodeSequence.PlayAnim();
	}
	else
	{
		`log("Animation_Debug : |||||||||||||||||||||||||||||||||||||||||===================");
	}
}

function Bite()
{
	local AnimNodeSequence BiteNode;
	local int i;
	local array<AnimNode> temp;

	if(Mesh.FindAnimNode('Bite') == none)
	{
		`log("ANIM IDLE NOT READY.===========");
	}
	
	// for(i = 0; i < Mesh.AnimSets.Length;i++)
	// {
	// 	`log("===== FOUND : " @ Mesh.AnimSets[i].Name);
	// }
	// for(i = 0; i < Mesh.AnimSets.Length;i++)
	// {

	// }
	// Mesh.Animsets.GetNode()

	BiteNode = AnimNodeSequence(Mesh.Animations);
	
	BiteNode.StopAnim();
	BiteNode.SetAnim('Bite');
	
	//`log("=========name : " @ BiteNode.GetAnim() );
	//`log("=========name : " @ BiteNode.GetAnimNodeSequence().AnimSeqName);;
	//BiteNode.GetNodes();

		
	//Mesh.Animsets.GetNodes(temp);

	for(i = 0; i < Mesh.AnimTickArray.Length; ++i)
	{
		`log("===== FOUND : " @  Mesh.AnimTickArray[i].Name);
	}

	BiteNode.PlayAnim(true);
}


function PostBeginPlay()
{
	local AnimNodeSequence PawnNode;
	//local AnimNode TempNode;
	//local int i;

	// `log("============TEST PAWN");
	// `log("============TEST PAWN" @ Mesh.Animations);
	// `log("===== ===== ===== Animations : " @ Mesh.AnimTreeTemplate);

	Mesh.SetAnimTreeTemplate(Mesh.AnimTreeTemplate);

	// `log("============TEST PAWN" @ Mesh.Animations);
	// `log("===== ===== ===== Animations : " @ Mesh.AnimTreeTemplate);

	PawnNode = AnimNodeSequence(Mesh.Animations);
	
	// if(Mesh.FindAnimSequence('Bite') != none)
	// {
	// 	`log("=FOUND==FOUND=FOUND= FOUND");
	// }
	
	// if(Mesh.FindAnimSequence('Manta_Idle_Sitting') != none)
	// {
	// 	`log("=FOUND==FOUND=FOUND= FOUND");
	// }

	// `log("=========================NUM : " @ Mesh.AnimSets.Length);

	
	// for(i = 0; i < Mesh.AnimSets.Length;i++)
	// {
	// 	`log("===== FOUND : " @ Mesh.AnimSets[i].Name);
	// }
	
	Mesh.UpdateAnimations();

	//`log("=========================NUM : " @ Mesh.AnimSets.Length);
	
	
		//PawnNode.StopAnim();
	
	
	
	//PawnNode.SetAnim('Bite');
	//Mesh.Animations.PlayAnim(true, 1.0f);
	//PawnNode.PlayAnim(true);


	// AnimIdle = AnimNodeSequence(Mesh.FindAnimNode('idle_ready_rif'));
	// if(AnimIdle == none)
	// {
	// 	`log("ANIM IDLE NOT READY.");
	// }
	// else
	// {
	// 	AnimIdle.SetAnim();
	// }
	// `log("========I AM PlayerCharacter==========");

	/*
	if(SkelMesh->Animations.Num() > 0)
	{
	
		`log("========I AM PlayerCharacter==========");
	}
	*/

	`log("===== Post Begin Play ===== ===== Animations : " @ Mesh.AnimTreeTemplate);

	//Bite();
	ShieldEffect.SetHidden(true);
}

//get touched by volume
event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	if(AwesomeVolume(Other)!=none)
	{
		AssociatedVolume = AwesomeVolume(Other);
		//`log("Entering Volume at condition "@CurrentLandInformation);
		//self.LandInformation = Other.m_Type;
		
		// can handle somethings
		if(CurrentLandInformation == Ty_WIN)//Ty_WIN
		{
			bIsWin = true;
			//disable input
			//play 'you win' screen
		}else if(CurrentLandInformation == Ty_LOSE)//Ty_Lose
		{
			bIsWin = false;
		}
		else if (AwesomeKillVolume(Other) != none)
		{
			`log(self @ "Touch no problem.");
			bIsWin = false;
		}
		else //if(CurrentLandInformation == Ty_WATER)// TY_SLOW 1 / FAST 0
		{
			`log("Character : at " @ CurrentLandInformation);
		}
	}
	else
	{	
		if(AwesomeParticleShield(Other) != none && AwesomeParticleShield(Other).bCanAccess)
		{
			`log(ShieldCapacity);
			ShieldCapacity = 3;
			`log(ShieldCapacity);
			ShieldEffect.SetHidden(false);
		}
	}
}

//get touched by volume
event untouch( Actor Other )
{
	if(AwesomeVolume(Other)!=none)
	{
		if(AssociatedVolume != none)
		{
			AssociatedVolume = none;
			//`log(self @ "I AM OUT");
		}
	}

}

//Player Character is Hit by something : update BumpOffset
event Bump(Actor Other, PrimitiveComponent OtherComp, vector HitNormal)
{
	//Animation_Debug();

    if(AwesomeMissile(Other) != none && !bInvulnerable)
    {
		if(ShieldCapacity > 0)
		{
			ShieldCapacity--;
			if(ShieldCapacity == 0)
			{
				ShieldEffect.SetHidden(true);
			}
		}
		else
		{
			bHasItem=false;
			bInvulnerable = true;
			SetTimer(InvulnerableTime, false, 'EndInvulnerable');

			//play hit animation
			//PlayAnimation(		);
			
			`log("PlayerCharacter Hit by Missile.");

			BumpOffset = HitNormal;
		}
    }

	else if(AwesomeBlocking(Other) != none && !bBlocked)
	{
		bBlocked = true;
		SetTimer(BlockedTime, false, 'EndBlock');
		`log("PlayerCharacter : Blocking Hits PlayerCharacter.");
		BumpOffset = self.Velocity;
	}
}

function EndInvulnerable()
{
	bInvulnerable=false;
}

function EndBlock()
{
	bBlocked=false;
}

/*
event TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
        Destroy();
}
defaultproperties
{
        Begin Object Class=SpriteComponent Name=Sprite
                Sprite=Texture2D'EditorResources.S_NavP'
        HiddenGame=True
        End Object
        Components.Add(Sprite)

        Begin Object Class=SkeletalMeshComponent Name=AwesomePlayerCharacterSkelMeshComponent
                bCacheAnimSequenceNodes=FALSE
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true
		bOwnerNoSee=true
		CastShadow=true
		BlockRigidBody=TRUE
		bUpdateSkelWhenNotRendered=false
		bIgnoreControllersWhenNotRendered=TRUE
		bUpdateKinematicBonesFromAnimation=true
		bCastDynamicShadow=true
		Translation=(Z=8.0)
		RBChannel=RBCC_Untitled3
		RBCollideWithChannels=(Untitled3=true)
		//LightEnvironment=MyLightEnvironment
		bOverrideAttachmentOwnerVisibility=true
		bAcceptsDynamicDecals=FALSE
		AnimTreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
		bHasPhysicsAssetInstance=true
		TickGroup=TG_PreAsyncWork
		MinDistFactorForKinematicUpdate=0.2
		bChartDistanceFactor=true
		//bSkipAllUpdateWhenPhysicsAsleep=TRUE
		RBDominanceGroup=20
		Scale=1.075
		// Nice lighting for hair
		bUseOnePassLightingOnTranslucency=TRUE
		bPerBoneMotionBlur=true
        End Object
        Mesh=AwesomePlayerCharacterSkelMeshComponent

        Begin Object Class=CylinderComponent Name=CollisionCylinder
		CollisionRadius=+0034.000000
		CollisionHeight=+0078.000000
		BlockNonZeroExtent=true
		BlockZeroExtent=true
		BlockActors=true
		CollideActors=true
	End Object
	CollisionComponent=CollisionCylinder
	CylinderComponent=CollisionCylinder
	Components.Add(CollisionCylinder)
}
        
*/

simulated function PlayAnimation( Name Sequence, float fDesiredDuration, optional bool bLoop, optional SkeletalMeshComponent SkelMesh)
{
	local AnimNodeSequence CharacterAnimNode;
	local AnimTree Tree;

	// Check we have access to mesh and animations
	if( SkelMesh == None )
	{
		return;
	}

	if(fDesiredDuration > 0.0)
	{
		// @todo - this should call GetWeaponAnimNodeSeq, move 'duration' code into AnimNodeSequence and use that.
		SkelMesh.PlayAnim(Sequence, fDesiredDuration, bLoop);
	}
	else
	{
		//Try getting an animtree first
		Tree = AnimTree(SkelMesh.Animations);
		if (Tree != None)
		{
			CharacterAnimNode = AnimNodeSequence(Tree.Children[0].Anim);
		}
		else
		{
			CharacterAnimNode = AnimNodeSequence(SkelMesh.Animations);
		}

		CharacterAnimNode.SetAnim(Sequence);
		CharacterAnimNode.PlayAnim(bLoop, 1.0);
	}
}

//Player Jumped
function bool DoJump( bool bUpdating )
{
	local bool bReturn;
	bReturn = super.DoJump(bUpdating);
	if(bReturn)
	{
		Velocity.Z += 300.f;
	}
	
	return bReturn;
}

simulated event FellOutOfWorld(class<DamageType> dmgType)
{
	if ( Role == ROLE_Authority )
	{
		//Health = -1;
		//Died( None, dmgType, Location );
		if ( dmgType == None )
		{
			SetPhysics(PHYS_None);
			SetHidden(True);
			LifeSpan = FMin(LifeSpan, 1.0);
		}
	}
	AwesomeGame(WorldInfo.Game).GameOver();
	//AwesomeGame(WorldInfo.Game).Reset();
	
}

defaultproperties
{
	RespawningTime=1.5

	bInvulnerable=false
	InvulnerableTime=0.75

	bBlocked=false
	BlockedTime=2.0

	bCanDoubleJump=false
	bIsSecondJump=false

	bHasItem=false
	ShieldCapacity=0

	WalkingSound=SoundCue'MyPackage.A_Sound_Footstep'

	bIsWin=false
	bIsDead=false

	Begin Object Class=SkeletalMeshComponent Name=AwesomePlayerCharacterSkelMeshComponent
		SkeletalMesh=SkeletalMesh'CH_LIAM_Cathode.Mesh.SK_CH_LIAM_Cathode'
		AnimTreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
		AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
		Scale=2.075
	End Object
	Mesh=AwesomePlayerCharacterSkelMeshComponent
	Components.Add(AwesomePlayerCharacterSkelMeshComponent);

	Begin Object Class=StaticMeshComponent Name=AwesomeCharacterStaticMeshComponent
		StaticMesh=StaticMesh'HU_Deco_Statues.SM.Mesh.S_HU_Deco_Statues_SM_Statue03_02'
	End Object

	Begin Object Class=ParticleSystemComponent Name=ShieldParticleSystemComponent
        Template=ParticleSystem'Pickups.Health_Large.Effects.P_Pickups_Base_Health_Glow'
        bAutoActivate=true
        Scale=5.0f
    End Object
    ShieldEffect=ShieldParticleSystemComponent
    Components.add(ShieldParticleSystemComponent)
}

//AnimSet'KismetGame_Assets.Anims.SK_Snake_Anims'

//AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
//SkeletalMesh'KismetGame_Assets.Anims.SK_Snake'
//	SkeletalMesh=SkeletalMesh'KismetGame_Assets.Anims.SK_Snake'
//	AnimTreeTemplate=AnimTree'KismetGame_Assets.Anims.Snake_AnimTree'
//	AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
//	SkeletalMesh'CH_IronGuard_Male.Mesh.SK_CH_IronGuard_MaleA'
//	SkeletalMesh'CH_LIAM_Cathode.Mesh.SK_CH_LIAM_Cathode'
//Bite
//AnimTree'UTExampleCrowd.AnimTree.AT_CH_Crowd'


//static mesh
//StaticMesh'HU_Deco_Statues.SM.Mesh.S_HU_Deco_Statues_SM_Statue03_02'