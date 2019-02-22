Scriptname SOSAutoFutanariEffect extends activemagiceffect  

Quest Property SOSAFQuest  Auto  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	(SOSAFQuest as SOSAutoFutanariRegister).ToggleAF()
EndEvent