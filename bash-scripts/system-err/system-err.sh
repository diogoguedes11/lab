#!/bin/bash


top_err=$(journalctl -p err -b)


while true; do
read -p "Choose between [boot_errors],[filter_err] to get the system error messages: " option
clear
case "$option" in 
     boot_errors)
               echo "You chose: $option"
               echo "Errors from system boot:"
               echo "$top_err"
               ;;

     filter_err)
          read -p "Which service do you want to filter on? ex: [dmesg]:  " service
            if [[ -z "$service" ]]; then
                echo "Service name cannot be empty. Please try again."
                continue
            fi
            filter_err=$(journalctl -p err -b --grep "$service")
            if [[ -z "$filter_err" ]]; then
                echo "No errors found for service: $service"
            else
                echo "$filter_err"
            fi
            ;;

     *)
          echo  "Invalid option. Please choose either boot_errors or filter_err."
          ;;
     esac
done