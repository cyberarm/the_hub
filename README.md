# The Hub

A dashboard for monitoring the host system, web servers, game servers, and sensors/iot/services.

Supported Monitors:

0. System (Monitor host system cpu/network load/memory)
1. HTTP(S) Servers
2. Command & Conquer: Renegade (GameSpy Query)
3. Minecraft
4. Minetest (Only able to detect if server is responsive)
5. Sensors/IoT/Services (Which report into the Hub)

## Installation
0. Have a Linux/Unix system
1. Install `crystal`
2. Install `libsass` and `dnsutils`
3. Run `shards install`

* dnsuntils is required for the `dig` command to be available to HubDNS::SRV for Minecraft monitor.

## Usage

0. Run `crystal src/the_hub.cr`
1. On first run the database will be created and you'll be asked to enter credentials to create the Administrator account

## Development

TODO: Write development instructions here

## API

TODO: Write API docs here

## Contributing

1. Fork it (<https://github.com/cyberarm/the_hub/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Code of Conduct
"Matz is nice so we are nice."

## Contributors

- [Cyberarm](https://github.com/cyberarm) Cyberarm - creator, maintainer
