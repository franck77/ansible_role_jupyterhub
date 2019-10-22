Role Jupyterhub
===============


![Jupyterhub logo](img/jupyterhub-logo.png "Jupyterhub logo")

This role is used to install, configure, update and manage jupyterhub

Requirements
------------

Java version 1.8.0_73 and more

Anaconda environnements installed, you can use the ansible role "https://sgithub.fr.world.socgen/BigDataHub-I2T/role_anaconda" to install environment.

Inventory
---------

Set your inventory for setting each Jupyter Hub host, example :

```
[jupyterhub]
host1
host2
...
hostn
```` 

Manage Jupyter Hub lifecycle
------------

 * Installing Jupyterhub ```state=role_jupyterhub_install```
 * Remove jupyterhub ```state=role_jupyterhub_remove```
 * Configure jupyterhub for  virtual kernels ```state=role_jupyterhub_config```
 * Start/Stop jupyter service ```state=role_jupyterhub_start/stop```
 * Upgrade jupyter hub ```state=role_jupyterhub_upgrade```

Role Variables
--------------

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

### Vars for Jupyter Hub
```
role_jupyterhub_install_dir: Base path for jupyterhub installation
role_jupyterhub_home_dir: Base path for jupyterhub user
role_jupyterhub_app_user_user: Username for jupyter hub 
role_jupyterhub_run_uid: UID user jupyterhub
role_jupyterhub_app_user_group: Groupe for jupyter hub
role_jupyterhub_run_guid: GID group jupyterhub
role_jupyterhub_port: public port for user's connexions
role_jupyterhub_application_log_level: Jupyter's Log Level
role_jupyterhub_kernel_pyenvs_to_activate: list env activate and enable in jupyterhub
role_jupyterhub_install_env: Name of env python for jupyter
role_conda_pyenvs: ### Specifique packages Format
 - name: "<env_python_jupyter"
   version: "<python_version>"
   description: "<env_description>"
   state: present
   libs:
     - {name: "<package1>", type: "<conda/pip>", state: "present"}
     - {name: "<package2>", type: "<conda/pip>", state: "present"}
	 ...
     - {name: "<packageN>", type: "<conda/pip>", state: "present"}
role_jupyterhub_http_proxy_cmd: Commande to run the proxy
role_jupyterhub_application_service_path: "/etc/systemd/system"
role_jupyterhub_application_service_name: "jupyterhub.service"
role_jupyterhub_conf_file : Jupyter Hub configuration file 
role_jupyterhub_pid_file : Jupyter Hub PID file
role_jupyterhub_log_path: Directory to redirect jupyter log
role_jupyterhub_log_file : File to redirect jupyter log
role_jupyterhub_log_dir_mode: Acces Mode for directory log
role_jupyterhub_version: Jupyter hub version to upgrade to in env python for jupyterhub
role_jupyterhub_sudospawner_version: Sudospawner version to upgrade to installed in env python for jupyterhub upgrade (if you use it)
role_jupyterhub_conf_http_proxy_version: HTTP Proxy version to upgrade to in env python for jupyterhub upgrade
role_jupyterhub_pyzmq_version: Pyzmq version to upgrade to in env python for jupyterhub upgrade
role_jupyterhub_ipykernel_version: ipykernel version to upgrade to in env python for jupyterhub upgrade
role_jupyterhub_tornado_version: Tornado version to upgrade to in env python for jupyterhub upgrade
```
	 
### Vars for the spawner
```
role_jupyterhub_spawnerclass: Spawner type
role_jupyterhub_spawner_debug: Debug log (True/False)
```

### Vars for PAM connexion
```
role_jupyterhub_pam_conf_path: Path to the directory pam
role_jupyterhub_pam_filename: Pam File for jupyterhub
role_jupyterhub_pam_group_path: File contains all groups which can access to Jupyter Hub
role_jupyterhub_groupe_pam:  List group access to Jupyter Hub
```

### Vars for ANACONDA
```
role_jupyterhub_anaconda_parent_dir: Base path for anaconda installation
role_jupyterhub_anaconda_dir_name: Anaconda default dir
role_anaconda_env_bin_dir: Path to bin directory in Jupyter python env
```

### Vars for Certificats
```
role_jupyterhub_cert_node_certificate: host of certificate
role_jupyterhub_cert_dir: Certificats directory
role_jupyterhub_ssl_cert: Certificat file
role_jupyterhub_ssl_key: Key file
```

Playbook
-----------

TBD

Dependencies
------------

Create environment python with anaconda

Create environment python for Jupyter Hub

Example Playbook
----------------

Create Python environment for Jupyter Hub + Install Jupyter Hub
```

- name: "Deploy Jupyter Hub"
  hosts: "jupyterhub"
  tasks:
    - name: "Launch role_anaconda to create python environment for Jupyter hub"
      include_role:
        name: role_anaconda
      vars:
        state: "role_conda_anaconda_whole_install"

    - name: "Launch role_jupyterhub with present state"
      become: True
      include_role:
        name: role_jupyterhub
      vars:
        state: "role_jupyterhub_whole_install"
```

Only install Jupyter Hub (you have to install an environment for Jupyter Hub before)
```

- name: "Deploy Jupyter Hub"
  hosts: "jupyterhub"
  tasks:
    - name: "Launch role_jupyterhub with present state"
      become: True
      include_role:
        name: role_jupyterhub
      vars:
        state: "role_jupyterhub_whole_install"
```

Upgrade Playbook Explanation
---------------------------

### workflow :

- This playbook is used to upgrade jupyterhub from 0.7.2 to 0.8.1
- It stops Jupyterhub, save the db, save the conf, upgrade jupyterhub, its dependencies and some more packages that we found relevant for this upgrade
- Try to update the db if possible (this action may fail without compromising the whole update)
- And restart Jupyterhub

### To improve :

- Make this playbook generic (if no version of jupyterhub is given then automatic update to the last available)
- Make additional packages update optional and from a configuration file
- Add a rollback...
- chain this task with __config.yml__

Author Information
------------------

Franck Vieira / Walid Namane / Wandrille Domin 
