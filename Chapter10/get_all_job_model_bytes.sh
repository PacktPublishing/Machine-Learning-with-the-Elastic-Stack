#!/bin/bash
HOST='localhost'
PORT=9200
#CURL_AUTH="-u elastic:changeme"
list=`curl $CURL_AUTH -s http://$HOST:$PORT/_xpack/ml/anomaly_detectors?pretty | awk -F" : " '/job_id/{print $2}' | sed 's/\",//g' | sed 's/\"//g'` 
while read -r JOB_ID; do
   curl $CURL_AUTH -s -XPOST $HOST:$PORT/_xpack/ml/anomaly_detectors/${JOB_ID}/model_snapshots?pretty |  jq '{job_id: .model_snapshots[0].job_id, size: .model_snapshots[0].model_size_stats.model_bytes}' | jq --raw-output '"\(.job_id),\(.size)"'
done <<< "$list"
