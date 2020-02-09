# reset-interface is a work around to make sure that the interface always has an expected ip address
# for some reason, it doesn't always reset using just 'dhcpcd -k', so we poll until initialising is successful
# 
# usage in configuration.nix:
# 
# imports = [
#  ...
#  ./nix-odroid-n2/packages/reset-interface.nix
# ];
#
# services.reset-interface = {
#   enable = true; 
#   interface = "eth0";
#   expectedIp = "192.168.0.11";
# }
{ config, lib, pkgs, ...} @ args:

with lib;

let
  cfg = config.services.reset-interface;
in
{
  options.services.reset-interface = {
    enable = mkEnableOption "Reset interface";
    interface = mkOption { type = types.str; default = "eth0"; };
    expectedIp = mkOption { type = types.str; };
  };

  config = mkIf cfg.enable {

    systemd.services.reset-interface = {
      description = "Reset the interface when it doesn't have the expected IP address";
      wantedBy = [ "default.target" ];
      script = ''
         get_ip() {
                 local dev=$1
                 local ip=$2
                 local result=$(${pkgs.iproute}/bin/ip addr show dev $1 2>/dev/null | ${pkgs.gnugrep}/bin/grep -E "inet ([0-9]+){4}" | ${pkgs.gawk}/bin/awk '{print $2}')
                 if [ "$result" = "" ]; then
                         return 1;
                 else
                         echo "$result"
                         if [[ "$result" =~ $ip* ]]; then
                                 return 0;
                         else
                                 echo "ip address is different from $ip*"  >&2
                                 return 1;
                         fi
                 fi
         }

         reset_interface() {
                 local interface=$1
                 ${pkgs.iproute}/bin/ip link set $interface down
                 sleep 5
                 ${pkgs.iproute}/bin/ip link set $interface up
         }

         wait_for_interface() {
                 local dhcpcdDeadline=30
                 local interface=$1
                 local expectedIp=$2
                 while ! get_ip $interface $expectedIp; do
                         echo "resetting $interface"
                         reset_interface $interface
                         echo "waiting $dhcpddDeadline s before checking that we have the IP $expectedIp"
                         sleep $dhcpcdDeadline;
                 done
         }

         keep_interface_alive() {
                 local heartbeat=60
                 local interface=$1
                 local expectedIp=$2
                 if [ "$interface" = "" ]; then
                        echo "interface not set" >&2
                        return 1;
                 fi
                 if [ "$expectedIp" = "" ]; then
                        echo "expectedIp not set" >&2
                        return 1;
                 fi
                 while wait_for_interface $interface $expectedIp; do
                   sleep $heartbeat;
                 done
         }

         keep_interface_alive ${cfg.interface} ${cfg.expectedIp}
      '';
    };
  };

}
