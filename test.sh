#!/usr/bin/env sh

echo "========="
echo "VALID DATA"
curl --location 'http://localhost:8080/dump' \
--header 'Content-Type: application/json' \
--data-raw '{"key":"111",
 "email": "d.patterson@northeastern.edu",
 "assignment": "HW1",
 "time": "2024-11-12 17:29:50.628287000 Z",
 "content": "blah blah",
 "results": "{\"blah\": \"blah\"}",
 "other": "{\"meta\": \"blah\"}"
 }'
echo ''
echo "========="

echo "========="
echo "INVALID TIME"
curl --location 'http://localhost:8080/dump' \
--header 'Content-Type: application/json' \
--data-raw '{"key":"111",
 "email": "d.patterson@northeastern.edu",
 "assignment": "HW1",
 "time": "Hello!",
 "content": "blah blah",
 "results": "{\"blah\": \"blah\"}",
 "other": "{\"meta\": \"blah\"}"
 }'
echo ''
echo "========="

echo "========="
echo "INVALID KEY"
curl --location 'http://localhost:8080/dump' \
--header 'Content-Type: application/json' \
--data-raw '{"key":"Invalid",
 "email": "d.patterson@northeastern.edu",
 "assignment": "HW1",
 "time": "2024-11-12 17:29:50.628287000 Z",
 "content": "blah blah",
 "results": "{\"blah\": \"blah\"}",
 "other": "{\"meta\": \"blah\"}"
 }'
echo ''
echo "========="

echo "========="
echo "NO KEY"
curl --location 'http://localhost:8080/dump' \
--header 'Content-Type: application/json' \
--data-raw '{"email": "d.patterson@northeastern.edu",
 "assignment": "HW1",
 "time": "2024-11-12 17:29:50.628287000 Z",
 "content": "blah blah",
 "results": "{\"blah\": \"blah\"}",
 "other": "{\"meta\": \"blah\"}"
 }'
echo ''
echo "========="

echo ''

echo "CLEARING DB"
psql -U metacan metacan -c "DELETE FROM meta"
