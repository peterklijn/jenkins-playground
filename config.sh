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

echo "\n\n-------------------\n\n"
while true; do
  sleep 1
done

