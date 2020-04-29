[![Build Status](https://travis-ci.org/open-io/ansible-role-openio-nfs.svg?branch=20.04)](https://travis-ci.org/open-io/ansible-role-openio-nfs)
# Ansible role `nfs`

An Ansible role for installing an NFS server. Currently the install is opinionated and is designed for NFSv3 endpoints.
Support for more advanced NFSv4 configurations will come in the future

## Requirements

- Ansible 2.4+

## Role Variables


| Variable                    | Default | Comments (type)                             |
| --------------------------- | ------- | ------------------------------------------- |
| `openio_nfs_exports`        | `[]`    | List of mountpoints to deploy*              |
| `openio_nfs_provision_only` | `false` | Provision only, without restarting services |
| `openio_nfs_mountpoint_mode` | `0750` | Mountpoint's numeric mode                   |
| `openio_nfs_systemd_managed` | `true` | NFS server is managed by systemd |

> \* For export format, see *Example playbook*

## Dependencies

No dependencies.

## Example Playbook

```yaml
- hosts: nfs
  become: true
  vars:
    openio_nfs_exports:
    - mountpoint: "/mnt/default"
      client: "*"
      options:
      - "rw"
      - "async"
      - "all_squash"
      uid: 560
      gid: 560
  pre_tasks:
    - name: "Generate NFS users/groups"
      include_role:
          name: users
      vars:
          openio_users_groups:
          - groupname: "{{ 'nfsgroup_' + mount.gid | string }}"
            gid: "{{ mount.gid }}"
          openio_users_add:
          - username: "{{ 'nfsuser_' + mount.uid | string }}"
            uid: "{{ mount.uid }}"
            group: "{{ 'nfsgroup_' + mount.gid | string }}"
            groups: []
            home_create: false
            shell: "/sbin/nologin"
      with_items: "{{ openio_nfs_exports }}"
      loop_control:
        loop_var: mount
  roles:
    - role: nfs
```


```ini
[all]
node1 ansible_host=192.168.1.173

[nfs]
node1
```

## Contributing

Issues, feature requests, ideas are appreciated and can be posted in the Issues section.

Pull requests are also very welcome.
The best way to submit a PR is by first creating a fork of this Github project, then creating a topic branch for the suggested change and pushing that branch to your own fork.
Github can then easily create a PR based on that branch.

## License

GNU AFFERO GENERAL PUBLIC LICENSE, Version 3

## Contributors

- [Vladimir DOMBROVSKI](https://github.com/vdombrovski) (maintainer)
- [Cedric DELGEHIER](https://github.com/cdelgehier) (maintainer)
- [Romain ACCIARI](https://github.com/racciari) (maintainer)
- [Vincent LEGOLL](https://github.com/vincent-legoll) (maintainer)
