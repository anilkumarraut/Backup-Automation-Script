#!/bin/bash

# Check if the correct number of arguments is provided (2 arguments required)
if [[ $# != 2 ]]
then
  echo "Usage: backup.sh target_directory_name destination_directory_name"  # Inform the user of the correct script usage
  exit  # Exit the script if the condition is not met
fi

# Validate that both arguments are valid directories
if [[ ! -d $1 ]] || [[ ! -d $2 ]]
then
  echo "Invalid directory path provided"  # Notify the user if any directory path is invalid
  exit  # Exit the script to prevent further execution
fi

# Assign the first argument as the target directory to backup
targetDirectory=$1

# Assign the second argument as the destination directory for the backup
destinationDirectory=$2

# Display the target and destination directory paths for user confirmation
echo "Target Directory: $targetDirectory"
echo "Destination Directory: $destinationDirectory"

# Get the current timestamp in seconds for unique backup file naming
currentTS=$(date +%s)

# Define the name of the backup file using the current timestamp
backupFileName="backup-$currentTS.tar.gz"

# Save the absolute path of the current directory to return to it later
origAbsPath=$(pwd)

# Navigate to the destination directory
cd "$destinationDirectory"

# Retrieve and save the absolute path of the destination directory
destDirAbsPath=$(pwd)

# Return to the original directory
cd "$origAbsPath"

# Change to the target directory to prepare for file processing
cd "$targetDirectory"

# Calculate the timestamp for 24 hours ago to filter recently modified files
yesterdayTS=$((currentTS - 86400))

# Initialize an array to hold the list of files to be backed up
declare -a toBackup

# Iterate over all files in the target directory
for file in $(find . -type f)  # Use `find` to locate all regular files
do
  # Get the last modified time of the current file in seconds
  fileLastModified=$(date -r "$file" +%s)

  # Check if the file was modified within the last 24 hours
  if [[ $fileLastModified -gt $yesterdayTS ]]
  then
    # Add the file to the backup array if it meets the criteria
    toBackup+=("$file")
  fi
done

# Create a compressed archive of all files listed in the `toBackup` array
tar -czf "$backupFileName" "${toBackup[@]}"

# Move the created backup file to the destination directory
mv "$backupFileName" "$destDirAbsPath"

# Inform the user that the backup was successful
echo "Backup completed successfully!"

# Display the location and name of the created backup file
echo "Backup file created: $destDirAbsPath/$backupFileName"
