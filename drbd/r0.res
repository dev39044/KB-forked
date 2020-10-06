resource r0 {
        protocol C;
        device /dev/drbd0;
        disk /dev/vg0/drbd-BACKEND-administrator;
        meta-disk /dev/vg0/drbd-meta-administrator;

	handlers {
            before-resync-target "/usr/lib/drbd/snapshot-resync-target-lvm.sh";
            after-resync-target "/usr/lib/drbd/unsnapshot-resync-target-lvm.sh";
        }
	
        net {
            verify-alg sha1;
            cram-hmac-alg sha1;
            shared-secret "<YOUR-PASSWORD-HERE>";
        }

        on panda {
                address 10.10.10.1:7788;
        }
        on panda3 {
                address 10.10.10.3:7788;
        }
}

