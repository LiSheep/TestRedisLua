#! /usr/bin/lua

local socket = require "socket"
redis = require 'redis'

local dump = function(v) 
    if nil ~= v then
	print("==============return=================")
	print(v)
	print("=====================================\n")
    else
	print("done with non return")
    end
end

local host = "127.0.0.1"
local port = 6379

redis.call = function(cmd, ...) 
    return assert(loadstring('return client:'.. string.lower(cmd) ..'(...)'))(...)
end

local script_file = ""
local redis_str = ""

local f = function ()
	print("executing script...")
	print("=============output==================")
	dofile(script_file)
	print("=====================================\n")
end

local usage = function()
	print("\nusage")
	print("redis-lua [options]")
	print("\t-f <test-scipt>    the file to be executed.")
	print("\t-r <redis_ip:port> the redis host and port(default:127.0.0.1:6379)")
end

local execute = true

while execute do
execute = false
for i=0,#arg,1 do
	if arg[i] == '-f' then
		i = i + 1
		script_file = arg[i]
	end
	if arg[i] == '-r' then
		i = i + 1
		redis_str = arg[i]	
	end
end

if redis_str ~= "" then
	local fi = string.find(redis_str, ':')
	if(fi == nil) then
		print("\nerror formated host:port", redis_str)
		usage()
		break	
	else
		host = string.sub(redis_str,0, fi-1)
		port = string.sub(redis_str, fi+1)
	end
end

print("connect to "..host..":"..port)
client = redis.connect(host, port)

if script_file == "" then
	usage()
	break
elseif not client:ping() then
	print("client " .. host..":"..port.." unreachable")
	usage()
	break
else
	local t0 = socket.gettime()
	dump(f())
	local t1 = socket.gettime()
	print("used time: "..t1-t0.."s")
end

end

