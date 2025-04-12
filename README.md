## Ansible Playbook for Server Management, Setup and Configuration

This repository contains an Ansible Playbook to automate server setup and configuration. It uses a modular structure, allowing for easy extension and modification of tasks.

### How the Playbook Works
The playbook’s modular structure allows flexibility.  
**main.yml**: Entry point. Includes tasks from `users/`, `install_dependencies/`, `configurations/` and other directories.  

**Run the playbook:** `ansible-playbook -i hosts main.yml`

### Directory Structure

```plaintext
ansible-playbook/
├── README.md
├── configurations/
│   └── config_fpm_for_apache2.yml
├── hosts
├── install_dependencies/
│   ├── apache2.yml
│   └── php.yml
├── main.yml
└── users/
    ├── delete_user.yml
    └── manage_users.yml
```

### Key Files:

1. **main.yml**:  
   The main playbook that calls all other task files and manages the overall setup. Tasks are included with `include_tasks`, and variables are passed for customization.  

   **Execute with:** `ansible-playbook -i hosts main.yml -K`

   Used -K to prompt for password to run as become (root).
   If the user is passwordless then any random password would work.


2. **configurations/**:  
   Contains files that configure system services.  
   - **config_fpm_for_apache2.yml**: Configures Apache to use PHP-FPM.

3. **install_dependencies/**:  
   Files to install required dependencies.  
   - **apache2.yml**: Installs Apache with essential modules.  
   - **php.yml**: Installs PHP, related modules, and Composer.

4. **users/**:  
   Manages system users.  
   - **delete_user.yml**: Removes users from the system.  
   - **manage_users.yml**: Adds/Modifies users, sets up SSH keys.

5. **hosts**:  
   Defines target hosts for the playbook.