#!/bin/bash

set -eu

MONGO_ROOT_USERNAME=$(cat $MONGO_ROOT_USERNAME_FILE)
MONGO_ROOT_PASSWORD=$(cat $MONGO_ROOT_PASSWORD_FILE)
MONGO_APP_USERNAME=$(cat $MONGO_APP_USERNAME_FILE)
MONGO_APP_PASSWORD=$(cat $MONGO_APP_PASSWORD_FILE)

echo "Initiating replicaset..."

mongo --host mongo:27017 -u $MONGO_ROOT_USERNAME -p $MONGO_ROOT_PASSWORD << EOF
rs.initiate({ "_id": "rs0", "members": [{ "_id": 0, "host": "mongo:27017" }] });
EOF

echo "Creating non-admin user..."

mongo --host mongo:27017 -u $MONGO_ROOT_USERNAME -p $MONGO_ROOT_PASSWORD << EOF
var startTime = Date.now()

while (!db.isMaster().ismaster) {
  if (Date.now() - startTime > 30000) {
    quit(1)
  }

  sleep(3)
}

use $MONGO_APP_DATABASE
db.createUser({ "user": "$MONGO_APP_USERNAME", "pwd": "$MONGO_APP_PASSWORD", "roles": ["readWrite"] })
EOF