# BeagleBone Black IoT Monitor

Small IoT web app for controlling BeagleBone Black.

Currently supports GPIO only.

## Installation

1. Clone the project.

2. Install dependencies.

    $ apt-get install ruby
    $ gem install bundle
    $ cd bbb-iot
    $ bundle install

3. Disable default Web server on BBB and reboot (see [here](https://groups.google.com/forum/#!topic/beaglebone/v8A0addJf3E)).

4. Run server

    $ bbb-iot/start.sh

5. Navigate to BBB in Web browser running on your PC (`192.168.7.2`)

## Troubleshooting

If the server won't start because you can't get Bone101 disabled: change the port number in `start.sh` to 3000 and navigate to `192.168.7.2:3000` on your PC.