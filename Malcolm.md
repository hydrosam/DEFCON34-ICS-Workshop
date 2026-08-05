# Working with Malcolm 

## 1. Open the Malcolm welcome page
Open the Malcolm Webpage through the link you found before on the terminal server and log in with those Login information’s. (File on terminal Server: `C:\Users\Public\Documents\Remote_Access_Quick_Reference.txt`)
![Malcolm Login](Images/Malcolm_Login.png)

From this Landing page you can navigate to all the Tools Malcolm is using and to all we will using here in the workshop. (NetBox, OpenSearch Dashboards and Arkime) 
![Malcolm Landingzone](Images/Malcolm_Landingpage.png)

## 2. Network Inventory 
First, we want to go into the Inventory Manager NetBox. Here we want to define the names and the connected IPs of the servers, this does make it simpler for the analysis later, when we can connect the IPs at every time to the Servers without having to remember the IPs. 

### 2.1. Finding the Terminal Server - Netbox is not showing any data... 
1. Change the name 
2. Fist IP Is set, connect to seconds IP. 
### 2.2. Find the Application Server 
1. Change the name
2. Fist IP is set, connect to second IP 
### 2.3. Find the PLC 
1. Change the name 

## 3. OpenSearch Dashboard
When we go back to the [landing page](#1-open-the-malcolm-welcome-page) and open the Dashboard, the fist Dashboard you will see is the Overview, here you see the menu with all the Dashboards Malcolm is coming with and a nice overview of the network traffic in general. 
![Overview Dashboard](Images/Malcolm_overview.png)

## 4. Suricata Alerts 
In the menu you can find the Suricata Alert dashboard, there you can see the Events that Triggered the rules we just talked about. - Scroll down a bit until you can see the Altert"s. 
![Suricata alerts](Images/Malcolm_Suricata_alerts.png)

Here you can find the alert that got triggert by the s7 Stop command we send earlier. 
![s7 Stopp alert](Images/Malcolm_PLC_Stop_alert.png)


With a Click on the alert we get redirected to Arkime where we can take a more detailed look at the Traffic and find out where it came from. 

## 5. Where did the s7 stop command come from? 
Arkime is a powerful tool to inspect network traffic in detail. 
Because we come from OpenSearch, the traffic is prefiltered for the Suricata alert. That makes it easy for us to find the information's what the alert triggert. 
![s7 Stop in Arkime](Images/Malcolm_Stop_Arkime.png)

    ❗Important: make sure the filter time is long enough. Change the default from 1 hour to 24 hours

Because we know now exactly what we are looking for, we cant create our own filter to find the exact PLC stop command. For this we will filter by the source IP (Application Server), destination IP (PLC), protocol (s7comm) and the s7comm function (PLC Stop): 
`ip.src == 10.99.12.213 && ip.dst == 10.99.12.53 && protocols == s7comm && zeek.s7comm.function_name == "PLC Stop"`

When you expand the conversation (`+` on the left side) you can see all the Information connected to this single network signal. Protocols, Port, NetBox information's, protocol details. 
![s7 Stop Command](Images/Malcolm_s7_Stop.png)

Because we just changed the name in NetBox a few minutes ago, here in Arkime is still the old name. That’s why we go back to the NetBox UI and searching for the IPs to see which device its coming from. 

-----Add Net Box screenshots for the search------

## 6. Further Hunting
We know now from which server the Turbine got stopped. The Question is still, from where the attack came from and how was it done. 
For further investigations we are going back to the Suricata alert dashboard ([Suricata alerts](#4-suricata-alerts)). 
Here we can see another alert that got triggered. The SSH Dictionary attack we done at the very beginning today. That triggered the rule of more then 5 wrong ssh authentications to one device in 5 min. 
![ssh alert](Images/Malcolm_ssh_alert.png)

We could do the same here as earlier and jump form here in to Arkime, this time we open Arkime in a new window from the [landing page](#1-open-the-malcolm-welcome-page) and go to the connections page. Filter for the ssh traffic (`protocols == ssh`) and set the time to `24 hours`. 
For here we can walk backwarts and see, which IP sshd into the Application server (the separated connection, in the bottom right).  
![ssh connection overview](Images/Malcolm_ssh_overview.png)

-----Through we can figure out through NetBox, that the *.226 is the Application server and the *.154 the Terminal server. The 10.99.10.13 is as well the Terminal server with the IP to the Internet. (Middle of the circle) We can See, there are a log of public IPs connected to the Terminal server, one of these is the IP from your Laptop doing the bruete force------

## 7. protocol specific default Dashboard
To have more insights into the ssh traffic, we can open one of the many protocol specific OpenSearch Dashboards. As marked in the screenshot, you can see the IP, where the most ssh connections are coming from. Thats the source of the Dictionary attack. 
![ssh Dashboard](Images/Malcolm_OpenSearch_ssh.png)

## 8. Crate own OpenSearch Dashboard 
Screenshots, about how to with two examples. Then they can do more on their own. 
----to be continued 