# embarrassing\_settings

## Oneliners

I can get the following all without cloning this repo.

-   Copy the passphrase to clipboard from Bitwarden:
    ```sh
    bw get item 7feb205a-f989-4103-92e7-af4201156bf9 \
        | sed -E 's/^.*"Passphrase","value":"|","type":.*$//g' \
        | tee >(xclip -sel clip)
    ```
-   Copy settings for **EnhancerForYoutube**:
    ```sh
    curl -fsSL 'https://raw.githubusercontent.com/0xTadash1/embarrassing_settings/main/browser_extension/EnhancerForYoutube_settings.json.age' \
        | age -d \
        | xclip -sel clip
    ```
-   Save settings for **AdGuard** as `/tmp/AdGuard.XXXXXXXXXX.json`:
    ```sh
    curl -fsSL 'https://raw.githubusercontent.com/0xTadash1/embarrassing_settings/main/browser_extension/AdGuard_settings.json.age' \ 
        | age -d > $(mktemp -t AdGuard.XXXXXXXXXX --suffix=.json)
    ```

### Prerequisites

-   curl
-   bw
-   age
