Jenkins
=======

Launch a jenkins service.

*IMPORTANT*:

This will work somehow, but not recommended for practical use. Running Jenkins on Raspberry Pi is
slow. It is better to create a Jenkins server outside Raspberry Pi and make Raspberry Pi
for its node. It might be faster.


Generated yaml data by `apply.sh` will create a StatefulSet and launch a pod on master node.

The pod will use a directory `/opt/volumes/jenkins` on master node.

Prepare
-------

1. create `/opt/volumes/jenkins` on the node which will run on, and chown 1000:1000 which
   jenkins will use.
2. build a docker image with `build-image.sh` script. Because official Jenkins docker images
   for ARM architecture are not provided, you have to build by own. `build-iamge.sh` will
   do this for you.

Run
---

Just call `apply.sh` to run. `delete.sh` to delete all.

Remember, you have to delete `/opt/volumes/jenkins` directory manually.
