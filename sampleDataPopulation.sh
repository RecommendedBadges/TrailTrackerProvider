#! /bin/bash
while getopts o: flag
do
    case "${flag}" in
        o) targetorg=${OPTARG};;
    esac
done

targetorg=${targetorg:-$(sf config get target-org --json | jq -r '.result[0].value')}

sf org assign permset -n trailheadapp__Th_Badge_Admin
sf data upsert bulk -s trailheadapp__Trail__c -f ./test-data/trails.csv -i trailheadapp__External_Id__c -w 10
sf data upsert bulk -s trailheadapp__Badge__c -f ./test-data/badges.csv -i trailheadapp__External_Id__c -w 10