# server analyzer
- Server Analyzer is a Server Scanning App built using Flutter that utilizes the nikto a powerful server scanning tool to scan for 
  the server side vulnerability.      
- The App solely design for Android Platform allowing user to perform Nikto scan without rooting the phone. 

# Features
- Allows user to perform multiple Nikto Scan.
- User can choose custom server to perform scan.
- The result gets automatically saved in the user device.
- Custom Command Execution.

# Steps to Setup Project 
 # Using Git
  - 1). Git Clone the repository using following command.
        ``` git clone https://github.com/aklavya20/server-analyzer.git ``` 
  - 2). Open the project in Android Studio and in terminal type flutter pub get.
  - 3). Make a Kali Linux VM and paste the **nikto.php** file in the /var/www/html folder.
  - 4). Setup tailscale on the Kali linux 
     - a). Paste the following URL in the kali terminal.
           ``` curl -fsSL https://tailscale.com/install.sh | sh ```
     - b). Enter following Command after installing tail scale.
           ``` tailscale up ```
     - c). After Successfully registering the device on tailscale enter the following command.
           ``` tailscale funnel 80 ```
     - d). You will get a url something like this. 
         - url: https://kali.tail7d5586.ts.net 
         - Try accessing the url to see if you can see the index.html page of the apache2 server. 
 # Note: Please start the apache server before tailscale funnel use the command sudo systemctl apache start then start the tailscale funnel.
   - 5). Add the following permission in your /etc/sudoers file. 
     - To add necessary Permissions follow the steps below
      - a). Open the terminal and enter the command **sudo su** and then enter your root user password.
      - b). Enter the following Command.
            ``` nano /etc/sudoers ```
      - c). Enter the following permissions.
            ``` www-data ALL=(ALL) NOPASSWD: /usr/bin/nikto ```
      - d). The final /etc/sudoers file should look like this.
            #
            # This file MUST be edited with the 'visudo' command as root.
            #
            # Please consider adding local content in /etc/sudoers.d/ instead of
            # directly modifying this file.
            #
            # See the man page for details on how to write a sudoers file.
            #
             Defaults	env_reset
             Defaults	mail_badpass
             Defaults	secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

            # This fixes CVE-2005-4890 and possibly breaks some versions of kdesu
            # (#1011624, https://bugs.kde.org/show_bug.cgi?id=452532)
             Defaults	use_pty


            # This preserves proxy settings from user environments of root
            # equivalent users (group sudo)
            # Defaults:%sudo env_keep += "http_proxy https_proxy ftp_proxy all_proxy no_proxy"

            # This allows running arbitrary commands, but so does ALL, and it means
            # different sudoers have their choice of editor respected.
            #Defaults:%sudo env_keep += "EDITOR"

            # Completely harmless preservation of a user preference.
            #Defaults:%sudo env_keep += "GREP_COLOR"

            # While you shouldn't normally run git as root, you need to with etckeeper
            #Defaults:%sudo env_keep += "GIT_AUTHOR_* GIT_COMMITTER_*"

            # Per-user preferences; root won't have sensible values for them.
            #Defaults:%sudo env_keep += "EMAIL DEBEMAIL DEBFULLNAME"

            # "sudo scp" or "sudo rsync" should be able to use your SSH agent.
            #Defaults:%sudo env_keep += "SSH_AGENT_PID SSH_AUTH_SOCK"

            # Ditto for GPG agent
            #Defaults:%sudo env_keep += "GPG_AGENT_INFO"

            # Host alias specification

            # User alias specification

            # Cmnd alias specification

            # User privilege specification
              root	ALL=(ALL:ALL) ALL
              www-data ALL=(ALL) NOPASSWD: /usr/bin/nikto
            # Allow members of group sudo to execute any command
              %sudo	ALL=(ALL:ALL) ALL

            # See sudoers(5) for more information on "@include" directives:

            @includedir /etc/sudoers.d

  - 6). Now run the project in android studio.

# Using Source  
  - 1). Download the repository as a zip file by clicking on download as zip.
        ``` https://github.com/aklavya20/server-analyzer.git ```
  - 2). Open the project in Android Studio and in terminal type flutter pub get after extracting the zip folder. 
  - 3). Make a Kali Linux VM and paste the **nikto.php** file in the /var/www/html folder.
  - 4). Setup tailscale on the Kali linux.
       - a). Paste the following URL in the kali terminal.
             ``` curl -fsSL https://tailscale.com/install.sh | sh ```
       - b). Enter following Command after installing tail scale.
             ``` tailscale up ```
       - c). After Successfully registering the device on tailscale enter the following command.
             ``` tailscale funnel 80 ```
       - d). You will get a url something like this.
           - url: https://kali.tail7d5586.ts.net
           - Try accessing the url to see if you can see the index.html page of the apache2 server.
# Note: Please start the apache server before tailscale funnel use the command sudo systemctl apache start then start the tailscale funnel.
  - 5). Add the following permission in your /etc/sudoers file.
       - To add necessary Permissions follow the steps below
      - a). Open the terminal and enter the command **sudo su** and then enter your root user password.
      - b). Enter the following Command.
            ``` nano /etc/sudoers ```
      - c). Enter the following permissions.
            ``` www-data ALL=(ALL) NOPASSWD: /usr/bin/nikto ```
      - d). The final /etc/sudoers file should look like this.
             #
             # This file MUST be edited with the 'visudo' command as root.
             #
             # Please consider adding local content in /etc/sudoers.d/ instead of
             # directly modifying this file.
             #
             # See the man page for details on how to write a sudoers file.
             #
              Defaults	env_reset
              Defaults	mail_badpass
              Defaults	secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

             # This fixes CVE-2005-4890 and possibly breaks some versions of kdesu
             # (#1011624, https://bugs.kde.org/show_bug.cgi?id=452532)
              Defaults	use_pty


             # This preserves proxy settings from user environments of root
             # equivalent users (group sudo)
             # Defaults:%sudo env_keep += "http_proxy https_proxy ftp_proxy all_proxy no_proxy"

             # This allows running arbitrary commands, but so does ALL, and it means
             # different sudoers have their choice of editor respected.
             #Defaults:%sudo env_keep += "EDITOR"

             # Completely harmless preservation of a user preference.
             #Defaults:%sudo env_keep += "GREP_COLOR"

            # While you shouldn't normally run git as root, you need to with etckeeper
            #Defaults:%sudo env_keep += "GIT_AUTHOR_* GIT_COMMITTER_*"

            # Per-user preferences; root won't have sensible values for them.
            #Defaults:%sudo env_keep += "EMAIL DEBEMAIL DEBFULLNAME"

            # "sudo scp" or "sudo rsync" should be able to use your SSH agent.
            #Defaults:%sudo env_keep += "SSH_AGENT_PID SSH_AUTH_SOCK"

            # Ditto for GPG agent
            #Defaults:%sudo env_keep += "GPG_AGENT_INFO"

            # Host alias specification

            # User alias specification

            # Cmnd alias specification

            # User privilege specification
              root	ALL=(ALL:ALL) ALL
              www-data ALL=(ALL) NOPASSWD: /usr/bin/nikto
            # Allow members of group sudo to execute any command
              %sudo	ALL=(ALL:ALL) ALL

            # See sudoers(5) for more information on "@include" directives:

            @includedir /etc/sudoers.d

  - 6). Now run the project in android studio.
# Installation of app   
  Visit the url to download the app.
  - url: [server-analyzer](https://github.com/aklavya20/server-analyzer/releases/download/server-analyzer/server-analyzer.apk)
# Usage
  - 1). Download the app. 
  - 2). On the right hand corner of the screen you may see the terminal logo here you can enter the custom server address, 
        that have **nikto.php** file already setup on it with all the necessary permission on it the server url should be like this.
      - https://your-server-ip/nikto.php
      - example:https://kali.tail7d5586.ts.net/nikto.php
  - 3). You have two text box first one is where you enter the nikto command second is where you specify the target details.  
  - 4). You have various drop down menu which comprises of nikto flags that helps in forming nikto command. 
  - 5). Click on Scan button to start the nikto scan.
  - 6). To view the scan see the scan result page.
      - Scan result separate the scan result in  category **XML** **TXT** **CSV** **HTML** **JSON** **SQL** **NBE** based on output 
        format you select here you can see your scan result. 
# You can start multiple scan at once.
# If you like my project support me by buying me a coffee

<h3 align="left">Support:</h3>
<p><a href="https://buymeacoffee.com/aklavya20"> <img align="left" src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="50" width="210" alt="https://buymeacoffee.com/aklavya20" /></a></p>