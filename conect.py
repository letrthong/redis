# pip install redis

import redis

# Connect to the Redis server
r = redis.Redis(host='localhost', port=6379, password='admin' )

# Set a value
r.set('my_key', 'my_value')

# Get the value
value = r.get('my_key')

print(value)  # Output will be: b'my_value'
