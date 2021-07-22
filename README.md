# Redmine Account Lockout
This plugin adds account lockout to redmine password authentication

## Install
1. Copy or git clone this plugin into redmine/plugins directory.

2. This plugin requires a migration. Run the following command to upgrade your database (make a database backup before):
```
bundle exec rake redmine:plugins:migrate RAILS_ENV=production
```

3. Restart Redmine.

## Usage

