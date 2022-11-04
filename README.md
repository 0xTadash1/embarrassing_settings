# embarrassing\_settings

-   Copy the passphrase to clipboard from Bitwarden:
    ```sh
    bw get item 7feb205a-f989-4103-92e7-af4201156bf9 \
        | jq '.fields[0].value' \
        | tr -d '"' | tr -d $$'\n' \
        | tee >(xclip -sel clip)
    ```
-   Copy settings for **EnhancerForYoutube**:
    ```sh
    curl -fsSL 'https://raw.githubusercontent.com/0xTadash1/embarrassing_settings/main/browser_extension/EnhancerForYoutube_settings.json.age' | age -d | xclip -sel clip
    ```
-   Save as `/tmp/AdGuard.XXXXXXXXXX.json`:
    ```sh
    curl -fsSL 'https://raw.githubusercontent.com/0xTadash1/embarrassing_settings/main/browser_extension/AdGuard_settings.json.age' | age -d > $(mktemp -t AdGuard.XXXXXXXXXX --suffix=.json)
    ```
