# bash-website-backup
Simple bash script to backup a website directory

## How to use?
Modify the config in backup-website.sh to your needs!

Then run:

    chmod +x backup-website.sh
    ./backup-website.sh

### Backup to Dropbox
If you want to use the dropbox upload. Install dropbox uploader (https://github.com/andreafabrizi/Dropbox-Uploader)

    curl "https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh" -o dropbox_uploader.sh
    
Run uploader and follow install instructions.

    chmod +x dropbox_uploader.sh
    ./dropbox_uploader.sh

Change dropbox uploader settings in backup-website.sh. Thats it.

### Cronjob
If you want the backup every day? Use crontab.

    crontab -e
    # Add the following line
    0 1 * * * /path/to/script/backup-website.sh &> /dev/null