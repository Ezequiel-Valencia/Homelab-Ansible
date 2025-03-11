# Shift and Grow Shell Use Case
The shift and grow script works for a disk which is not live.
So for any disk that is used for the boot of system follow these steps instead.


# Grow Boot Disk

1. Get a USB stick that has Ubuntu on it and plug it into the computer whose boot needs to grow.

2. In Proxmox, turn the VM on and immediately start pressing "Escape". This will bring you
into Proxmox's boot loader options.

3. Choose the Ubuntu USB stick, and open GParted.

4. Turn swap off, and increase the size of the "extended" partition

5. Move swap to the right of the "extended" partition

6. Shrink the "extended" partition now to the size of swap with Alignment turned to "None".

7. With the new unallocated space, append it to the boot drive.

8. Save the changes, and turn swap back on.

9. Boot into the OS and make sure size is appropriate.


[Move Swap](https://superuser.com/questions/1627851/how-to-move-linux-swap-partition-gparted)
[Turn Alignment Off](https://askubuntu.com/questions/1251105/gparted-error-message-a-partition-can-not-end-156016640-after-the-end-of-the)

