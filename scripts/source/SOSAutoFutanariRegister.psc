Scriptname SOSAutoFutanariRegister extends Quest  

SexLabFramework Property SexLab Auto
Armor Property SOSAutoFutanariStrapCover  Auto  
Actor Property TargetActor  Auto  
Faction Property SOSAFTypeFaction  Auto  
Faction Property SOSAFSizeFaction  Auto  
SPELL Property SOSAFPower  Auto  

Quest SOS
SOS_SetupQuest_Script SOS_Quest

Event OnInit()
	RegisterForModEvent("HookStageStart", "SOSAFResolveStrapOn")
	RegisterForModEvent("HookAnimationChange", "SOSAFResolveStrapOn")
	RegisterForModEvent("HookPositionChange", "SOSAFResolveStrapOn")
	RegisterForModEvent("HookAnimationEnd", "SOSAFAnimationEnd")
	
	SOS = Game.GetFormFromFile(0xD62,"Schlongs of Skyrim.esp") as Quest
	SOS_Quest = (SOS as SOS_SetupQuest_Script)
	
	Actor player = Game.GetPlayer()
	if !(player.HasSpell(SOSAFPower))
		player.AddSpell(SOSAFPower)
	endif
EndEvent

Event SOSAFResolveStrapOn(int tid, bool hasPlayer)
	sslThreadController controller = SexLab.GetController(tid)
	int x = controller.Positions.length
	
	while (x > 0)
		x -= 1
		self.resolveStrapOn(controller.Positions[x], x, controller)
	endwhile
EndEvent

Event SOSAFAnimationEnd(int tid, bool hasPlayer)
	sslThreadController controller = SexLab.GetController(tid)
	int x = controller.Positions.length
	
	while (x > 0)
		x -= 1
		self.equipCover(controller.Positions[x])
	endwhile
EndEvent

Function resolveStrapOn(Actor act, int position, sslThreadController controller)
	if !(act)
		return
	elseif (act.IsInFaction(SOSAFTypeFaction))
		sslBaseAnimation anim = controller.Animation
		if (anim.MalePosition(position))
			if !(SOS_Quest.GetActiveAddon(act))
				int sosbend = anim.GetSchlong(controller.AdjustKey, position, controller.Stage)
				self.addSOS(act, sosbend)
			endif
		else
			self.removeSOS(act)
		endif
	endif
EndFunction

Function equipCover(Actor act)
	if !(act)
		return
	elseif (act.IsInFaction(SOSAFTypeFaction))
		self.removeSOS(act)
	endif
EndFunction

Function addSOS(Actor act, int sosbend)
	int sostype = act.GetFactionRank(SOSAFTypeFaction)
	int sossize = act.GetFactionRank(SOSAFSizeFaction)
		
	Form newAddon = SOS_Data.GetAddon(sostype)
	SOS_Quest.SetSchlong(act, newAddon, true)
	SOS_Quest.SetSchlongSize(newaddon, act, sossize)
	Utility.Wait(0.5)
	act.QueueNiNodeUpdate()
	Utility.Wait(0.5)
	; debug.trace("[SOSAF]: " + sosbend)
	debug.SendAnimationEvent(act, "SOSBend"+sosbend)
EndFunction

Function removeSOS(Actor act)
	Form oldAddon = SOS_Quest.GetActiveAddon(act)
	if (oldAddon)
		SOS_Quest.RemoveSchlongFromActor(oldAddon, act)
		act.QueueNiNodeUpdate()
	endif
EndFunction

Function ToggleAF() ; from Magic Effect
	Actor act
	if (TargetActor)
		act = TargetActor
	else
		act = Game.GetPlayer()
	endif
	
	Form activeAddon = SOS_Quest.GetActiveAddon(act)
	if (activeAddon)
		int sostype = SOS_Data.FindAddon(activeAddon)
		Faction SchlongFaction = SOS_Data.GetFaction(activeaddon)
		int sossize = act.GetFactionRank(SchlongFaction) as int
		
		act.SetFactionRank(SOSAFTypeFaction, sostype)
		act.SetFactionRank(SOSAFSizeFaction, sossize)
		self.removeSOS(act)
		
		if (SexLab.GetGender(act) == 1); female
			act.EquipItem(SOSAutoFutanariStrapCover)
		endif
	elseif (act.IsInFaction(SOSAFTypeFaction))
		self.addSOS(act, 0)
		act.RemoveFromFaction(SOSAFTypeFaction)
		act.RemoveFromFaction(SOSAFSizeFaction)
		
		if (SexLab.GetGender(act) == 1); female
			act.RemoveItem(SOSAutoFutanariStrapCover, 1)
		endif
	endif
EndFunction
