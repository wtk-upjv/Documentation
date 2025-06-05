Author: @malojeu

## Increase / decrease volume

Script to increase or decrease the volume:

```bash
#!/bin/bash

echo "Use Up/Down arrow keys to increase/decrease volume."
echo "Press 'q' to quit."

stty -echo -icanon time 0 min 0

while true; do
    read -rsn1 key

    if [[ $key == $'\x1b' ]]; then
        read -rsn2 -t 0.1 key2
        key+=$key2

        case $key in
            $'\x1b[A')  # Up arrow
                echo "Volume up"
                amixer set Master 5%+ unmute > /dev/null
                ;;
            $'\x1b[B')  # Down arrow
                echo "Volume down"
                amixer set Master 5%- unmute > /dev/null
                ;;
        esac
    elif [[ $key == "q" ]]; then
        break
    else
        # Print only printable characters
        if [[ $key =~ [[:print:]] ]]; then
            echo "Key pressed: $key"
        else
            echo "Non-printable key pressed"
        fi
    fi

    sleep 0.1
done

stty sane
echo "Exited."
```
