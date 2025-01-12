# Backup-Automation-Script

```
Backup Automation Script

Project Overview

This project is a Bash script designed to automate the process of backing up files. It identifies and archives files modified within the last 24 hours from a target directory and stores the compressed backup in a destination directory. This script is ideal for automating backups in Linux-based environments and demonstrates skills in shell scripting, file manipulation, and cron job scheduling.

Features

Validates input directories for correctness.

Automatically identifies files modified in the last 24 hours.

Archives and compresses updated files into a single .tar.gz backup file.

Supports automation via cron jobs for periodic backups.

Highly customizable and easy to integrate into existing workflows.

Technologies Used

Bash Shell Scripting: For writing the script.

Linux Command-Line Tools: Includes commands like tar, date, find, and touch.

Cron Jobs: For scheduling and automating backups.

File Structure

project-directory/
|-- backup.sh         # The main backup script
|-- important-documents/ # Sample directory for testing backups
|-- README.md         # Project documentation

How It Works

Input Validation:

Ensures two valid directory paths are provided as arguments.

File Selection:

Identifies files modified in the past 24 hours using date and stat.

Backup Creation:

Archives and compresses these files into a .tar.gz file.

Backup Storage:

Moves the backup file to the specified destination directory.

Automation:

The script can be run manually or scheduled to execute automatically using cron jobs.

Script Breakdown

Key Steps in the Script

Input Validation:

if [[ $# != 2 ]]; then
    echo "Usage: backup.sh target_directory_name destination_directory_name"
    exit
fi

if [[ ! -d $1 ]] || [[ ! -d $2 ]]; then
    echo "Invalid directory path provided"
    exit
fi

Variable Initialization:

targetDirectory=$1
destinationDirectory=$2
currentTS=$(date +%s)
backupFileName="backup-$currentTS.tar.gz"
origAbsPath=$(pwd)

File Selection and Archiving:

declare -a toBackup
yesterdayTS=$((currentTS - 86400))

for file in $(find "$targetDirectory" -type f); do
    fileLastModified=$(date -r "$file" +%s)
    if [[ $fileLastModified -gt $yesterdayTS ]]; then
        toBackup+=("$file")
    fi
done

tar -czf "$backupFileName" "${toBackup[@]}"
mv "$backupFileName" "$destinationDirectory"

Automation via Cron Job:

Schedule the script using crontab:

0 0 * * * /usr/local/bin/backup.sh /path/to/target /path/to/destination

How to Use

Prerequisites

A Linux-based environment.

Bash shell.

Basic knowledge of command-line tools.

Setup

Clone the repository:

git clone https://github.com/your-username/backup-automation.git
cd backup-automation

Make the script executable:

chmod +x backup.sh

Test the script:

./backup.sh important-documents .

Automate with Cron

Copy the script to /usr/local/bin/ for system-wide access:

sudo cp backup.sh /usr/local/bin/backup.sh

Schedule the script to run daily at midnight:

crontab -e

Add the following line:

0 0 * * * /usr/local/bin/backup.sh /path/to/target /path/to/destination

Start the cron service:

sudo service cron start

Testing the Script

Download the test dataset:

wget https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-LX0117EN-SkillsNetwork/labs/Final%20Project/important-documents.zip
unzip important-documents.zip

Run the script:

./backup.sh important-documents .

Verify the output:

ls -l backup-*.tar.gz

Example Output

Backup completed successfully!
Backup file created: ./backup-1673558400.tar.gz

Use Cases

Automating daily backups of critical data.

Periodic archiving of log files or documents.

Ensuring data redundancy in a professional environment.

Future Improvements

Add email notifications upon successful backups.

Implement error handling for edge cases (e.g., permissions issues, low disk space).

Support incremental backups to optimize storage.

```
