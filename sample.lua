KEYS={'hello'}
ARGV={'world'}

redis.call('set', KEYS[1], ARGV[1])
local result = redis.call("get", KEYS[1])
print(result)
