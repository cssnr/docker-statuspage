# Docker Status Page
**registry.hosted-domains.com/public/status-page**

Single page Status Page updated every X seconds to display the status of your services.

Working example located here: [https://status.smwc.world/](https://status.smwc.world/)

## Quick Start
You can start an example by updating the [settings.env](settings.env) and using the sample [docker-compose.yml](docker-compose.yml) file.
```
git clone https://git.cssnr.com/shane/status-page.git
cd status-page
vim settings.env
docker-compose up -d
```
Then visit [https://localhost/](https://localhost/) to see the results.

# Configuration
Configuration is defined using environment variables. An example configuration is provided in the [settings.env](settings.env) file.

## General
The general settings are pretty straight forward:
```
SITE_TITLE=SMWC.world Status
SITE_DESCRIPTION=SMWC ROM Archive Website Status.
SITE_AUTHOR=Shane
SITE_HOME_URL=https://smwc.world/
SITE_FAVICON=https://smwc.world/static/images/favicon.ico
SITE_LOGO=https://smwc.world/static/images/logo.png
```

## Settings
A few optional configuration settings exist.
- `TZ`  
Used to display time in a specific time zone. Default will be UTC.
- `SETTING_SLEEP`  
How long the application sleeps in seconds before rechecking status. Default is 60.
- `SETTING_THEME`  
Name of a bootswatch theme to use. More information here: [https://bootswatch.com/](https://bootswatch.com/)

## Service Checks
Currently, only site checks exist.

### Site Checks
- They must start with `SITE_`.
- They are sourced in alphabetical order.
- There are 3 segments separated with a `|`.
  1. Display Name.
  2. Description Text.
  3. URL to check for status (not shown).

Example:
```
STATUS_A=SMWC.world Website|smwc.world|https://smwc.world/
STATUS_B=SMW Central Website|smwcentral.net|https://www.smwcentral.net/
```

# Additional Configuration
A few additional things you may want to do, but are not required.
### Data Volume
The html data is copied by default to `/data`. You can mount a voume to this location if desired as well as change it using the `DATA_DIR` environment varaible.
### SSL
SSL certificates are generated every container start. You can mount your own certificates through either a volume or docker secrets to the following locations:
- /ssl/ssl.crt
- /ssl/ssl.key


A docker-compose.yml file for production might look more like this:
```
version: '3.8'

services:
  app:
    image: registry.hosted-domains.com/public/status-page:latest
    env_file: settings.env
    deploy:
      replicas: 1
    volumes:
      - data_dir:/data
    secrets:
      - source: cssnr.com.crt
        target: /etc/ssl/cssnr.com.crt
      - source: cssnr.com.key
        target: /etc/ssl/cssnr.com.key
    ports:
      - "443:443"

secrets:
  cssnr.com.crt:
    file: /etc/ssl/cssnr.com.crt
  cssnr.com.key:
    file: /etc/ssl/cssnr.com.key

volumes:
  data_dir:
```
