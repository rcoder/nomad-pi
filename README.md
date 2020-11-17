# nomad-pi

Build a tailored SD card image to put Ubuntu and Nomad on a Raspberry Pi. Each image should get a unique hostname (which will be advertised via mDNS) and be ready for headless access via SSH using Ethernet and/or Wifi.

## Usage

First, download the latest Ubuntu server image. ([20.04.1 LTS](https://ubuntu.com/download/raspberry-pi/thank-you?version=20.04.1&architecture=server-arm64+raspi) as of this writing) for your Pi and save to this directory. To make subsequent runs less painful, go ahead and `unxz <image>.xz`; otherwise the script below will decompress on-demand every time, which takes a while.

Next, stick a micro SD card into a USB-attached reader (or internal card slot if your laptop has one).

Then, run the following:

```sh
git clone https://github.com/rcoder/nomad-pi
cd nomad-pi

# preconfigure hostname and wifi network
./create-config --wifi --hostname nomad-rpi-1
# answer wifi setup prompts, if relevant
# note: this will slurp up a default ed25519 or rsa ssh public key from your `~/.ssh` directory
# there's a `--github <username>` argument to import all your public keys from the GH API, but
# it's almost certainly broken for wifi-only setups

# ...then copy the recommended `flash` script invocation with your downloaded
# OS image, like so:
./flash -u ./generated/nomad-rpi-1.yaml ./ubuntu-20.04.1-preinstalled-server-arm64+raspi.img
```

The `flash` script should auto-detect your SD card, and after confirmation it will start writing the image. Note: this takes a while, and the progress bar may appear to be frozen at 100%; likewise, unmounting the disk at the end may seem to hang. Be patient. SD cards are terrible hard drives, and UNIX filesytem write calls are _liars_; your machine is buffering most of the disk image in RAM before it actually flushes to disk.

Once the above completes, you can remove the card, put it in the RPi, and power it up. On startup the RPi will install the OS, update + upgrade packages, apply the cloud-init config generated above, and restart. This too takes several (okay, more like ~15) minutes, so go get a cup of coffee or stretch your legs for a minute. If you're imaging multiple RPis, this might be a good time to start the next image creation + flashing process.

After it comes back up from the install/configure steps the RPi will advertise its hostname via mDNS, so you should be able to just run `ssh nomad@<hostname-from-config>.local` and log in. Nomad and Consul should all be happily running in the `homelab` datacenter.

There are additional options available; to see help, run `create-config --help`. Note: if you specify a GitHub username, public keys from that account will be copied to the nomad user's `authorized_keys` file; otherwise, the script will attempt to find a public key in your local `$HOME/.ssh` directory. Failing that, it will import nothing and you'll be unable to log in at all. (Sorry, but passwords are just no fun to generate, hash, update, etc. PRs welcome if you disagree.)

