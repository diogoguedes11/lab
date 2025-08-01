#!/bin/bash


# Show system boot errors
boot_errors() {
     echo "You chose: $1"
     echo "Errors from system boot:"
     if ! journalctl -p err -b; then
          echo "Error: unable to read journal."
     fi
}
# Filter errors by service name
filter_services() {
     local service=$1
     if [[ -z "$service" ]]; then
          echo "Service name cannot be empty. Please try again."
          continue
     fi
     filter_err=$(journalctl -p err -b --grep "$service")
     if [ $? -ne 0 ]; then
          echo "Unable to read journal."
          return
     fi
     if [[ -z "$filter_err" ]]; then
          echo "No errors found for service: $service"
     else
          echo "$filter_err"
     fi

}


main() {
     while true; do
          read -p "Choose between [boot_errors],[filter_err] to get the system error messages or [exit] to leave the program: " option
          clear
          option=$(echo "$option" | xargs) # remove whitespaces
          case "$option" in 
          boot_errors)
                    boot_errors "$option"
                    ;;

          filter_err)
                    read -p "Which service do you want to filter on? ex: [dmesg]:  " service
                    filter_services "$service"
                    ;;

          exit)
               exit 0
               ;;
          *)
               echo  "Invalid option. Please choose either boot_errors or filter_err."
               ;;
          esac
     done
}

main