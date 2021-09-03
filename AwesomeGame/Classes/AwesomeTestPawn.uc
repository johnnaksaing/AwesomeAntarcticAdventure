class AwesomeTestPawn extends UTPawn
        placeable;

simulated event PostBeginPlay()
{
	local AnimNodeSequence PawnNode;
	local AnimNode TempNode;
	local int i;

    super.PostBeginPlay();



	`log("============TEST PAWN");
	`log("============TEST PAWN" @ Mesh.Animations);
	`log("===== ===== ===== Animations : " @ Mesh.AnimTreeTemplate);

	Mesh.SetAnimTreeTemplate(Mesh.AnimTreeTemplate);

	`log("============TEST PAWN" @ Mesh.Animations);
	`log("===== ===== ===== Animations : " @ Mesh.AnimTreeTemplate);

	PawnNode = AnimNodeSequence(Mesh.Animations);
	
	if(Mesh.FindAnimSequence('crouch_idle_ready_rif') != none)
	{
			`log("=FOUND==FOUND=FOUND= FOUND");

	}

	`log("=========================NUM : " @ Mesh.AnimSets.Length);

	
	/**for(i = 0; i < Mesh.AnimSets.Num();i++)
	{
			`log("===== FOUND : " @ Mesh.AnimSets(i).GetName());
	} */
	
	Mesh.UpdateAnimations();

	`log("=========================NUM : " @ Mesh.AnimSets.Length);

	PawnNode.SetAnim('crouch_idle_ready_rif');
	//Mesh.Animations.PlayAnim(true, 1.0f);
	PawnNode.PlayAnim(true, 1.0f);

	for(i=0; i < Mesh.AnimTickArray.Length; i++)
	{
			TempNode = Mesh.AnimTickArray[i];
			`log("=== Node Name: "@TempNode.NodeName);
	}

        SetWeaponVisibility(true);
}

defaultproperties
{

}