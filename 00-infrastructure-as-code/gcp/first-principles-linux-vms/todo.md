# Na VM 01:


## Cria o túnel apontando para o IP Público da VM 02
sudo ip tunnel add tun0 mode gre remote <IP_PUBLICO_VM02> local <IP_PRIVADO_VM01> ttl 255
sudo ip link set tun0 up
sudo ip addr add 172.16.0.1/30 dev tun0

## Na VM 02:

sudo ip tunnel add tun0 mode gre remote <IP_PUBLICO_VM01> local <IP_PRIVADO_VM02> ttl 255
sudo ip link set tun0 up
sudo ip addr add 172.16.0.2/30 dev tun0
Teste: Da VM 01, faz ping 172.16.0.2. Se der, as máquinas já têm um canal privado.

### Configurar o BGP (FRR)

Configuração na VM 01 (vtysh):


conf t
router bgp 65001
 neighbor 172.16.0.2 remote-as 65002
 !
 address-family ipv4 unicast
  network 10.0.0.0/24  # Estás a anunciar a tua subnet
 exit-address-family
Configuração na VM 02 (vtysh):


conf t
router bgp 65002
 neighbor 172.16.0.1 remote-as 65001
 !
 address-family ipv4 unicast
  network 10.0.1.0/24  # Estás a anunciar a tua subnet
 exit-address-family

na VM 01: vtysh -c "show ip route"
