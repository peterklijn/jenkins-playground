sh -c /usr/local/bin/jenkins.sh &

wait_for () {
  URL=$1
  while true; do
    echo "Waiting for: $URL ..."
    curl -s "$URL" > /dev/null
    if [ "$?" -eq "0" ]; then
      break
    fi
    sleep 1
  done
}

wait_for "http://localhost:8080/cli/"

WOKRSPACE_PATH="/var/jenkins_home/jobs/seed/workspace/"

OLD_VALUE=""

while true; do

  NEW_VALUE=`(ls -lFR $WOKRSPACE_PATH | grep -E '.*[^/:]$' | grep -v -E 'total \d+' | awk '{print $6 $7 $8 $9}' | tr '\n' '-')`

  if [ "${OLD_VALUE}" != "${NEW_VALUE}" ]; then
    curl -s -X POST localhost:8080/job/seed/build --user admin:admin > /dev/null
    OLD_VALUE=$NEW_VALUE
    echo "\nRan seed at " `date`
  fi

  sleep 1

done

