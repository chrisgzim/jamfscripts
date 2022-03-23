# jamfscripts
Some Scripts I made For Jamf Users


This is just a collection of scripts that I made for Jamf. Feel free to give any feedback. I am sure there are better ways to do things, but I am just here to learn and to be better! 

## Recovery Lock (M1 Compatibility Only) 

This script does use Python in order to work. As it parses information from a JSON file and dumps it to a CSV. 

This is a script I made to try a couple of new things. The goal is to leverage the API to pull the serial number and management id from the inventory record of all computers. 

The information is set up as a CSV document that will go ahead and search by serials to find the corresponding management id. You can also pull a smart group by entering the Smart Group Id. All of the serial numbers from that group will automatically be searched for in the CSV document and then will put whatever recovery lock password you would like for that group of machines. 

Currently the Recovery Lock API call does not have a way to set randomized passwords (this can only be done through pre-stage enrollment. 


## Auto Assign Groups 

This script was created for the ability to add smart groups to mobile device groups in Classes. The two scripts work together to help "automate" the experience. There is user interaction involved to make it work. But this way groups don't need to be searched for and be assigned in one place.

### Part 1 

This part is merely used to create a CSV of all class ids alongside any other information you choose. (For the demo, I used "source" but you can use just about anything in the class/id search.) 

You can customize some things in this script to get your CSV to pull the information you need it to. 

The idea is you print a CSV file that can be edited with the correct smart groups in every class. 

Once the CSV is printed you should get a document that looks like this: 
```
classid,roster_location 
classid,roster_location
classid,roster_location
classid,roster_location
```
To get the CSV prepped for the second script you will need to have it look something like this:
```
classid,roster_location,12 25 13 2 
classid,roster_location,19 30 10 29
classid,roster_location,17 23 26 24
classid,roster_location,20 29 13 6
```
Where the integers are the smart group ids found in the Jamf Pro URL. PLEASE NOTE, these ids are separated by a space, if you do not have these ids separated by a space then the next script will fail. Also note, you can use the same smart group for multiple classes. 

### Part 2 

This is where the magic happens! If you properly fomatted your csv this will run the command to assign the smart groups that you want in each class! There are some notes in the script that you should know:

Note: the following command can only UPDATE and NOT ADD to your exisiting smart groups. It is recommended that unless you want to remove a smart group from scope, please leave it there. 

Example: if class ID has smart groups 1 2 3 already assigned to it, but you replace "1 2 3" with only "4", the only smart group assigned to that class now is 4 as 1 2 3 were not in the new command that was listed. If you want to ADD 4, you need to have the smartgroups "1 2 3 4" in your CSV file. 

This script will run for ALL Entries in your CSV file. So if you don't want to do every class, you will need to create a new CSV document for this part. 

### Potentials for upgrades in the future

- Create a Script that allows admins to set a range for class ids to run the command on. (So the CSV doesn't need to be edited) 
- Find a workflow that allows for this whole script to be automated (would involve naming conventions and the sort) 
- Just have a prompt for the class and allow for a one at a time approach to avoid having to edit a CSV document. 
