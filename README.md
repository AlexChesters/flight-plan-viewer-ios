# flight-plan-viewer-ios
iOS app to view flight simulator flight plans

# installing on a real device

# stable build
the stable build is more stable than the development build, but receives feature updates and bug fixes at a slower pace;
if you would rather receive updates sooner despite the risk of more bugs, follow the below instructions to install the
latest development build instead

1. set up [AltStore](https://altstore.io/) on the device in question
1. navigate to the [latest release](https://github.com/AlexChesters/flight-plan-viewer-ios/releases/latest)
1. download `fpv.ipa` from the above page
1. upload the downloaded `.ipa` file to iCloud
    * if you are on a Mac and have iCloud set up, you can run `sh scripts/copy-ipa-to-icloud.sh /path/to/downloaded.ipa`
1. install `fpv.ipa` using the AltStore client application on the device in question

# development build
the development build is the most up-to-date version of the application, but may contain more bugs than the current
stable version; if you are happy with this trade-off, follow the instructions above to install the latest stable build

1. set up [AltStore](https://altstore.io/) on the device in question
1. download the [latest development build](https://github.com/AlexChesters/flight-plan-viewer-ios/releases/download/latest/fpv.ipa)
1. upload the downloaded `.ipa` file to iCloud
    * if you are on a Mac and have iCloud set up, you can run `sh scripts/copy-ipa-to-icloud.sh /path/to/downloaded.ipa`
1. install `fpv.ipa` using the AltStore client application on the device in question
