#! /usr/bin/env bats

# Variable SUT_IP should be set outside this script and should contain the IP
# address of the System Under Test.

# Tests

@test 'Mount volume' {
  run bash -c "mkdir -p /mnt/testnfs"
  run bash -c "mount -t nfs ${SUT_IP}:/mnt/default /mnt/testnfs"
  [[ "${status}" -eq "0" ]]
}
@test 'Test write' {
  run bash -c "touch /mnt/testnfs/testfile"
  [[ "${status}" -eq "0" ]]
}
@test 'Test user/group' {
  run bash -c "ls -n /mnt/testnfs/testfile | awk '{print $3}'"
  [[ "${output}" =~ '560' ]]
  run bash -c "ls -n /mnt/testnfs/testfile | awk '{print $4}'"
  [[ "${output}" =~ '560' ]]
}
@test 'Umount the volume' {
  run bash -c "umount /mnt/testnfs"
}
