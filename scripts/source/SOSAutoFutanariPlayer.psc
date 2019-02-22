Scriptname SOSAutoFutanariPlayer extends ReferenceAlias  

Quest Property SelfQuest  Auto  

Event OnInit()
	RegisterForCrosshairRef()
	SelfQuest = self.GetOwningQuest()
EndEvent

Event OnCrosshairRefChange(ObjectReference ref)
	if (SelfQuest.IsRunning())
		; debug.trace("[SOSAF] Crosshair had " + ref + " targeted.")
		if (ref)
			Actor act = ref as Actor
			if (act)
				; debug.trace("[SOSAF] Crosshair had " + act + " targeted.")
				(SelfQuest as SOSAutoFutanariRegister).TargetActor = act
			endif
		else
			(SelfQuest as SOSAutoFutanariRegister).TargetActor = none
		endif
	endif
EndEvent

