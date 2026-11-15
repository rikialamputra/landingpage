
#########################################################
/ip firewall address-list
add list=HOST_LOCAL address=10.0.0.0/8 
add list=HOST_LOCAL address=172.16.0.0/12 
add list=HOST_LOCAL address=192.168.0.0/16 
/ip route
add gateway= routing-mark=routing-game 
/ip firewall mangle
add action=mark-routing chain=prerouting connection-mark=conn-game new-routing-mark=routing-game passthrough=no src-address-list=HOST_LOCAL  place-before=*0
add action=mark-connection chain=prerouting dst-address-list=List-IP-Games new-connection-mark=conn-game passthrough=yes  place-before=*0
##############################################################
# If you want to add a game script only, you can ignore the script above

################ set Priority ################################
/queue simple
add priority=8/8 max-limit="20M/20M" name="-> YOUTUBE" packet-marks="Youtube-Up,Youtube-Down" target="192.168.0.0/16,172.16.0.0/12,10.0.0.0/8"
/ip firewall mangle
add action=mark-connection chain=prerouting new-connection-mark="Youtube-conn" dst-address-list="Mikrotik-Youtube" passthrough=yes src-address-list=HOST_LOCAL comment="Youtobe Mangle"
add action=mark-packet chain=prerouting connection-mark="Youtube-conn" src-address-list=HOST_LOCAL new-packet-mark="Youtube-Up" passthrough=no
add action=mark-packet chain=postrouting connection-mark="Youtube-conn" dst-address-list=HOST_LOCAL new-packet-mark="Youtube-Down" passthrough=no

##############################################################

/ip firewall raw
# Arena Of Valor - Mobile
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Arena Of Valor - Mobile" dst-address-list=!HOST_LOCAL dst-port=10001-10094 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=10101-10201,10080-10110,17000-18000 protocol=udp
# Among Us - Mobile
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Among Us - Mobile" dst-address-list=!HOST_LOCAL dst-port=27015-27030,27036-27037 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=4380,27000-27031,27036 protocol=udp
# Booya Capsa Susun - Mobile
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Booya Capsa Susun - Mobile" dst-address-list=!HOST_LOCAL dst-port=7090-7100 protocol=tcp
# Booya Domino Qiuqiu - Mobile
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Booya Domino Qiuqiu - Mobile" dst-address-list=!HOST_LOCAL dst-port=7020-7030 protocol=tcp
# Clash Of Clans - Mobile
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Clash Of Clans - Mobile" dst-address-list=!HOST_LOCAL dst-port=9330-9340 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=9330-9340 protocol=udp
# Clash Royale (Cry) - Mobile
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Clash Royale (Cry) - Mobile" dst-address-list=!HOST_LOCAL dst-port=9330-9340 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=9330-9340 protocol=udp
# Call Of Duty - Mobile
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Call Of Duty - Mobile" dst-address-list=!HOST_LOCAL dst-port=3013,10000-10019,18082,50000,65010,65050 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=7085-7995,8700,9030,10010-10019,17000-20100 protocol=udp
# DOTA2 - Mobile
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="DOTA2 - Mobile" dst-address-list=!HOST_LOCAL dst-port=9100-9200,8230-8250,8110-8120,27000-28998 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=27000-28998,39000 protocol=udp
# Domino Qq - Mobile
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Domino Qq - Mobile" dst-address-list=!HOST_LOCAL dst-port=9122,11000-11150 protocol=tcp
# Dragon Nest - Mobile
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Dragon Nest - Mobile" dst-address-list=!HOST_LOCAL dst-port=10514 protocol=tcp
# Dream League Soccer - Mobile
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Dream League Soccer - Mobile" dst-address-list=!HOST_LOCAL dst-port=60970-60980 protocol=udp
# FIFA ONLINE - Mobile
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="FIFA ONLINE - Mobile" dst-address-list=!HOST_LOCAL dst-port=7770-7790 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=16300-16350 protocol=udp
# Free Fire - Mobile
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Free Fire - Mobile" dst-address-list=!HOST_LOCAL dst-port=6006,6674,7006,7889,8001-8012,9006,9137,10000-10012,11000-11019 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=12006,12008,13006,15006,20561,39003,39006,39698,39779,39800 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=6006,6008,7008,8008,8130,8443,9008,9120,10000-10015,10100,11000-11019,12008,13008 protocol=udp
# Genshin Impact - Mobile
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Genshin Impact - Mobile" dst-address-list=!HOST_LOCAL dst-port=42472 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=42472,22101-22102 protocol=udp
# Higgs Domino Island - Mobile
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Higgs Domino Island - Mobile" dst-address-list=!HOST_LOCAL dst-port=50000-50500 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=40000-40010 protocol=udp
# League of Legends (LOL) - Mobile
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="League of Legends - Mobile" dst-address-list=!HOST_LOCAL dst-port=2080-2099 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=5100 protocol=udp
# Last Empire War Z - Mobile
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Last Empire War Z - Mobile" dst-address-list=!HOST_LOCAL dst-port=9930-9940 protocol=tcp
# Line Lets Get Rich - Mobile
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Line Lets Get Rich - Mobile" dst-address-list=!HOST_LOCAL dst-port=10500-10515 protocol=tcp
# Minecraft - Mobile
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Minecraft - Mobile" dst-address-list=!HOST_LOCAL dst-port=25565,19132-19133 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=25565,19132-19133 protocol=udp
# Mobile Legends - Mobile
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Mobile Legends - Mobile" dst-address-list=!HOST_LOCAL dst-port=5000-5221,5224-5227,5229-5241,5243-5508,5551-5559,5601-5700,9000-9010,9443 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=5520-5529,10003,30000-30300,8443 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=4001-4009,5000-5221,5224-5241,5243-5509,5551-5559,5601-5700,8130,8443,9120 protocol=udp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=2702,3702,5517,5520-5529,8001,9000-9010,9992,10003,30000-30300 protocol=udp
# Mostly - Mobile
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Mostly - Mobile" dst-address-list=!HOST_LOCAL dst-port=9933 protocol=tcp
# Naruto Little Ninja (China) - Mobile
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Naruto Little Ninja (China) - Mobile" dst-address-list=!HOST_LOCAL dst-port=6170-6180 protocol=tcp
# Netmarble - Mobile
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Netmarble - Mobile" dst-address-list=!HOST_LOCAL dst-port=12000-12010 protocol=tcp
# Point Blank - Mobile
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=44590-44610 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Point Blank - Mobile" dst-address-list=!HOST_LOCAL dst-port=40000-40010 protocol=udp
# PUBG - Mobile
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="PUBG - Mobile" dst-address-list=!HOST_LOCAL dst-port=7889,10012,13004,14000,17000,17500,18081,20000-20002,20371 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=8011,9030,10491,10612,12235,13004,13748,17000,17500,20000-20002 protocol=udp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=7086-7995,10039,10096,11455,12070-12460,13894,13972,41182-41192 protocol=udp
# Roblox - Mobile
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Roblox - Mobile" dst-address-list=!HOST_LOCAL dst-port=3074 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=88,500,3074,3544,4500,49152-65535 protocol=udp
# Rpg Toram Online - Mobile
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Rpg Toram Online - Mobile" dst-address-list=!HOST_LOCAL dst-port=30100-30110 protocol=tcp
# Rules Of Survival - Mobile
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Rules Of Survival - Mobile" dst-address-list=!HOST_LOCAL dst-port=24000-24050 protocol=udp
# Shinobi Heroes - Mobile
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Shinobi Heroes - Mobile" dst-address-list=!HOST_LOCAL dst-port=10005-10020 protocol=tcp


###################################### WEB GAME ###################
/ip firewall raw
# 8 Ball Pool - Web Games
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="8 Ball Pool (Miniclips - Web Games" dst-address-list=!HOST_LOCAL dst-port=4000 protocol=tcp
#CastleVille - Web Games
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="CastleVille - Web Games" dst-address-list=!HOST_LOCAL dst-port=8890 protocol=tcp
# Headshot - Web Games
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Headshot - Web Games" dst-address-list=!HOST_LOCAL dst-port=1800-1810 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=1845-1860 protocol=udp
# Empire & Allies - Web Games
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Empire & Allies - Web Games" dst-address-list=!HOST_LOCAL dst-port=8890 protocol=tcp
# League of Angels 2 - Web Games
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="League of Angels 2 - Web Games" dst-address-list=!HOST_LOCAL dst-port=51700-51715 protocol=tcp
# Megarealm: Rise Of Chaos - Web Games
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Megarealm: Rise Of Chaos" dst-address-list=!HOST_LOCAL dst-port=26590-26600 protocol=tcp
# Perjuangan Semut - Web Games
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Perjuangan Semut - Web Games" dst-address-list=!HOST_LOCAL dst-port=7200-7210,7450-7460 protocol=tcp
# Roblox - Web Games
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Roblox - Web Games" dst-address-list=!HOST_LOCAL dst-port=49152-65535 protocol=udp
# Sword of Angels - Web Games
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Sword of Angels - Web Games" dst-address-list=!HOST_LOCAL dst-port=15490-15510 protocol=tcp
# Texas HoldEm Poker - Games Web
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Texas HoldEm Poker - Games Web" dst-address-list=!HOST_LOCAL dst-port=9339 protocol=tcp
# Warflare - Web Games
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Warflare - Web Games" dst-address-list=!HOST_LOCAL dst-port=64990-65010 protocol=tcp
# WildOnes - Web Games
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="WildOnes - Web Games" dst-address-list=!HOST_LOCAL dst-port=8000 protocol=tcp


#################### PC GAME ##########################################
/ip firewall raw
# Atlantica - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Atlantica - PC" dst-address-list=!HOST_LOCAL dst-port=4300 protocol=tcp
# Aura Kingdom - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Aura Kingdom - PC" dst-address-list=!HOST_LOCAL dst-port=5540-5580 protocol=tcp
# Ayo Dance - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Ayodance - PC" dst-address-list=!HOST_LOCAL dst-port=18900-18910 protocol=tcp
# Origin APEX Legends - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Origin APEX Legends - PC" dst-address-list=!HOST_LOCAL dst-port=9960-9969,1024-1124,3216,18000,18120,18060,27900,28910,29900 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=1024-1124,18000,29900,37000-40000 protocol=udp
# Black Desert Online - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Black Desert Online - PC" dst-address-list=!HOST_LOCAL dst-port=8888,9991-9993 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=8888,9991-9993 protocol=udp
# Black Desert Online - Playstation
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Black Desert Online Playstation" dst-address-list=!HOST_LOCAL dst-port=1935,3478-3480 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=3074,3478-3479 protocol=udp
# Black Desert Online Steam - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Black Desert Online Steam - PC" dst-address-list=!HOST_LOCAL dst-port=8888,9991-9993,27015-27030,27036-27037 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=4380,8888,9991-9993,27000-27031,27036 protocol=udp
# Black Desert Online - Xbox
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Black Desert Online Xbox - PC" dst-address-list=!HOST_LOCAL dst-port=3074 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=88,500,3074,3544,4500 protocol=udp
# Black retribution - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Blackretribution - PC" dst-address-list=!HOST_LOCAL dst-port=7020-7050,8200-8220,9000-9020 protocol=udp
# Blizzard BattleNet - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Blizzard BattleNet - PC" dst-address-list=!HOST_LOCAL dst-port=1119 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=1119 protocol=udp
# Bounty Hound - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Bounty Hound - PC" dst-address-list=!HOST_LOCAL dst-port=9810-9860 protocol=tcp
# Cabal Extreme Private - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Cabal Extreme Private - PC" dst-address-list=!HOST_LOCAL dst-port=60170-60180,63000-64000,38101,38110-38600 protocol=tcp
# Cabal Indonesia - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Cabal Indonesia - PC" dst-address-list=!HOST_LOCAL dst-port=63000-64000,38101,38110-38130 protocol=tcp
# Call of Duty BO - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Call of Duty BO - PC" dst-address-list=!HOST_LOCAL dst-port=3074,27014-27050 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=3478,4379-4380,27000-27031,27036 protocol=udp
# Callof Duty BO - Playstation
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Call of Duty BO - Playstation" dst-address-list=!HOST_LOCAL dst-port=80,443,1935,3478-3480 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=3478-3479 protocol=udp
# Call of Duty BO - XBox
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Call of Duty BO - XBox" dst-address-list=!HOST_LOCAL dst-port=53,80,3074 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=88,500,3074,3075,3544,4500 protocol=udp
# Call of Duty MW - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Call of Duty MW PC - PC" dst-address-list=!HOST_LOCAL dst-port=3074,27014-27050 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=3074,3478,4379-4380,27000-27031,27036 protocol=udp
# Call of Duty MW - Playstation
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Call of Duty MW Playstation" dst-address-list=!HOST_LOCAL dst-port=1935,3478-3480 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=3074,3478-3479 protocol=udp
# Call of Duty MW - XBox
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Call of Duty MW - XBox" dst-address-list=!HOST_LOCAL dst-port=3074 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=88,500,3074,3075,3544,4500 protocol=udp
# Clash of God - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Clash of God - PC" dst-address-list=!HOST_LOCAL dst-port=9430-9450,5220-5230 protocol=tcp
# CSGO - Playstation
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="CSGO - Playstation" dst-address-list=!HOST_LOCAL dst-port=3478-3480,5223,8080 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=3074,3478-3479,3658 protocol=udp
# CSGO Steam - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="CSGO Steam - PC" dst-address-list=!HOST_LOCAL dst-port=27015-27030,27036-27037 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=4380,27000-27031,27036 protocol=udp
# CSGO - Xbox
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="CSGO - Xbox" dst-address-list=!HOST_LOCAL dst-port=3074 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=88,3074 protocol=udp
# CrossFire indonesia - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Cross Fire indonesia - PC" dst-address-list=!HOST_LOCAL dst-port=10009,13008,16666,28012 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=12020-12080,13000-13080 protocol=udp
# Diablo III - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Diablo III - PC" dst-address-list=!HOST_LOCAL dst-port=1119 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=1119,6120 protocol=udp
# Diablo II - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Diablo II - PC" dst-address-list=!HOST_LOCAL dst-port=6112,4000 protocol=tcp
# Diablo I - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Diablo - PC" dst-address-list=!HOST_LOCAL dst-port=6112-6119 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=6112-6119 protocol=udp
# DOTA2 Steam - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Dota 2 Steam - PC" dst-address-list=!HOST_LOCAL dst-port=9100-9200,8230-8250,8110-8120 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=28010-28200,27010-27200,39000 protocol=udp
# Dragon Nest - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Dragon Nest - PC" dst-address-list=!HOST_LOCAL dst-port=14300-15512 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=15000-15500 protocol=udp
# Dragona - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Dragona - PC" dst-address-list=!HOST_LOCAL dst-port=10000-10030 protocol=tcp
# Fifa Online 3 - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Fifa Online 3 - PC" dst-address-list=!HOST_LOCAL dst-port=7770-7790 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=16300-16350 protocol=udp
# FORTNITE EPIC GAMES - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="FORTNITE EPIC GAMES - PC" dst-address-list=!HOST_LOCAL dst-port=9000-9100 protocol=udp
# League of Legend - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="League of Legend - PC" dst-address-list=!HOST_LOCAL dst-port=2080-2099 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port="5100 protocol=udp
# Grand Chase - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Grand Chase - PC" dst-address-list=!HOST_LOCAL dst-port=9300,9400,9700 protocol=tcp
# Hearthstone - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Hearthstone - PC" dst-address-list=!HOST_LOCAL dst-port=1119,3724 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port="1119,3724 protocol=udp
# Heroes of the Storm - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Heroes of the Storm - PC" dst-address-list=!HOST_LOCAL dst-port=1119-1120,3724,6113 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=1119-1120,3478-3479,3724,5060,5062,6113,6250,12000-64000 protocol=udp
# HON Heroes of Newerth - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="HON Heroes of Newerth - PC" dst-address-list=!HOST_LOCAL dst-port=9100-9200,11200-11500 protocol=udp
# Heroes of Atarsia - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Heroes of Atarsia - PC" dst-address-list=!HOST_LOCAL dst-port=7777,9400 protocol=tcp
# Idol Street - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Idol Street - PC" dst-address-list=!HOST_LOCAL dst-port=2001-2010 protocol=tcp
# Left4Dead 2 Steam - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Left4Dead 2 Steam - PC" dst-address-list=!HOST_LOCAL dst-port=4360-4390 protocol=udp
# Lineage 2 - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Lineage 2 - PC" dst-address-list=!HOST_LOCAL dst-port=7777,10000,11000,13000 protocol=tcp
# Lost Saga - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Lost Saga - PC" dst-address-list=!HOST_LOCAL dst-port=14000-14010 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=14000-14010 protocol=udp
# Lune of eden - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Lune of eden - PC" dst-address-list=!HOST_LOCAL dst-port=8400 protocol=tcp
# Mercenary ops - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Mercenary ops - PC" dst-address-list=!HOST_LOCAL dst-port=6000-6125 protocol=tcp
# Mircovolt - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Mircovolt - PC" dst-address-list=!HOST_LOCAL dst-port=13000 protocol=tcp
# Modo Marble - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Modo Marble - PC" dst-address-list=!HOST_LOCAL dst-port=28900-28914 protocol=tcp
# Overwatch - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Overwatch - PC" dst-address-list=!HOST_LOCAL dst-port=1119,3724,6113 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=3478-3479,5060,5062,6250,12000-64000 protocol=udp
# Paladins Hi-Rez - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Paladins Hi-Rez - PC" dst-address-list=!HOST_LOCAL dst-port=9000-9999 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=9002-9999 protocol=udp
# Point Blank - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Point Blank - PC" dst-address-list=!HOST_LOCAL dst-port=39190-39200 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=40000-40010 protocol=udp
# PUBG Playerunknown Battlegrounds - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="PUBG Playerunknown Battlegrounds - PC" dst-address-list=!HOST_LOCAL dst-port=7080-8000 protocol=udp
# Ragnarok 2 - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Ragnarok 2 - PC" dst-address-list=!HOST_LOCAL dst-port=7201-7210,7401-7410 protocol=tcp
# RF Rising Force - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="RF Rising Force - PC" dst-address-list=!HOST_LOCAL dst-port=27780 protocol=tcp
# ROE Ring of Elysium - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="ROE Ring of Elysium - PC" dst-address-list=!HOST_LOCAL dst-port=9002,10000-10015 protocol=tcp
# ROS Rules Of Survival - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="ROS Rules Of Survival - PC" dst-address-list=!HOST_LOCAL dst-port=24000-24100 protocol=udp
# Seal Online - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Seal Online - PC" dst-address-list=!HOST_LOCAL dst-port=1818 protocol=tcp
# Special Force - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Special Force - PC" dst-address-list=!HOST_LOCAL dst-port=27920-27940 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=30000-30030 protocol=udp
# StarCraft II - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="StarCraft II - PC" dst-address-list=!HOST_LOCAL dst-port=1119,6113,1120,80,3724 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=1119,6113,1120,80,3724 protocol=udp
# StarCraft - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="StarCraft - PC" dst-address-list=!HOST_LOCAL dst-port=6112 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=9401,9600,16440-16450 protocol=udp
# Valorant - PC Games
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Valorant - PC Games" dst-address-list=!HOST_LOCAL dst-port=2099,5222-5223,8088,8393-8400 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=7000-7500,8088 protocol=udp
# Warcraft II BattleNet - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Warcraft II BattleNet - PC" dst-address-list=!HOST_LOCAL dst-port=6112-6119 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=6112-6119 protocol=udp
# Warcraft III - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Warcraft III - PC" dst-address-list=!HOST_LOCAL dst-port=6112,6113-6119 protocol=tcp
# Warframe - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Warframe - PC" dst-address-list=!HOST_LOCAL dst-port=4950-4955 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=6695-6699 protocol=udp
# World of Tanks - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="World of Tanks - PC" dst-address-list=!HOST_LOCAL dst-port=20000-25000,8081,8088,32801,3280 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=12000-29999,32801-32825, 5060,5062,3478,3479,20014 protocol=udp
# World of Warcraft - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="World of Warcraft - PC" dst-address-list=!HOST_LOCAL dst-port=3724,1119,6012 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=3724,1119,6012 protocol=udp
# Xshot Indonesia - PC
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting comment="Xshot Indonesia - PC" dst-address-list=!HOST_LOCAL dst-port=7320-7350 protocol=tcp
add action=add-dst-to-address-list address-list="List-IP-Games" address-list-timeout=1d chain=prerouting dst-address-list=!HOST_LOCAL dst-port=7800-7850,30000 protocol=udp


########## Whatsapp raw #############
/ip firewall raw
rem [find address-list=Mikrotik-WhatsApp]
add action=add-dst-to-address-list address-list=Mikrotik-WhatsApp address-list-timeout=1d chain=prerouting protocol=tcp tls-host=*whatsapp.com* dst-address-list=!HOST_LOCAL src-address-list=HOST_LOCAL comment="WhatsApp - alamhost"
add action=add-dst-to-address-list address-list=Mikrotik-WhatsApp address-list-timeout=1d chain=prerouting protocol=tcp tls-host=*.whatsapp.* dst-address-list=!HOST_LOCAL src-address-list=HOST_LOCAL
add action=add-dst-to-address-list address-list=Mikrotik-WhatsApp address-list-timeout=1d chain=prerouting protocol=tcp tls-host=*wa.me* dst-address-list=!HOST_LOCAL src-address-list=HOST_LOCAL
add action=add-dst-to-address-list address-list=Mikrotik-WhatsApp address-list-timeout=1d chain=prerouting protocol=tcp tls-host=*.wa.* dst-address-list=!HOST_LOCAL src-address-list=HOST_LOCAL

/ip firewall address-list
rem [find list="Mikrotik-WhatsApp"]
add address=66.111.48.0/22 list=Mikrotik-WhatsApp
