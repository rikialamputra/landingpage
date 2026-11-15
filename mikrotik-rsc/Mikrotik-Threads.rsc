#####################################
# Created By AlamhostPBun.Github.io 
#####################################
/ip firewall raw
rem [find comment="Threads - Alamhostpbun.github.io"]
add action=add-dst-to-address-list address-list=Mikrotik-Threads address-list-timeout=1d chain=prerouting comment="Threads - Alamhostpbun.github.io" content=.threads. dst-address-list=!LOCAL-IP src-address-list=LOCAL-IP

/ip firewall address-list
rem [find list="Mikrotik-Threads"]
add address=threads.net list=Mikrotik-Threads
add address=www.threads.net list=Mikrotik-Threads
add address=gateway.threads.net list=Mikrotik-Threads
