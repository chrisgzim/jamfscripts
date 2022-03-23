#!/bin/bash

#### Script 2 for Auto Assigning Smart Groups to Classes #######
#
# This script takes place after Script 1 -- See Script 1 for Auto Assigning Smart Groups to Classes
#
################### IMPORTANT PLEASE READ ########################################
# Before moving on to Step 2 you will need to go ahead and put in the smart group ids (sgid) into the CSV file the format
# should be each id followed by a space (i.e. 3 14 35) so the CSV file should look like classid,roster_location,sgid1 sgid2 sgid2 etc. 
# NOTICE NO COMMAS WHEN PUTTING IN THE SMARTGROUP ID. 
######### END IMPORTANT PLEASE READ BEFORE ######################################
###################### SCRIPT DETAILS ###########################################
# This script reads your csv file from Step 1 that was edited in step 2. It will then create an API command to assign the smart groups you have listed in your CSV. 
#
# This script will run through your entire CSV file updating all information that is present. 
#
# Note: the following command can only UPDATE and NOT ADD to your exisiting smart groups. It is recommended that unless you want to remove a smart group from scope, please leave it there. 
# Example: if class ID has smart groups 1 2 3 already assigned to it, but you replace 1 2 3 with 4, the only smart group assigned to that class now is 4 as 1 2 3 were not in the new command that was listed. If you want to ADD 4, you need to have the smartgroups 1 2 3 4 in your CSV file. 
# 
#
# 
# Created by Chris Zimmerman on March 23rd, 2022 
#
###############################################################
###################### BEGIN VARIABLES ########################
username="chris.zimmerman"
password="moxnug-Zezvo1-dubciz"
jurl="https://chrisjamfpro.jamfcloud.com"
csvpath="/Users/chris.zimmerman/Desktop/livedemo.csv"

classicCredentials=$(printf "${username}:${password}" | /usr/bin/iconv -t ISO-8859-1 | /usr/bin/base64 -i - )

# generate an auth token
authToken=$( /usr/bin/curl "${jurl}/uapi/auth/tokens" \
--silent \
--request POST \
--header "Authorization: Basic ${classicCredentials}" )

token=$( /usr/bin/awk -F \" '{ print $4 }' <<< "$authToken" | /usr/bin/xargs )

while IFS="," read -r classid rec_column2 rec_remaining
do
	sgid=($(for test in $rec_remaining; do
	printf "<id>$test</id>"
done
))
	curl -s "$jurl/JSSResource/classes/id/$classid" -H  "Authorization: Bearer $token" -H "content-type: text/xml" -X PUT -d "<class><mobile_device_group_ids>$sgid</mobile_device_group_ids></class>"
done < $csvpath

