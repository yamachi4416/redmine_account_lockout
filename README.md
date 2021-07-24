# Redmine Account Lockout
This plugin adds account lockout to redmine password authentication.

## Requirements
* Redmine 4.0 or later

## Install
1. Copy or git clone this plugin into redmine/plugins directory.

2. This plugin requires a migration. Run the following command to upgrade your database. (make a database backup before)
```
bundle exec rake redmine:plugins:migrate RAILS_ENV=production
```

3. Restart Redmine.

## Uninstall
1. Run the following command
```
bundle exec rake redmine:plugins:migrate NAME=account_lockout VERSION=0 RAILS_ENV=production
```
2. Remove this plugin from redmine/plugins directory.

3. Restart Redmine.

## Usage

### Setting
Administration > Plugins > Account Lockout plugin > Configure

| name | description |
|:-----|:------------|
| Lockout count | Set the number of login attempts to lock out |
| Lockout period (min) | Sets the time, in minutes, to limit login when locked out. It is also added if the user attempts password authentication during the locked out period. |

### Unlockout
How to Unlockout is following

* Reset password
  1. Administration > Users.
  2. Select the user to display the user's edit page.
  3. Reset the user's password.

* Unlockout
  1. Administration > Users.
  2. Select the user to display the user's edit page.
  3. Select Lockout tab.
  4. Click Reset button.
