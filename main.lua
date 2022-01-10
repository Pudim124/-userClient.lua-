local modem = peripheral.find("modem") or error("No modem attached", 0)

local function has(item,array) 
	local i
	for i=1,#array,1 do
		if array[i]==item then
			return (true)
		end
	end
	return (false)
end

function send(recieving_port,signature,message)
	modem.transmit(recieving_port,0,tostring(signature)..tostring(message))
end

function listen(my_port,my_signature)
	if type(my_signature)=="string" then
		if not modem.isOpen(my_port) then
			modem.open(tonumber(my_port))
		end
		local event, side, channel, replyChannel, message, distance, tempCon
		repeat
			event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
			tempCon=message:sub(1,#my_signature)
			if tempCon==nil then
				tempCon=false
			else
				tempCon=tempCon==my_signature
			end
		until channel == my_port and tempCon
		modem.close(tonumber(my_port))
		return message:sub(#mysignature+1,#message)
	else
		if not modem.isOpen(my_port) then
			modem.open(tonumber(my_port))
		end
		local event, side, channel, replyChannel, message, distance, tempCon
		repeat
			event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
			tempCon=message:sub(1,#my_signature)
			if tempCon==nil then
				tempCon=false
			else
				tempCon=has(tempCon,my_signature)
			end
		until channel == my_port and tempCon
		modem.close(tonumber(my_port))
		return message:sub(#mysignature+1,#message),message:sub(1,#my_signature)
	end
end

local function strHas(Hstr,Hitem)
	success,result=pcall(strMatch,Hstr,Hitem)
	if success then 
		result=result==Hitem
	else
		result=false
	end
	return (result)
end

local function intExt(Estr)
	EIntTemp=0
	for Ei=1,#Estr,1 do
		Etemp=tonumber(Estr:sub(Ei,Ei))
		if Etemp~=nil then
			EIntTemp=(EIntTemp*10)+Etemp
		end
	end
	return (EIntTemp)
end

SIGNATURE="PUDIM124:TURTLENETWORK"
shell.run("clear")
print("User client started\n")
USER_PORT=999
SERVER_PORT=1000
while true do
	input=io.read()
	if input=="clear" or input=="cls" then
		shell.run("clear")
	else if input=="r" then
		shell.run("reboot")
	else if input=="reboot" then
		send(SERVER_PORT, SIGNATURE, "USER:"..input)
		message=listen(USER_PORT,SIGNATURE)
		print (message)	
		message=listen(USER_PORT,SIGNATURE)
		print (message)			
		message=listen(USER_PORT,SIGNATURE)
		print (message)	
		message=listen(USER_PORT,SIGNATURE)
		print (message)	
	else
		send(SERVER_PORT, SIGNATURE, "USER:"..input)
		message=listen(USER_PORT,SIGNATURE)
		print (message)
	end
	end
	end
end
