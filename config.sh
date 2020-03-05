if [ -n "$ADDITIONAL_PLUGINS" ]; then
  echo "Additional plugins requested: $ADDITIONAL_PLUGINS"
  /usr/local/bin/install-plugins.sh $ADDITIONAL_PLUGINS
else
  echo "No additional plugins specified.."
fi

sh -c /usr/local/bin/jenkins.sh &

JENKINS_STARTING_TEXT="Please wait while Jenkins is getting ready to work"

while true; do
  echo "Waiting for Jenkins to respond..."
  curl -s "http://localhost:8080/cli/" > /dev/null
  if [ "$?" -eq "0" ]; then
    break
  fi
  sleep 1
done

while true; do
  echo "Waiting for Jenkins to be fully up and running..."
  curl -s "http://localhost:8080/cli/" | grep "${JENKINS_STARTING_TEXT}" > /dev/null
  if [ "$?" -ne "0" ]; then
    break
  fi
  sleep 1
done

if [ -d ${SEED_JOB_WORKSPACE_DIR} ]; then
  echo "Folder ${SEED_JOB_WORKSPACE_DIR} seems to exist, the folder contains:"
  ls -la $SEED_JOB_WORKSPACE_DIR
else
  echo "Folder ${SEED_JOB_WORKSPACE_DIR} doesn't exist, let's create it.."
  mkdir -p ${SEED_JOB_WORKSPACE_DIR}
fi

# Check if seed workspace is empty
LINES_OF_FILES_IN_SEED_WORKSPACE=`ls -A ${SEED_JOB_WORKSPACE_DIR} | wc -w | awk {'print $1'}`
echo "Number of files in workspace: ${LINES_OF_FILES_IN_SEED_WORKSPACE}"
# Copy all demo files if workspace is empty
if [ "${LINES_OF_FILES_IN_SEED_WORKSPACE}" -eq "0" ]; then
  echo "Copying demo files to workspace dir..."
  cp -r ${DEMO_JOB_DIR}* ${SEED_JOB_WORKSPACE_DIR}
fi


# Check for file changes every second:
OLD_VALUE=""
while true; do

  NEW_VALUE=`(ls -lFR ${SEED_JOB_WORKSPACE_DIR} | grep -E '.*[^/:]$' | grep -v -E 'total \d+' | awk '{print $6 $7 $8 $9}' | tr '\n' '-')`

  if [ "${OLD_VALUE}" != "${NEW_VALUE}" ]; then
    curl -s -X POST localhost:8080/job/seed/build --user admin:admin > /dev/null
    OLD_VALUE=$NEW_VALUE
    echo "\nRan seed at " `date`
  fi

  sleep 1

done
