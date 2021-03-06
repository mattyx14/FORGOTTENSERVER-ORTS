local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
 
function onCreatureAppear(cid)
	npcHandler:onCreatureAppear(cid)			
end
function onCreatureDisappear(cid)
	npcHandler:onCreatureDisappear(cid)			
end
function onCreatureSay(cid, type, msg)
	npcHandler:onCreatureSay(cid, type, msg)		
end
function onThink()
	npcHandler:onThink()					
end

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end
	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
 
	if(msgcontains(msg, "trouble") and getPlayerStorageValue(cid, 201) < 1) then
		npcHandler:say("I think there is a pickpocket in town.", cid)
		talkState[talkUser] = 1
	elseif(msgcontains(msg, "authorities")) then
		if(talkState[talkUser] == 1) then
			npcHandler:say("Well, sooner or later we will get hold of that delinquent. That's for sure.", cid)
			talkState[talkUser] = 2
		end
	elseif(msgcontains(msg, "avoided")) then
		if(talkState[talkUser] == 2) then
			npcHandler:say("You can't tell by a person's appearance who is a pickpocket and who isn't. You simply can't close the city gates for everyone.", cid)
			talkState[talkUser] = 3
		end
	elseif(msgcontains(msg, "gods would allow")) then
		if(talkState[talkUser] == 3) then
			npcHandler:say("If the gods had created the world a paradise, no one had to steal at all.", cid)
			talkState[talkUser] = 0
			if(getPlayerStorageValue(cid, 201) < 1) then
				setPlayerStorageValue(cid, 201, 1)
				doSendMagicEffect(getCreaturePosition(cid), CONST_ME_HOLYAREA)
			end
		end
	end
	return true
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())