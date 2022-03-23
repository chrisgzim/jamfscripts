#!/bin/bash

#### SCRIPT 1 for Auto Assigning Smart Groups to Classes #######
#
# This script is used to pull classroom information into a CSV. 
#
# The CSV can be populated with which identifying information you would like, but the class id is required. 
#
#
# For now the script is set for "source" but variables like "roster_location" can also be used.
#
# The CSV file will then need to be edited with the smart group ids that are going to be assigned.
# 
# Before moving on to Script 2 you will need to go ahead and put in the smart group ids (sgid) into the CSV file the format
# should be each id followed by a space (i.e. 3 14 35) so the CSV file should look like classid,roster_location,sgid1 sgid2 sgid2 etc. 
# NOTICE NO COMMAS WHEN PUTTING IN THE SMARTGROUP ID. 
#
# Created by Chris Zimmerman on March 23rd, 2022 
#
###############################################################

############## Varibles to edit ########################

username=""
password=""
jurl=""
csvpath="/"

########################################################
####### DO NOT TOUCH BELOW EXCEPT WHEN PROMPTED ################
classicCredentials=$(printf "${username}:${password}" | /usr/bin/iconv -t ISO-8859-1 | /usr/bin/base64 -i - )

# generate an auth token
authToken=$( /usr/bin/curl "${jurl}/uapi/auth/tokens" \
--silent \
--request POST \
--header "Authorization: Basic ${classicCredentials}" )

token=$( /usr/bin/awk -F \" '{ print $4 }' <<< "$authToken" | /usr/bin/xargs )


classids+=($(curl -s "$jurl/JSSResource/classes" -H "accept: application/xml" -X GET -H "Authorization: Bearer $token" | xmllint --format - | awk -F '[<>]' '/<id>/{print $3}'))

for id in ${classids[@]}; do
	#right now just set as "source" for demo customer would use "roster_location"
	idforcsv=$(curl -s "$jurl/JSSResource/classes/id/$id" -H "accept: application/xml" -X GET -H "Authorization: Bearer $token"| xmllint --xpath '/class/id/text()' -)
	locationforcsv=$(curl -s "$jurl/JSSResource/classes/id/$id" -H "accept: application/xml" -X GET -H "Authorization: Bearer $token"| xmllint --xpath '/class/source/text()' -)
	echo "$idforcsv,$locationforcsv"
	
done >> $csvpath

#for demo purposes only

open $csvpath